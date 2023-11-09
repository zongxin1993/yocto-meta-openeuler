# main bb: yocto-poky/meta/recipes-core/glibc/cross-localedef-native_2.35.bb
#
OPENEULER_REPO_NAME = "glibc"
OPENEULER_LOCAL_NAME = "glibc"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:prepend = " \
    file://glibc-${PV}.tar.xz \
    git://github.com/kraj/localedef;branch=master;name=localedef;destsuffix=glibc-${PV}/localedef;protocol=https \
"

SRC_URI:remove = " \
    ${GLIBC_GIT_URI};branch=${SRCBRANCH};name=glibc \
    git://github.com/kraj/localedef;branch=master;name=localedef;destsuffix=git/localedef;protocol=https \
"

S = "${WORKDIR}/glibc-${PV}"
