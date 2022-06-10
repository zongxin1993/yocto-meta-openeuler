#!/usr/bin/env python

import argparse
import yaml
import os
from git.repo import Repo

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
    for index,item in enumerate(items):
        process = (index+1)/total * 100
        finish = "#" * int((index + 1) * per)
        need = "-" * int((total - index - 1) * per)
        item_name = "{0:<30}".format(item["name"])
        print("\r {:^3.0f}%[{}{}] now cloneing...: {}".format(process, finish, need, item_name), end = "")
        local_path = os.path.join(parent_dir, item['name'])
        if os.path.exists(local_path):
            repo = Repo(local_path)
            repo.git.checkout(upstream)
            repo.git.reset('--hard', item['revision'])
        else:
            remote = base_url + item['path'] + ".git"
            Repo.clone_from(remote, to_path = local_path, branch = upstream)

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

def main():
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