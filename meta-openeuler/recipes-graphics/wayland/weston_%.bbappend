# main bb file: yocto-poky/meta/recipes-graphics/wayland/weston_9.0.0.bb

OPENEULER_BRANCH = "master"

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

PV = "8.0.0"

SRC_URI:remove = "file://0001-tests-include-fcntl.h-for-open-O_RDWR-O_CLOEXEC-and-.patch \
"

SRC_URI:prepend = "file://openeuler.png \
"

SRC_URI[sha256sum] = "7518b49b2eaa1c3091f24671bdcc124fd49fc8f1af51161927afa4329c027848"

DEPENDS:remove = "gdk-pixbuf"

do_install:append() {
    install -m 644 ${WORKDIR}/openeuler.png ${D}${datadir}/weston/
}
