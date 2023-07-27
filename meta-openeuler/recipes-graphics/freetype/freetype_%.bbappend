# the main bb file: yocto-poky/meta/recipes-graphics/freetype/freetype_2.11.1.bb
# version in src-openEuler

PV = "2.12.1"

SRC_URI:remove = "\
    file://CVE-2022-27404.patch \
    file://CVE-2022-27405.patch \
    file://CVE-2022-27406.patch \
    file://CVE-2023-2004.patch \
"
# apply src-openEuler patches
# backport-freetype-2.5.2-more-demos.patch for ft2demos
SRC_URI:prepend = "\
    file://freetype-${PV}.tar.xz \
    file://backport-freetype-2.3.0-enable-spr.patch \
    file://backport-freetype-2.2.1-enable-valid.patch \
    file://backport-freetype-2.6.5-libtool.patch \
    file://backport-freetype-2.8-multilib.patch \
    file://backport-freetype-2.10.0-internal-outline.patch \
    file://backport-freetype-2.10.1-debughook.patch \
"

LIC_FILES_CHKSUM = "file://LICENSE.TXT;md5=a5927784d823d443c6cae55701d01553 \
"

# new checksum
SRC_URI[sha256sum] = "4766f20157cc4cf0cd292f80bf917f92d1c439b243ac3018debf6b9140c41a7f"
