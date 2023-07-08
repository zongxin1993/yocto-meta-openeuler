# the main bb file: yocto-poky/meta/recipes-support/libffi/libffi_3.4.4.bb

SRC_URI = " \
    file://${BPN}-${PV}.tar.gz \
    file://backport-Fix-signed-vs-unsigned-comparison.patch \
    file://fix-AARCH64EB-support.patch \
"
