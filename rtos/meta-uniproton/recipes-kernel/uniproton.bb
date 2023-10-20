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
SRC_URI = "git://gitee.com/openeuler/UniProton.git;branch=master;protocol=https \
           git://gitee.com/openeuler/libboundscheck.git;branch=master;protocol=https;name=libboundscheck;destsuffix=git/libboundscheck \
           git://gitee.com/src-openeuler/libmetal.git;branch=master;protocol=https;name=libmetal;destsuffix=git/libmetal \
           git://gitee.com/src-openeuler/OpenAMP.git;branch=master;protocol=https;name=openamp;destsuffix=git/openamp \
           git://gitlab.com/Tim-Tianyu/ethercat.git;branch=master;protocol=https;name=ethercat;destsuffix=git/ethercat "

SRCREV="${AUTOREV}"
SRCREV_FORMAT="default_heads"
S = "${WORKDIR}/git"


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
    if [ -d "${download_dir}/libboundscheck" ]
    then
        rm -rf ${download_dir}/platform/libboundscheck
        mv ${download_dir}/libboundscheck ${download_dir}/platform
    fi
    if [ -d "${download_dir}/libmetal" ]
    then
        pushd ${download_dir}/libmetal
        tar -zxvf libmetal-2022.10.0.tar.gz
        mv ./libmetal-2022.10.0 ./libmetal
        cp ${download_dir}/${UNIPROTON_BSPDIR}/../component/UniProton-patch-for-libmetal.patch ./libmetal/
        cd libmetal
        patch -p1 -d . < UniProton-patch-for-libmetal.patch
        cd ../
        mv ./libmetal ${download_dir}/${UNIPROTON_BSPDIR}/../component/
        cd ../
        rm -rf libmetal
        popd
    fi
    if [ -d "${download_dir}/openamp" ]
    then
        pushd ${download_dir}/openamp
        tar -zxvf openamp-2022.10.1.tar.gz
        mv ./openamp-2022.10.1 ./open-amp
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
