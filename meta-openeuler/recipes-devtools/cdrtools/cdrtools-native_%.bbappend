# main bbfile: yocto-poky/meta/recipes-devtools/cdrtools/cdrtools-native_3.01.bb

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
        ${SOURCEFORGE_MIRROR}/project/cdrtools/cdrtools-${PV}.tar.bz2 \
"

# files, patches that come from openeuler
FILESEXTRAPATHS_append := "${THISDIR}/files/:"
SRC_URI_prepend = " \
        file://cdrtools-${PV}.tar.bz2 \
"
