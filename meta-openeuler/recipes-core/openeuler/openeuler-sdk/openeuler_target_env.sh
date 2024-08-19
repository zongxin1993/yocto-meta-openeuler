export KERNEL_SRC="${SDKTARGETSYSROOT}/usr/src/kernel"

# prepare SDK
PYTHONBIN=`which python3`
PYTHONVERSION=`python3 --version | awk -F "." '{print $2}'`

# prepare context for kernel module development
cd "${SDKTARGETSYSROOT}/usr/src/kernel"
make modules_prepare PKG_CONFIG_SYSROOT_DIR= PKG_CONFIG_PATH=
cd -


# ROS2 SDK related handling
if [ -f "${OECORE_NATIVE_SYSROOT}/usr/bin/colcon" ];then

    # auto add COLCON_WORK_PATH for toolchain.cmake, make colcon find pkg install from this path when build
    alias colcon='export COLCON_WORK_PATH=`pwd`  && colcon'

    # cmake toolchain file for ros2 SDK
    export CMAKE_TOOLCHAIN_FILE="$OECORE_NATIVE_SYSROOT/environment-setup.d/toolchain.cmake"
    # add target python3 site-packages path
    export PYTHONPATH="${PYTHONPATH}:${OECORE_TARGET_SYSROOT}/usr/lib/python3.${PYTHONVERSION}/site-packages"


    # avoid pythonpath err in colcon
    sed -i "s%python_path.exists():%python_path.exists() and not (\"\%s\" \% python_path).startswith(\"${OECORE_NATIVE_SYSROOT}/usr/lib\"):%" ${OECORE_NATIVE_SYSROOT}/usr/lib/python3.*/site-packages/colcon_core/environment/pythonpath.py


    # add find_path cross compile support for numpy path
    sed -i '/_NumPy_PATH/{n; s%NO_DEFAULT_PATH)%NO_DEFAULT_PATH CMAKE_FIND_ROOT_PATH_BOTH)%}' ${OECORE_NATIVE_SYSROOT}/usr/share/cmake*/Modules/FindPython/Support.cmake

    # fix .cmake lib dir from "/home/openeuelr*recipe-sysroot" to ${TARGET_SYSROOT_DIR}
    cmakefiles=`find ${SDKTARGETSYSROOT} -name "*\.cmake"`
    for cmakefile in $cmakefiles
    do
        res=`cat $cmakefile | grep recipe-sysroot`s
        if [ $? == 0 ];then
            echo "Auto Check: $cmakefile"
            sed -i 's#recipe-sysroot#@@@@#g' $cmakefile
            sed -i 's#/home/[^@]*@@@@#\${TARGET_SYSROOT_DIR}#g' $cmakefile
        fi
    done
fi
