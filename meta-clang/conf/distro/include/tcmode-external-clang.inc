EXTERNAL_CLANG ?= "clang"
CLANG_VERSION = "${@get_clang_version(d)}"
CLANG_VERSION_allarch = ""
CLANG_VERSION[vardepvalue] = "${CLANG_VERSION}"
BUILDCFG_VARS += "CLANG_VERSION"

# use gcc sysroot now
HOST_CC_ARCH:remove:toolchain-clang = "-target ${HOST_SYS}"
# for target, use gcc sysroot
HOST_CC_ARCH:prepend:class-target:toolchain-clang = "--target=${EXTERNAL_TARGET_SYS} "
# for native recipe, use prebuilt tool
# HOST_CC_ARCH:prepend:class-native:toolchain-clang = "--target=x86_64-openeulersdk-linux "

# no need for clang
HOST_CC_ARCH:remove:toolchain-clang = "--no-sysroot-suffix"

def get_clang_version(d):
    import os.path
    import re
    import subprocess
    import oe.path
    import bb
    version_output = ""
    toolchain_bin = d.getVar('EXTERNAL_TOOLCHAIN_CLANG_BIN')
    if toolchain_bin:
        path = os.path.join(toolchain_bin, d.getVar('EXTERNAL_CLANG'))
        cmd = path + " --version | head -n1"
        bb.debug(1, 'oe.external.run({})'.format(cmd))
        version_output = subprocess.getoutput(cmd)
        # clang version xx.yy.zz, here we get xx.yy.zz
        match = re.search("[0-9]+\.[0-9]+\.[0-9]", version_output)
        if match:
            return match.group()
    return 'UNKNOWN'
