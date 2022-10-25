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
        -- image_type:  this is for build image type for example openeuler-image(standard) or openeuler-image-tiny(tiny)
        -- workdir:     this is for workspace, the workspace is to store source code and build directory, you can find what you want in this directory
        then if you want build a standard image with platform aarch64-std in /home/ubuntu/Desktop/work workspace, you can run following command:
        oebuilder build aarch64-std openeuler-image /home/ubuntu/Desktop/work
        note:
            You have to make sure that you have permissions in workspace
EOF
}
hello