#!/bin/python3
import os
import sys
import shutil
import subprocess

workSpace = "/home/lisir/Desktop/project/openeuler/workspace"
if not os.path.exists(workSpace):
    os.makedirs(workSpace)

srcDir = os.path.join(workSpace, "src")
if not os.path.exists(srcDir):
    os.mkdir(srcDir)

yoctoDir = os.path.join(srcDir, "yocto-meta-openeuler")
if os.path.exists(yoctoDir):
    shutil.rmtree(yoctoDir)

# copy yocto-meta-openeuler to src directory
baseDir =  os.path.abspath(os.path.join(sys.argv[0],"..","..",".."))
shutil.copytree(baseDir, yoctoDir)

buildStr = '''
. /opt/buildtools/nativesdk/environment-setup-x86_64-pokysdk-linux
. /home/jenkins/work/src/yocto-meta-openeuler/scripts/compile.sh aarch64-std /home/jenkins/work/build
bitbake openeuler-image
'''
buildDir = os.path.join(workSpace, "build.sh")
if os.path.exists(buildDir):
    os.remove(buildDir)

with open(buildDir, 'w') as f:
    f.write(buildStr)

imageName = "swr.cn-north-4.myhuaweicloud.com/openeuler-embedded/openeuler-ci-test:22.09"

command = '''
python oebuilder_docke.py exec -v {} -c {} -i {} -u {}
'''.format(workSpace+":/home/jenkins/work", "/home/jenkins/work/build.sh", imageName, "jenkins")
nowtime = subprocess.Popen(command, shell = True, stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
for line in nowtime.stdout.truncate():
    print(line)