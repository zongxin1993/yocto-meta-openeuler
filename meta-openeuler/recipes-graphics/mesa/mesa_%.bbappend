# main bbfile: yocto-poky/meta/recipes-graphics/mesa/mesa_21.0.3.bb

# version in openEuler
PV = "21.3.1"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
        https://mesa.freedesktop.org/archive/mesa-${PV}.tar.xz \
        file://0001-meson.build-check-for-all-linux-host_os-combinations.patch \
        file://0002-meson.build-make-TLS-ELF-optional.patch \
        file://0001-meson-misdetects-64bit-atomics-on-mips-clang.patch \
        file://0001-futex.h-Define-__NR_futex-if-it-does-not-exist.patch \
"

DEPENDS = "expat zlib"

# files, patches that come from openeuler
SRC_URI += " \
        file://${BP}.tar.xz;name=tarball \
        file://0001-evergreen-big-endian.patch \
        file://backport-fix-build-err-on-arm.patch \
        file://mesa-21.3.1-meson.build-make-TLS-ELF-optional.patch \
"
SRC_URI[tarball.md5sum] = "17a4ea65de7a9ab42437f3131e616a7f"
SRC_URI[tarball.sha256sum] = "646e6c5a9a185faa4cea796d378a1ba8e1148dbb197ca6605f95986a25af2752"
LIC_FILES_CHKSUM = "file://docs/license.rst;md5=17a4ea65de7a9ab42437f3131e616a7f"

