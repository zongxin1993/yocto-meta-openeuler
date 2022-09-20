# main bbfile: yocto-poky/meta/recipes-graphics/fontconfig/fontconfig_2.13.1.bb

# version in src-openEuler
PV = "2.13.94"

# license files changed, update LIC_FILES_CHKSUM value
LIC_FILES_CHKSUM = "file://COPYING;md5=00252fd272bf2e722925613ad74cb6c7 \
                    file://src/fcfreetype.c;endline=45;md5=ce976b310a013a6ace6b60afa71851c1 \
                    file://src/fccache.c;beginline=1671;endline=1686;md5=b2d0c5cebd0e97a111aeb54128730511 \
                    "

SRC_URI_remove = "http://fontconfig.org/release/fontconfig-${PV}.tar.gz \
"

SRC_URI_prepend = "file://fontconfig-${PV}.tar.xz \
           file://backport-fontconfig-disable-network-required-test.patch \
"

SRC_URI[md5sum] = "ab06ff17524de3f1ddd3c97ed8a02f8d"
SRC_URI[sha256sum] = "a5f052cb73fd479ffb7b697980510903b563bbb55b8f7a2b001fcfb94026003c"
