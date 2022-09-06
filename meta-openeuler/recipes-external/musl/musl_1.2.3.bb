SUMMARY = "An implementation of the standard library for Linux-based systems"
DESCRIPTION = "A new standard library to power a new generation of Linux-based devices. \
musl is lightweight, fast, simple, free, and strives to be correct in the sense of \
standards-conformance and safety."

HOMEPAGE = "http://www.musl-libc.org/"
LICENSE = "MIT"
SECTION = "libs"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGES = "${PN} ${PN}-dev ${PN}-staticdev"

PROVIDES += "virtual/libc virtual/libiconv virtual/libintl virtual/crypt"

DEPENDS = "virtual/${TARGET_PREFIX}gcc \
          bsd-headers \
          "
INHIBIT_DEFAULT_DEPS = "1"

PR = "r1"

#require ../../recipes-devtools/gcc/gcc-bin-toolchain.inc


SRC_URI = "file://aarch64-openeuler-linux-musl-cross"
#SRC_URI = "file://aarch64-linux-musl-cross"

INHIBIT_SYSROOT_STRIP = "1"
INSANE_SKIP_${PN} += "already-stripped"

S = "${WORKDIR}/aarch64-openeuler-linux-musl-cross"
#S = "${WORKDIR}/aarch64-linux-musl-cross"

PSEUDO_DISABLED = "1"

do_configure() {
        :
}

do_compile () {
        :
}


do_install() {
    install -m 0755 -d ${D}/
    install -m 0755 -d ${D}/lib/
    cp -pPR ${S}/aarch64-linux-musl/* ${D}/
    chmod -R 755 ${D}/lib/
    rm -rf ${D}/etc/rpc
    rm -rf ${D}${datadir}/info
    rm -rf ${D}/lib/debug
    chown root:root ${D}/ -R
}

FILES_${PN} = " \
    /lib/*.so \
    /lib/*.so.* \
    ${base_sbindir}/ldconfig \
"
FILES_${PN}-staticdev = " \
    /lib/*.a \
"


RDEPENDSPN_${}-dev += "bsd-headers-dev"


INSANE_SKIP_${PN} += "installed-vs-shipped"
INSANE_SKIP += "dev-elf dev-so"


SYSROOT_DIRS += "/*"

