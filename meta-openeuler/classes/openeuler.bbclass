# this class contains global method and variables for openeuler embedded

# set_rpmdpes is used to set RPMDEPS which comes from nativesdk/host
python set_rpmdeps() {
    import subprocess
    rpmdeps = d.getVar('RPMDEPS', True)
    if not rpmdeps or rpmdeps == "default":
        rpmdeps  = subprocess.Popen('rpm --eval="%{_rpmconfigdir}"', shell=True, stdout=subprocess.PIPE)
        stdout, stderr = rpmdeps.communicate()
        d.setVar('RPMDEPS', os.path.join(str(stdout, "utf-8").strip(), "rpmdeps --alldeps --define '__font_provides %{nil}'"))
}

addhandler set_rpmdeps
set_rpmdeps[eventmask] = "bb.event.RecipePreFinalise"

python do_download() {
    import os
    import sys
    import yaml
    import git
    import random
    from git import InvalidGitRepositoryError

    # init repo in the repo_dir
    def init_repo(repo_dir, repo_conf, tbranch):
        try:
            # if repo has finished git init and then do nothing
            repo = git.Repo(repo_dir)
            return
        except:
            # do git init action in empty directory
            repo = git.Repo.init(repo_dir)
            git.Remote.add(repo = repo, name = "origin", url = repo_conf['path'])
            with repo.config_writer() as wr:
                wr.set_value('http', 'sslverify', 'false').release()
            repo.remote().fetch()
            if repo.active_branch.name == tbranch:
                repo.active_branch.checkout()
            else:
                repo.git.checkout(tbranch)

    # add a file lock in the dir for compete
    def add_lock(dir):
            lock_file = os.path.join(dir, "file.lock")
            try:
                os.mknod(lock_file)
                return True
            except FileExistsError:
                return True
            except:
                return False

    def remove_lock(dir):
        lock_file = os.path.join(dir, "file.lock")
        try:
            os.remove(lock_file)
            return True
        except FileNotFoundError:
            return True
        except:
            return False

    def get_repo_list(code_dir):
        repo_confs = []
        with open(code_dir, 'r') as f:
            f_cont = f.read()
            y_cont = yaml.load_all(f_cont, yaml.Loader)
            code_projects = {}
            for item in y_cont:
                code_projects = item
            repo_lists = code_projects.get('projects', {})
            for item in repo_lists:
                name = item.get('name', '')
                if name in repo_names:
                    repo_confs.append(item)
                    if len(repo_confs) >= len(repo_names):
                        break
        return repo_confs

    # get source directory where to download
    src_dir = d.getVar('OPENEULER_SP_DIR')
    
    # make sure repo depends to download before
    repo_names = []
    if d.getVar('DOWNLOAD_REPO'):
        download_name = d.getVar('DOWNLOAD_REPO')
        repo_names = download_name.split(" ")
    else:
        repo_names = [d.getVar('OPENEULER_REPO_NAME')]

    # get codelist dir for next action because downloading need some necessary param
    code_dir = d.getVar('CODECONF_DIR')

    # the next code block is to get depends params and append to repo_confs variable
    repo_confs = get_repo_list(code_dir)
    
    if len(repo_confs) < len(repo_names):
        return

    # src_branch and kernel_branch variable is used to download depends code
    src_branch = d.getVar('SRC_BRANCH')
    kernel_branch = d.getVar('KERNEL_BRANCH')

    if_lock=False
    try:
        code_dir = d.getVar('CODECONF_DIR')
        for repo_conf in repo_confs:
            repo_dir = os.path.join(src_dir, repo_conf['name'])
            lock_file = os.path.join(repo_dir, "file.lock")

            path = repo_conf.get('path', '')
            
            # conform tbranch because repo has a uncertain branch
            tbranch = repo_conf.get('branch', '')
            if tbranch == "src_branch":
                tbranch = src_branch
            elif tbranch == "kernel_branch":
                tbranch = kernel_branch

            if not os.path.exists(repo_dir):
                os.mkdir(repo_dir)

                # create file.lock for other component compete
                add_lock(repo_dir)
                if_lock=True

                # checkout repo code
                init_repo(repo_dir, repo_conf, tbranch)
        
                # delete lock file
                remove_lock(repo_dir)
            else:
                while True:
                    if os.path.exists(lock_file):
                    # wait repo pull finished
                        time.sleep(random.randint(0,3))
                        continue
                    else:
                        # create file.lock for other component compete
                        add_lock(repo_dir)
                        if_lock=True
                        
                        # checkout repo code
                        init_repo(repo_dir, repo_conf, tbranch)
                
                        # delete lock file
                        remove_lock(repo_dir)
                        break

    except Exception as e:
        bb.plain("==============")
        bb.plain("OPENEULER_REPO_NAME %s " % d.getVar('OPENEULER_REPO_NAME'))
        for name in repo_names:
            bb.plain("repo_name %s " % name)
        bb.plain("branch %s " % tbranch)
        bb.plain("repo_conf len %d " % len(repo_confs))
        bb.plain("==============")
        if if_lock:
            remove_lock(repo_dir)
        bb.fatal(e)
}

addtask do_download before do_fetch
