#!/bin/bash

check_build()
{
    if [ -z "${BUILD_ARCH}" ];then
        return 1;
    fi

    if [ -z "${BUILD_IMAGE}" ];then
        return 1;
    fi

    if [ -z "${BUILD_WORK}" ];then
        return 1;
    fi

    return 0
}

build()
{
    test -d ${BUILD_WORK} || mkdir -p ${BUILD_WORK}

    local srcDir=${BUILD_WORK}/src
    test -d ${srcDir} || mkdir -p ${srcDir}

    local yoctoDir=${srcDir}/yocto-meta-openeuler
    test -d ${yoctoDir} && rm -rf ${yoctoDir}

    local baseDir=`cd $(cd $(dirname $0);pwd)/../..;pwd`
    cp -r ${baseDir} $srcDir

    local shellDir=${BUILD_WORK}/build.sh
    test -f ${shellDir} && rm -f ${shellDir}

    local buildDir=build_${BUILD_ARCH}_${BUILD_IMAGE}

    cat > ${shellDir} << EOF
. /opt/buildtools/nativesdk/environment-setup-x86_64-pokysdk-linux
. /home/jenkins/work/src/yocto-meta-openeuler/scripts/compile.sh ${BUILD_ARCH} /home/jenkins/work/${buildDir}
bitbake ${BUILD_IMAGE}
EOF

    local volumes=${BUILD_WORK}:/home/jenkins/work
    local image=swr.cn-north-4.myhuaweicloud.com/openeuler-embedded/openeuler-ci-test:22.09
    local command=/home/jenkins/work/build.sh
    local user=jenkins

    python oebuilder_docke.py exec -v ${volumes} -i ${image} -c ${command} -u ${user}
}

use_agent()
{
    cat << EOF
Usage:
this is help information
EOF

    return 1
}

main()
{
    if [ ${1} == "build" ];then
        BUILD_ARCH="$2"
        BUILD_IMAGE="$3"
        BUILD_WORK="$4"
        check_build || use_agent || return 1
        build
    fi
}

main "$@"