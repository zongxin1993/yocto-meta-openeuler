#!/usr/bin/env python

import argparse
import time
import yaml
import os
import shutil
import git
import docker
from io import BytesIO
import tarfile
from concurrent.futures import ThreadPoolExecutor,wait,ALL_COMPLETED
import multiprocessing

class CalTime:
    def __init__(self) -> None:
        self._lock = False
        self._start = 0
        self._end = 0
        self._duration = 0

    def start(self):
        if not self._lock:
            self._start = time.time()
            self._lock = True
        else:
            print("please end time before start")
        
    def end(self):
        if self._lock:
            self._end = time.time()
            self._duration = self._end - self._start
            self._lock = False
        else:
            print("please start time before end")
    
    def get_duration(self):
        if not self._lock:
            return round(self._duration, 1)
        else:
            return 0

class ErrMsg:
    TagInValid = "tag is invalid"



class DockerProxy(object):

    def __init__(self) -> None:
        self._docker = docker.DockerClient(base_url="unix://var/run/docker.sock",timeout=10)
    
    def __del__(self) -> None:
        self._docker = None

    def get_version(self):
        """
        get docker version.
        
        :param param1: this is a first param
        :returns: this is a description of what is returned
        :raises keyError: raises an exception
        """
        return self._docker.version()

    def get_image_list(self) -> list:
        """
        get docker images
        """
        images = self._docker.api.images()
        res = []

        for image in images:
            image_id = image["Id"].lstrip("sha256:")
            if image['RepoTags'] is not None:
                for image_name in image["RepoTags"]:
                    res.append({
                        'image_id': image_id,
                        'image_name': image_name
                    })
        return res
    
    def get_container_list(self) -> list:
        """
        get docker container
        """
        containers = self._docker.api.containers(all = True)
        res = []
        for container in containers:
            # print(container)
            container_name = container["Names"][0].lstrip("//")
            res.append({
                'container_id': container["Id"],
                'container_name': container_name,
                'status': container["State"]
            })
        return res

    def get_container_info(self, container_id = "", container_name = "") -> object:
        """
        get container info
        """
        info = {}
        try:
            if container_id != "":
                info = self._docker.api.inspect_container(container_id)
            elif container_name != "":
                info = self._docker.api.inspect_container(container_name)
        except:
            pass
        return info


    def create_container(self, image_name, conf = {}):
        container = self._docker.api.create_container(image_name, "bash", detach=True, stdin_open= True, tty=True)
        self.start_container(container_id=container["Id"])
        return container["Id"]
    
    def start_container(self, container_id):
        info = self.get_container_info(container_id=container_id)
        print(info["State"])
        if info == {}:
            return False
        if info["State"]["Running"] == True:
            print("running")
            return True
        else:
            print("no running")
            res = self._docker.api.start(container = info["Id"])
            return res == None

    def run_container_command(self, container_id, commands, work_dir=None, user = None):
        container = self._docker.containers.get(container_id=container_id)
        outs = ""
        for command in commands:
            container_output = container.exec_run(command,workdir=work_dir)
            out = str(container_output.output, 'utf-8').replace("\\n", "\n")
            outs += out
        return outs
    def run_container_command_stream(self, container_id, command, work_dir=None, user = None):
        container = self._docker.containers.get(container_id=container_id)
        container_output = container.exec_run(command,workdir=work_dir,socket=True,stream=True,user=user)
        return container_output.output

    def start_container_command_test(self, container_id, commands, work_dir=None, user = None):
        container = self._docker.containers.get(container_id=container_id)
        container_output = container.exec_run(commands,workdir=work_dir)
        out = str(container_output.output, 'utf-8').replace("\\n", "\n")
        return out
    
    def copy_to_container(self, container_id, source_path, to_path):
        tar = self.add_tar(source_path)
        return self._docker.api.put_archive(container=container_id,path = to_path,data = tar)

    def copy_from_container(self, container_id, from_path, dst_path):
        pw_tarstream = BytesIO()
        bits, _ = self._docker.api.get_archive(container_id, from_path)
        for trunk in bits:
            pw_tarstream.write(trunk)
        pw_tarstream.seek(0)
        tar = tarfile.open(fileobj = pw_tarstream)
        res = tar.extractall(path = dst_path)
        return res == None
    
    def stop_container(self, container_id):
        return self._docker.api.stop(container = container_id) == None

    def destory_container(self, container_id):
        info = self.get_container_info(container_id=container_id)
        if info == {}:
            return True
        if info["State"]["Running"] == True:
            self.stop_container(container_id)
        res = self._docker.api.remove_container(container_id)
        return res == None

    def pull_image(self, image_name):
        self._docker.api.pull(repository = image_name)

    @staticmethod
    def add_tar(path_dir) -> bytes:
        if os.path.exists(path = path_dir):
            pw_tarstream = BytesIO()
            pw_tar = tarfile.TarFile(fileobj=pw_tarstream, mode='w')
            pw_tar.add(name = path_dir, arcname=os.path.basename(path_dir))
            pw_tar.close()
            pw_tarstream.seek(0)
            return pw_tarstream
        
        return None

class OpenEulerDocker(DockerProxy):
    def __init__(self) -> None:
        super(OpenEulerDocker, self).__init__()
        self._image_remote = "swr.cn-north-4.myhuaweicloud.com/openeuler-embedded/openeuler-container"
        self._image_tag = ["22.09", "22.03-lts"]
        self._arch_list = [
            'aarch64-std',
            'aarch64-pro',
            'arm-std',
            'x86-64-std',
            'raspberrypi4-64',
            'riscv64-std'
        ],
        self._active_container = None
    
    def openeuler_start_container(self, tag):
        if not self.openeuler_is_tag_valid(tag):
            print(ErrMsg.TagInValid)

        self.openeuler_pull_image(tag)
        
        image_name = ':'.join([self._image_remote, tag])
        container_id =  self.create_container(image_name)
        self._active_container = container_id

    def openeuler_copy_repo(self, repo_list: list):
        cpu_count = multiprocessing.cpu_count()
        src_dir = "/usr1/openeuler/src"
        with ThreadPoolExecutor(max_workers = cpu_count) as t:
            all_task = []
            for repo_dir in repo_list:
                all_task.append(t.submit(self.copy_to_container, repo_dir, src_dir))
            wait(all_task, return_when = ALL_COMPLETED)

    def openeuler_is_tag_valid(self, tag : str) -> bool:
        '''
        judge tag in openeuler tags
        '''
        return tag in self._image_tag

    def openeuler_is_image_ok(self, tag : str) -> bool:
        if not self.openeuler_is_tag_valid(tag):
            print(ErrMsg.TagInValid)
            return False
        images = self.get_image_list()
        openeuler_image = ':'.join([self._image_remote, tag])
        for image in images:
            if openeuler_image == image['image_name']:
                return True
        return False
    
    def openeuler_image_list(self):
        openeuler_images = []
        for tag in self._image_tag:
            openeuler_images.append(':'.join([self._image_remote, tag]))
        res = []
        images = self.get_image_list()
        for image in images:
            if image['image_name'] in openeuler_images:
                res.append(image)
        return res

    def openeuler_pull_image(self, tag):
        if not self.openeuler_is_tag_valid(tag):
            print(ErrMsg.TagInValid)
        openeuler_image = ':'.join([self._image_remote, tag])
        self.pull_image(openeuler_image)
    
    def openeuler_arch_list(self):
        return self._arch_list

    def openeuler_compile(self):
        command = """
su openeuler
source compile.sh {} /usr1/build
bitbake {}
        """.format("aarch64-std", "openeuler-image-tiny")
        work_dir = "/usr1/openeuler/src/yocto-meta-openeuler/scripts"
        container_id = self._active_container
        out = self._docker.run_container_command_stream(container_id, command=command, work_dir=work_dir,user="openeuler")
        while True:
            try:
                outstr = out.readline()
                output = str(outstr, "utf-8").replace("\\n","\n")
                print(output)
            except Exception as e:
                print(e)  

def pull_image(tag):
    openEulerDocker = OpenEulerDocker()
    openEulerDocker.pull_image(tag)

def docker_list():
    openEulerDocker = OpenEulerDocker()
    for tag in openEulerDocker._image_tag:
        image_name = openEulerDocker._image_remote + ":" + tag
        print(image_name)

def print_arch_list():
    openeulerDocker = OpenEulerDocker()
    print("openeuler supportted platform:")
    arch_list = openeulerDocker.openeuler_arch_list()
    for arch in arch_list:
        print("----%s" % arch)

def check_docker() -> bool:
    '''
    check docker software is installed
    '''
    return shutil.which("docker") != None

def install_docker() -> bool:
    '''
    install docker software
    '''
    pass

def check_openeuler_image(tag : str) -> bool:
    '''
    check openeuler container is pulled
    '''
    openeulerDocker = OpenEulerDocker()
    if openeulerDocker.is_tag_in_openeuler():
        return True
    
    images = openeulerDocker.get_image_list()
    openeuler_image = ':'.join(openeulerDocker._image_remote,tag)
    for image in images:
        if  openeuler_image == image["image_name"]:
            return True
    return False

def pull_openeuler_image(tag) -> bool:
    '''
    pull openeuler image
    '''
    pass


codelist = [
    "kernel-5.10",
    "src-kernel-5.10",
    "busybox",
    "dsoftbus_standard",
    "libboundscheck",
    "yocto-embedded-tools",
    "yocto-poky",
    "yocto-pseudo",
    "audit",
    "cracklib",
    "libcap-ng",
    "libpwquality",
    "openssh",
    "libnsl2",
    "openssl",
    "pam",
    "shadow",
    "ncurses",
    "bash",
    "libtirpc",
    "grep",
    "pcre",
    "less",
    "gzip",
    "xz",
    "lzo",
    "lz4",
    "bzip2",
    "sed",
    "json-c",
    "ethtool",
    "expat",
    "acl",
    "attr",
    "readline",
    "libaio",
    "libffi",
    "popt",
    "binutils",
    "elfutils",
    "kexec-tools",
    "psmisc",
    "squashfs-tools",
    "strace",
    "util-linux",
    "libsepol",
    "libselinux",
    "libsemanage",
    "policycoreutils",
    "initscripts",
    "libestr",
    "libfastjson",
    "logrotate",
    "rsyslog",
    "cifs-utils",
    "dosfstools",
    "e2fsprogs",
    "iproute",
    "iptables",
    "dhcp",
    "libhugetlbfs",
    "libnl3",
    "libpcap",
    "nfs-utils",
    "rpcbind",
    "cronie",
    "kmod",
    "libusbx",
    "libxml2",
    "lvm2",
    "quota",
    "pciutils",
    "procps-ng",
    "tzdata",
    "glib2",
    "raspberrypi-firmware",
    "gmp",
    "gdb",
    "libmetal",
    "OpenAMP",
    "sysfsutils",
    "tcl",
    "expect",
    "jitterentropy-library",
    "m4",
    "gdbm",
    "libtool",
    "libidn2",
    "libunistring",
    "gnutls",
    "nettle",
    "rng-tools",
    "bash-completion",
    "coreutils",
    "findutils",
    "gawk",
    "libmnl",
    "libuv",
    "flex",
    "sqlite",
    "bison",
    "perl",
    "userspace-rcu",
    "lttng-ust",
    "libdb",
    "groff",
    "nasm",
    "syslinux",
    "cdrkit",
    "yocto-opkg-utils",
    "python3",
    "libgpg-error",
    "libgcrypt",
    "kbd",
    "autoconf-archive",
    "libxslt",
    "dbus",
    "wpa_supplicant",
    "grub2",
    "parted",
    "intltool",
    "tar",
    "perl-XML-Parser",
    "systemd",
    "gnu-efi",
    "screen",
    "pcre2",
    "mosquitto",
    "uthash",
    "ppp",
    "libdrm"
]
isulad_list = [
    'zlib', 
    'libcap', 
    'yajl', 
    'libseccomp', 
    'curl', 
    'lxc', 
    'lcr', 
    'libarchive', 
    'libevent', 
    'libevhtp', 
    'http-parser', 
    'libwebsockets', 
    'iSulad'
]

def clone_repo(remote, src_dir, name, tbranch, reversion = None):
    '''
    git clone repo
    :param remote: git remote addr
    :param src_dir: code download dir
    :param name: the repo name
    :param tbranch: the repo branch
    :param reversion: the repo will reset this reversion
    :return: None 
    '''
    print("now clone %s ..." % name)
    local_path = os.path.join(src_dir, name)
    repo = None
    if os.path.exists(local_path):
        repo = git.Repo(local_path)
        repo.git.checkout(tbranch)
    else:
        repo = git.Repo.clone_from(remote, to_path = local_path, branch = tbranch)
    if reversion != None:
        repo.git.reset('--hard', reversion)
    print("clone %s finished" % name)

def thread_clone_repo(src_dir, repo_list):
    '''
    Multithreading for downloading repos
    :param src_dir: the repo code download dir
    :param repo_list: this repos will downloaded
    :return: None
    '''
    cpu_count = multiprocessing.cpu_count()
    with ThreadPoolExecutor(max_workers = cpu_count) as t:
        all_t = []
        for item in repo_list:
            obj = t.submit(
                clone_repo, 
                remote = item["path"], 
                src_dir = src_dir, 
                name = item["name"], 
                tbranch = item["branch"], 
                reversion = item.get("reversion", None))
            all_t.append(obj)
        wait(all_t, return_when=ALL_COMPLETED)

def download_repo(code_dir : str, repo_name: str, tbranch: str):
    '''
    download signal repo
    :param code_dir: the repo code download dir
    :param repo_name: the repo name
    :param tbranch: the repo branch
    :return: None
    '''
    code_dict = get_code_dict(code_dir)
    if repo_name not in code_dict:
        print("repo_name %s is not internel repo" % repo_name)
        return

    cal_time = CalTime()
    
    src_dir = os.path.abspath(os.path.join(os.getcwd(),"../.."))
    item = code_dict[repo_name]
    cal_time.start()
    clone_repo(item["path"], src_dir=src_dir, name = repo_name, tbranch=tbranch)
    cal_time.end()

    print("============================download successful==============================")
    print("repo_name: %s" % repo_name)
    print("src_dir: %s" % src_dir)
    print("branch: %s" % tbranch)
    print("repo clone duration: %s second" % cal_time.get_duration())
    print("=============================================================================")
    
def download_source_code(code_dir : str, src_branch: str, kernel_branch : str):
    '''
    download source code with standard image
    :param code_dir: the repo code download dir
    :src_branch: the standard code branch
    :kernel_branch: the kernel code branch
    :return: None
    '''
    code_dict = get_code_dict(code_dir)
    src_dir = os.path.abspath(os.path.join(os.getcwd(),"../.."))
 
    cal_time = CalTime()

    cal_time.start()
    # download codelist
    repo_list = []
    for name in codelist:
        item = code_dict[name]
        tbranch = item["branch"] if item.get("branch") != "src_branch" and item.get("branch") != "kernel_branch" else (src_branch if item["branch"] == "src_branch" else kernel_branch)
        item["branch"] = tbranch
        repo_list.append(item)
    thread_clone_repo(src_dir=src_dir, repo_list=repo_list)

    # download isuladcode
    repo_list = []
    for name in isulad_list:
        item = code_dict[name]
        tbranch = item["branch"] if item.get("branch") != "src_branch" and item.get("branch") != "kernel_branch" else (src_branch if item["branch"] == "src_branch" else kernel_branch)
        item["branch"] = tbranch
        repo_list.append(item)
    thread_clone_repo(src_dir=src_dir, repo_list=repo_list)
    cal_time.end()

    print("==============================download successful============================")
    print("src_dir: %s: " % src_dir)
    print("src_branch: %s" % src_branch)
    print("kernel_branch: %s" % kernel_branch)
    print("repo clone duration: %s" % cal_time.get_duration())
    print("=============================================================================")

def download_from_manifest(manifest_dir : str):
    '''
    download source code with manifest
    :param manifest_dir: the repo code from this file
    :return: None
    '''
    with open(manifest_dir, 'r') as f:
        f_cont = f.read()
        y_cont = yaml.load_all(f_cont, yaml.Loader)
        manifest_dict = {}
        for item in y_cont:
            manifest_dict = item
            break
        repo_list = manifest_dict["projects"]
        src_dir = os.path.abspath(os.path.join(os.getcwd(),"../.."))
        cal_time = CalTime()
        cal_time.start()
        thread_clone_repo(src_dir=src_dir, repo_list=repo_list)
        cal_time.end()
        print("==============================download successful============================")
        print("repo manifest dir: %s: " % manifest_dir)
        print("download dir: %s" % src_dir)
        print("repo clone duration: %s" % cal_time.get_duration())
        print("=============================================================================")

def clean(repo_name):
    '''
    clean signal repo
    :param repo_name: which repo will be deleted
    :return: None
    '''
    src_dir = os.path.abspath(os.path.join(os.getcwd(),"../.."))
    local_path = os.path.join(src_dir, repo_name)
    delete_dir(local_path)

def cleanall():
    '''
    cleanall repos with standard image
    :return: None
    '''
    src_dir = os.path.abspath(os.path.join(os.getcwd(),"../.."))
    cpu_count = multiprocessing.cpu_count()
    # delete codelist
    with ThreadPoolExecutor(max_workers = cpu_count) as t:
        all_t = []
        for name in codelist:
            local_path = os.path.join(src_dir, name)
            obj = t.submit(
                delete_dir,
                local_path
            )   
            all_t.append(obj)
    with ThreadPoolExecutor(max_workers = cpu_count) as t:
        all_t = []
        for name in isulad_list:
            local_path = os.path.join(src_dir, name)
            obj = t.submit(
                delete_dir,
                local_path
            )   
            all_t.append(obj)

def delete_dir(del_dir):
    '''
    delete the dir
    :param del_dir: this dir will be deleted
    :return: None
    '''
    if os.path.exists(del_dir):
        try:
            shutil.rmtree(del_dir)
            print("delete repo successful : %s" % del_dir)
        except Exception as e:
            print(e)
            print("delete repo faild : %s" % del_dir)
    else:
        print("delete repo successful : %s" % del_dir)

def get_code_dict(code_dir : str):
    code_lists = get_code_lists(code_dir)
    code_dict = {}
    for item in code_lists:
        code_dict[item["name"]] = item
    return code_dict

def get_code_lists(code_dir : str):
    with open(code_dir, 'r') as f:
        cont = f.read()
        y_cont = yaml.load_all(cont, yaml.Loader)
        for item in y_cont:
            return item.get("projects", [])

def compile(typ = "direct"):
    '''
    compile
    '''
    openeulerDocker = OpenEulerDocker()
    openeulerDocker.openeuler_start_container("22.09")
    own_dir = os.path.abspath(os.path.join(os.getcwd(),"../../yocto-meta-openeuler"))
    openeulerDocker.openeuler_copy_repo([own_dir])
    if typ != "direct":
        download_source_code()
    
    openeulerDocker.openeuler_compile()

def export_yaml(code_dir : str,dist_dir = "conf/manifest.yaml"):
    '''
    创建yaml文件
    '''
    dict = {}
    manifest = {
        "name": "yocto-meta-openeuler",
        "branch": "",
        "path": "",
        "reversion": ""
    }
    parent_dir = os.path.abspath(os.path.join(os.getcwd(),"../.."))
    own_dir = os.path.join(parent_dir, manifest["name"])
    repo = git.Repo(own_dir)
    manifest["branch"] = repo.active_branch.name
    manifest["path"] = repo.remote().url
    manifest["reversion"] = repo.git.log('-1','--pretty=%H').split("\n")[0]

    dict["manifest"] = manifest
    projects = []
    code_dict = get_code_dict(code_dir=code_dir)
    src_dir = parent_dir
    for name in code_dict:
        local_path = os.path.join(src_dir, name)
        if os.path.isdir(local_path):
            try:
                item = {}
                repo = git.Repo(local_path)
                item["name"] = name
                item["revision"] = repo.git.log('-1','--pretty=%H').split("\n")[0]
                item["path"] = repo.remote().url
                item["branch"] = repo.active_branch.name
                projects.append(item)
            except:
                continue
    dict["projects"] = projects
    with open(dist_dir, 'w') as file:
        yaml.dump(dict,file)
        file.close()

class Progress(git.remote.RemoteProgress):
    def update(self, op_code, cur_count, max_count=None, message=''):
        print('update(%s, %s, %s, %s)' % (op_code, cur_count, max_count, message))

def init_args():
    """
    init args
    :return:
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("action")
    parser.add_argument("-f", type=str, dest="file_dir", help="manifest.yaml dir", required=False)
    parser.add_argument("-j", type=str, dest="thread_num", default="cpu process num", help="download thread num", required=False)
    parser.add_argument("-r", type=str, dest="repo", default="", help="repo name", required=False)
    parser.add_argument("-arch", type=str, dest="arch", default="aarch64", help="arch name", required=False)
    parser.add_argument("-srcb", type=str, dest="src_branch", default="master", help="", required=False)
    parser.add_argument("-kerb", type=str, dest="kernel_branch", default="5.10.0-106.6.0", help="", required=False)
    parser.add_argument("-cmpt", type=str, dest="compile_type", default="fetch", help="compile type", required=False)

    return parser.parse_args()

def usage():
    help = '''
Usage:
python coder.py <action> [options]
---------------------------------------------------------------------------------
action:
    downloadall     download all register repo
    download        download signal repo
    exportyaml      export repo git configure information
    clean           delete repo which select
    cleanall        delete all repo which register
    build           build images(todo)
    archlist        list all supported arch
    help            print help information

---------------------------------------------------------------------------------
options:
    -f              file dir for action with exportyaml and downloadall
    -j              thread_num to optimize system
    -r              repo name for action with download and clean
    -arch           arch name example aarch64-std or arm-std
    -srcb           src branch for example: openEuler-22.09
    -kerb           kernel branch for example: 5.10.0-106.6.0
    -bt             build type (todo)
    '''
    print(help)

def main():
    args = init_args()
    action=args.action
    if action == "downloadall":
        if args.file_dir is None:
            src_branch = "openEuler-22.09"
            kernel_branch = "5.10.0-106.18.0"
            download_source_code("conf/codelist.yaml", src_branch=src_branch, kernel_branch=kernel_branch)
        else:
            download_from_manifest(args.file_dir)
    elif action == "download":
        repo = args.repo
        tbranch = "openEuler-22.09"
        download_repo("conf/codelist.yaml", repo_name=repo, tbranch=tbranch)
    elif action == "exportyaml":
        yaml_dir = args.file_dir
        export_yaml("conf/codelist.yaml", yaml_dir)
    elif action == "clean":
        repo = args.repo
        clean(repo_name = repo)
    elif action == "cleanall":
        cleanall()
    elif action == "compile":
        compile_typ = args.compile_type
        compile(typ = compile_typ)
    elif action == "archlist":
        print_arch_list()
    elif action == "test":
        # check_openeuler_image("latest")
        openeulerDocker = OpenEulerDocker()
        ver = openeulerDocker.openeuler_image_list()
        print(ver)
    elif action == "help":
        usage()
    else:
        usage()

if __name__ == "__main__":
    main()