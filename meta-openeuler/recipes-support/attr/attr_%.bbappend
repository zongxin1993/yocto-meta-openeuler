# main bbfile: yocto-poky/meta/recipes-support/attr/attr_2.5.1.bb

# attr version in openEuler
PV = "2.5.1"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
            ${SAVANNAH_GNU_MIRROR}/attr/${BP}.tar.gz \
            "

SRC_URI += " \
            file://attr/attr-${PV}.tar.gz \
            file://attr/0001-bypass-wrong-output-when-enabled-selinux.patch \
            file://attr/0002-dont-skip-security.evm-when-copy-xattr.patch \
        "
