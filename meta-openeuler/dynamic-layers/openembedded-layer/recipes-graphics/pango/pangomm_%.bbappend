# main bb: yocto-meta-openembedded/meta-oe/recipes-graphics/pango/pangomm_2.46.2.bb

OPENEULER_SRC_URI_REMOVE = "https http git gitsm"

PV = "2.46.3"

SRC_URI += " \
        file://pangomm-${PV}.tar.xz \
"

S = "${WORKDIR}/pangomm-${PV}"

