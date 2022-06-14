#!/usr/bin/env python

import argparse
import yaml
import os
import git
import sys
from concurrent.futures import ThreadPoolExecutor

def analay_yaml(yaml_dir = "conf/manifest.yaml"):
    with open(yaml_dir, 'r') as yaml_file:
        try:
            dict = yaml.load(yaml_file.read(), Loader=yaml.SafeLoader)
            return dict
        except yaml.YAMLError as exec:
            print("exec: %s", exec)

def create_yaml(dist_dir = "conf/manifest.yaml"):
    dict = {}
    manifest = {
        "upstream": "openEuler-22.03-LTS",
        "base-url": "https://gitee.com",
        "path": "/openeuler/yocto-meta-openeuler.git"
    }
    dict["manifest"] = manifest
    projects = []
    parent_dir = os.path.join(os.getcwd(),"../..")
    listdir = os.listdir(parent_dir)
    for dir in listdir:
        if os.path.isdir(os.path.join(parent_dir,dir)) and dir != "yocto-meta-openeuler":
            try:
                local_path = os.path.join(parent_dir, dir)
                item = {}
                repo = Repo(local_path)
                item["name"] = dir
                item["revision"] = repo.git.log('-1','--pretty=%H').split("\n")[0]
                remote = repo.git.remote('-v').split("\n")[0]
                path = remote.split(" ")[0].split('\t')[1]
                path = path.replace("https://gitee.com","")
                item["path"]=path
                projects.append(item)
            except:
                continue
    dict["projects"] = projects
    file = open(dist_dir,'w')
    yaml.dump(dict,file)
    file.close()

def update_component(base_url,upstream,items):
    parent_dir = os.path.join(os.getcwd(),"../..")
    t = 50
    total = len(items)
    per = t / total
    thread_pool = ThreadPoolExecutor(max_workers = 15)
    for index,item in enumerate(items):
        # process = (index+1)/total * 100
        # finish = "#" * int((index + 1) * per)
        # need = "-" * int((total - index - 1) * per)
        # item_name = "{0:<30}".format(item["name"])
        # print("\r {:^3.0f}%[{}{}] now cloneing...: {}".format(process, finish, need, item_name), end = "")
        thread_pool.submit(clone_repo,parent_dir=parent_dir,upstream=upstream,base_url=base_url,item=item)
    thread_pool.shutdown(cancel_futures=True)

def clone_repo(parent_dir, upstream, base_url, item):
    print("now clone...: %s" % item['name'])
    local_path = os.path.join(parent_dir, item['name'])
    if os.path.exists(local_path):
        repo = git.Repo(local_path)
        repo.git.checkout(upstream)
        repo.git.reset('--hard', item['revision'])
    else:
        remote = base_url + item['path'] + ".git"
        git.Repo.clone_from(remote, to_path = local_path, branch = upstream, progress=Progress())
    print("clone: %s finish" % item['name'])

class Progress(git.remote.RemoteProgress):
    def update(self, op_code, cur_count, max_count=None, message=''):
        print('update(%s, %s, %s, %s)' % op_code, cur_count, max_count, message)

def init_args():
    """
    init args
    :return:
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("action")
    parser.add_argument("-f", type=str, dest="file_dir", default="conf/manifest.yaml", help="manifest.yaml dir", required=False)

    return parser.parse_args()

def usage():
    print("usage")

def unit_test():
    parent_dir = os.path.join(os.getcwd(),"../..")
    upstream = "openEuler-22.03-LTS"
    item = {
        "name": "libfastjson",
        "path": "//src-openeuler/libfastjson.git",
        "revision": "f41e3c0d607ae6c23df288532dce5c8c40aa6e11"
    }
    base_url = "https://gitee.com"
    clone_repo(parent_dir=parent_dir,upstream=upstream,base_url=base_url,item=item)

def main():
    is_test = True
    if is_test:
        unit_test()
        sys.exit(0)
    args = init_args()
    action=args.action
    if action=="updatesub":
        dict = analay_yaml(args.file_dir)
        manifest = dict["manifest"]
        projects = dict["projects"]
        update_component(manifest['base-url'],manifest['upstream'],projects)
    elif action=="createyaml":
        yaml_dir = args.file_dir
        create_yaml(yaml_dir)
    else:
        usage()

if __name__ == "__main__":
    main()