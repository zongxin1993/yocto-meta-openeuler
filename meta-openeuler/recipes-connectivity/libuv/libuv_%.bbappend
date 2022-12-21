# main bb file: yocto-poky/meta/recipes-connectivity/libuv/libuv_1.41.0.bb

# version in openEuler
PV = "1.42.0"

SRC_URI_remove = "git://github.com/libuv/libuv;branch=v1.x \
        git://github.com/libuv/libuv;branch=v1.x;protocol=https \
        "

# apply openEuler source package
SRC_URI_prepend = "file://${BPN}-v${PV}.tar.gz \
        file://backport-Skip-some-tests.patch \
        file://libuv-Add-sw64-architecture.patch \
"

S = "${WORKDIR}/${BPN}-v${PV}"
