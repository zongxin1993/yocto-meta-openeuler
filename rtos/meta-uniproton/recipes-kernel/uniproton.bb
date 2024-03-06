### Descriptive metadata: SUMMARY,DESCRITPION, HOMEPAGE, AUTHOR, BUGTRACKER
SUMMARY = "UniProton "
DESCRITPION = "A lightweight real-time operating system"
AUTHOR = ""
HOMEPAGE = "https://gitee.com/openeuler/UniProton"
BUGTRACKER = "https://gitee.com/openeuler/yocto-meta-openeuler"
### Package manager metadata: SECTION, PRIOIRTY(only for deb, opkg)
SECTION = "RTOS"
PN = "uniproton"
PV = "1"

### License metadata
LICENSE = "MulanPSL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c7ea843127ff6afcb5f768497eb60f0a"

### Build metadata: SRC_URI, SRCDATA, S, B, FILESEXTRAPATHS....
SRC_URI:append:x86-64 = "git://gitee.com/openeuler/UniProton.git;branch=master;protocol=https \
    git://gitlab.com/Tim-Tianyu/ethercat.git;branch=master;protocol=https;name=ethercat;destsuffix=git/ethercat \
    git://gitee.com/zuyiwen/libcxx.git;branch=master;protocol=https;name=libcxx;destsuffix=git/libcxx \
    file://libboundscheck \
    file://libmetal \
    file://OpenAMP \
    "
SRCREV="${AUTOREV}"
SRCREV_FORMAT="default_heads"
S = "${WORKDIR}/git"
OPENEULER_SRC_DIR = "/usr1/openeuler/src"

do_fetch[depends] += "libboundscheck:do_fetch libmetal:do_fetch openamp:do_fetch"

def get_uniproton_cpu_type(d):

    supported_machine = {
        "generic_x86_64": "x86_64",
    }

    machine = d.getVar("MACHINE_ARCH",True)

    if not machine in supported_machine:
        bb.error("unsupported target arch:%s" % machine)
        return ""

    return supported_machine[machine]

UNIPROTON_CPUTYPE = "${@get_uniproton_cpu_type(d)}"

def get_uniproton_bsp(d):

    return "demos/" + get_uniproton_cpu_type(d) + "/build"

UNIPROTON_BSPDIR = "${@get_uniproton_bsp(d)}"

# alias package name
PROVIDES += "uniproton"

### Runtime metadata
PACKAGES = "${PN}"
### Package metadata
FILES:${PN} = " \
    /lib/firmware \
"

# bypass package_qa as the deleted LDFLAGS will cause error
do_package_qa() {
    echo "do package qa"
}

# bypass configure as UniProton has no configure phase
do_configure() {
    echo "do configure"
}

# downloaded code preprocessing
prepare_compile() {
    download_dir=$1

    if [ -d "${download_dir}/ethercat" ]
    then
        mv ${download_dir}/ethercat ${download_dir}/src/net/ethercat
    fi
    if [ -d "${download_dir}/libcxx" ]
    then
        mv ${download_dir}/libcxx ${download_dir}/${UNIPROTON_BSPDIR}/../component/
    fi
    if [ -d "${OPENEULER_SRC_DIR}/libboundscheck" ]
    then
        rm -rf ${download_dir}/platform/libboundscheck
        pushd ${OPENEULER_SRC_DIR}/libboundscheck
        tar -zxf libboundscheck*.tar.gz
        find . -maxdepth 1 -name "libboundscheck*" -type d | xargs -I {} mv {} ${download_dir}/platform/libboundscheck
        popd
    fi
    if [ -d "${OPENEULER_SRC_DIR}/libmetal" ]
    then
        cp -r ${OPENEULER_SRC_DIR}/libmetal ${download_dir}/libmetal
        pushd ${download_dir}/libmetal
        find . -maxdepth 1 -name "libmetal*" -type d | xargs -I {} rm -rf {}
        tar -zxvf libmetal-*.tar.gz
        find . -maxdepth 1 -name "libmetal*" -type d | xargs -I {} mv {} libmetal
        cp ${download_dir}/${UNIPROTON_BSPDIR}/../component/UniProton-patch-for-libmetal.patch ./libmetal/
        cd libmetal
        patch -p1 -d . < UniProton-patch-for-libmetal.patch
        cd ../
        mv ./libmetal ${download_dir}/${UNIPROTON_BSPDIR}/../component/
        cd ../
        rm -rf libmetal
        popd
    fi
    if [ -d "${OPENEULER_SRC_DIR}/OpenAMP" ]
    then
        cp -r ${OPENEULER_SRC_DIR}/OpenAMP ${download_dir}/openamp
        pushd ${download_dir}/openamp
        tar -zxvf openamp-2022.10.1.tar.gz
        find . -maxdepth 1 -name "openamp*" -type d | xargs -I {} mv {} open-amp
        cp ${download_dir}/${UNIPROTON_BSPDIR}/../component/UniProton-patch-for-openamp.patch ./open-amp/
        cd open-amp
        patch -p1 -d . < UniProton-patch-for-openamp.patch
        cd ../
        mv ./open-amp ${download_dir}/${UNIPROTON_BSPDIR}/../component/
        cd ../
        rm -rf openamp
        popd
    fi
}

build_ap_boot() {
    if [ ${UNIPROTON_CPUTYPE} != "x86_64" ]
    then
        return
    fi
    cd ${download_dir}/${UNIPROTON_BSPDIR}/../ap_boot
    make
}

do_compile() {
    prepare_compile ${S}
    build_ap_boot
    cd ${S}/${UNIPROTON_BSPDIR}
    sh build_app.sh all yocto
}

do_install() {
    install -d ${D}/lib/firmware
    install -m 644 -D ${S}/${UNIPROTON_BSPDIR}/*.bin ${D}/lib/firmware
    install -m 644 -D ${S}/${UNIPROTON_BSPDIR}/*.elf ${D}/lib/firmware
    if [ ${UNIPROTON_CPUTYPE} == "x86_64" ]
    then
        install -m 644 -D ${S}/${UNIPROTON_BSPDIR}/../ap_boot/ap_boot ${D}/lib/firmware
    fi
}
