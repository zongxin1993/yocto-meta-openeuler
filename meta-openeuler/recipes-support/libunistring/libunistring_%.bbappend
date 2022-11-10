# main bbfile: yocto-poky/meta/recipes-support/libunistring/libunistring_0.9.10.bb
PV = "1.1"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
        ${GNU_MIRROR}/libunistring/libunistring-${PV}.tar.gz \
        file://0001-Unset-need_charset_alias-when-building-for-musl.patch \
"

# files, patches that come from openeuler
SRC_URI += " \
        file://${BP}.tar.xz;name=tarball \
"

SRC_URI[tarball.md5sum] = "0dfba19989ae06b8e7a49a7cd18472a1"
SRC_URI[tarball.sha256sum] = "827c1eb9cb6e7c738b171745dac0888aa58c5924df2e59239318383de0729b98"
