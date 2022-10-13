import logging
import os
import yaml

logging.basicConfig(level = logging.INFO, format = '%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger()

def parse_download():
    with open("download_code.sh", 'r') as f:
        code_line_list = []
        for line in f.readlines():
            line = line.replace("\r", "").replace("\n", "").replace("\t", "").strip(" ")
            if line.startswith("update_code_repo "):
                if "$name" in line:
                    continue
                code_line_list.append(line)
            if line.startswith("SRC_BRANCH"):
                line_split = line.strip(" ").split("=")
                src_branch = line_split[1].replace("\"", "")
            if line.startswith("KERNEL_BRANCH"):
                line_split = line.strip(" ").split("=")
                kernel_branch = line_split[1].replace("\"", "")

        # for line_code in code_list:
        logger.info("SRC_BRANCH : {}".format(src_branch))
        logger.info("KERNEL_BRANCH : {}".format(kernel_branch))

        code_list = []
        prefix = "https://gitee.com/"
        for code_line in code_line_list:
            code_line_split = code_line.split(" ")
            if "SRC_BRANCH" in code_line_split[2]:
                branch = "src_branch"
            elif "KERNEL_BRANCH" in code_line_split[2]:
                branch = "kernel_branch"
            else:
                branch = code_line_split[2]
            
            if len(code_line_split) < 4:
                repo = code_line_split[1].split("/")[1]
            else:
                repo = code_line_split[3]
            
            path = code_line_split[1]

            code_list.append({"name": repo, "branch": branch, "path": prefix+path+".git"})

        return code_list

code_list = parse_download()

if os.path.exists("conf/codelist.yaml"):
    os.remove("conf/codelist.yaml")

os.mknod("conf/codelist.yaml")

print(code_list)

with open("conf/codelist.yaml", 'w') as f:
    codes = {"projects": code_list}
    f.write(yaml.dump(codes))