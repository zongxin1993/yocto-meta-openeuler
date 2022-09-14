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

SRC_URI = "file://aarch64-openeuler-linux-musl"

INHIBIT_SYSROOT_STRIP = "1"
INSANE_SKIP_${PN} += "already-stripped"

S = "${WORKDIR}/aarch64-openeuler-linux-musl"

PSEUDO_DISABLED = "1"

do_configure() {
        :
}

do_compile () {
        :
}


do_install() {
    install -m 0755 -d ${D}/
    install -m 0755 -d ${D}/${base_libdir}
    install -m 0755 -d ${D}/${libdir}
    cp -pPR ${S}/aarch64-openeuler-linux-musl/sysroot/* ${D}/
    chmod -R 755 ${D}/${base_libdir}
    chmod -R 755 ${D}/${libdir}
    rm -rf ${D}/etc/rpc
    rm -rf ${D}${datadir}/info
    rm -rf ${D}${base_libdir}/debug
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

