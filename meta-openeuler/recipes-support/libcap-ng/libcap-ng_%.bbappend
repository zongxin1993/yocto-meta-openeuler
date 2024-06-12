# main bb: yocto-poky/meta/recipes-support/libcap-ng/libcap-ng_0.8.2.bb
OPENEULER_SRC_URI_REMOVE = "https git"

PV = "0.8.3"

# determinism.patch no need for 0.8.3
SRC_URI_remove += "file://determinism.patch"

SRC_URI += " \
        file://libcap-ng-${PV}.tar.gz \
        file://backport-Make-Python-test-script-compatible-with-Python2-and-Python3.patch \
        file://backport-Fix-the-syntax-error-in-cap-ng-c-50.patch \
        "

S = "${WORKDIR}/libcap-ng-${PV}"
