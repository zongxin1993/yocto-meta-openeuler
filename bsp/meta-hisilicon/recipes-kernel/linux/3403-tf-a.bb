SUMMARY = "ARM Trusted Firmware for SD3403"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

BPN = "trusted-firmware-a"
PV = "2.2"

OPENEULER_LOCAL_NAME = "3rdparty_openeuler"

SRC_URI = "file://3rdparty_openeuler/firmware/${BP}.tar.gz \
           file://3rdparty_openeuler/firmware/${BP}.patch \
           file://tf-a/0001-add-LDFLAGS-to-fix-compilation-errors.patch \
        "

SRC_URI[md5sum] = "abb0e05dd2e719f094841790c81efa57"
SRC_URI[sha256sum] = "01d9190755f752929c82bdf6b0e16868dc7a818666b84e1dbdfa4726f6bb2731"

# overide LDFLAGS to fix compilation error: "aarch64-openeuler-linux-gnu-ld.bfd: unrecognized option '-Wl,-O1'"
export LDFLAGS=""

# uImage as BL33
DEPENDS += "virtual/kernel"

EXTRA_OEMAKE="CROSS_COMPILE=${TARGET_PREFIX} "

do_compile:append() {
    oe_runmake PLAT=ss928v100 SPD=none BL33=${WORKDIR}/recipe-sysroot/linux-img/uImage CCI_UP=0 DEBUG=0 BL33_SEC=0 fip
}

do_install:append() {
    install -d ${D}/boot/
    install ${B}/build/ss928v100/release/fip.bin ${D}/boot/kernel
}

FILES:${PN} += "/boot/kernel"
