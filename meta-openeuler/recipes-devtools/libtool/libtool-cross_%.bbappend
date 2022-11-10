# main bbfile: yocto-poky/meta/recipes-devtools/libtool/libtool-cross_2.4.6.bb
PV = "2.4.7"

SRC_URI_remove = "${GNU_MIRROR}/libtool/libtool-${PV}.tar.gz \
                 file://rename-with-sysroot.patch \
                 file://fix-resolve-lt-sysroot.patch \
                 file://unwind-opt-parsing.patch \
"

# apply openeuler source package and patches
SRC_URI_prepend = " \
           file://libtool-${PV}.tar.xz \
           file://libtool-2.4.5-rpath.patch \
"
