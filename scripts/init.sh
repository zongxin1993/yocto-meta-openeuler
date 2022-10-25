#!/bin/bash

baseDir=`pwd`
oebuilderPath=$baseDir/oebuilder/bin
export PATH=$PATH:${oebuilderPath}
hello()
{
    cat <<EOF
you can run oebuilder [command] [option] to do what you want to do

command:
    build: this command is to build image, you must do it with necessary param, eg:
        oebuilder build <arch_type> <image_type> <workdir>
        -- arch_type:   this is for cpu_platform for example aarch64-std,arm-std or aarch64-pro and so on
        -- package:  this is for build package for example openeuler-image(standard) or openeuler-image-tiny(tiny) and busybox and so on
        -- workdir:     this is for workspace, the workspace is to store source code and build directory, you can find what you want in this directory
        then if you want build a standard image with platform aarch64-std in /home/ubuntu/Desktop/work workspace, you can run following command:
        oebuilder build aarch64-std openeuler-image /home/ubuntu/Desktop/work
        note:
            You have to make sure that you have permissions in workspace
    setenv: this command is to set environment if you want use 'bitbake' command next
        now environment param has following list:
        -- WORK_SPACE: this is for workspace that you run bitbake and the source code and build result output
        -- ARCH_TYPE: this is for cpu_platform for example aarch64-std,arm-std or aarch64-pro and so on
    showenv: this command is showing environment that you set
    bitbake: this command is that you want to run bitbake and then has a peusdo-tty to nteract with mathine, when you run bitbake, you will open a build environment,
        it is a linux system standard but is to run some commands about yocto-poky, for example bitbake busybox -c do_fetch and so on
EOF
}
hello