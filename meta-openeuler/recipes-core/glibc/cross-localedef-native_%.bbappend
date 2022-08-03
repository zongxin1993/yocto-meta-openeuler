# main bbfile: yocto-poky/meta/recipes-core/glibc/cross-localedef-native_2.33.bb

# version in openEuler
PV = "2.34"

# don't donwload glibc and localedef by network
SRC_URI_remove = " \
        ${GLIBC_GIT_URI};branch=${SRCBRANCH};name=glibc \
	git://github.com/kraj/localedef;branch=master;name=localedef;destsuffix=git/localedef \
        file://0016-timezone-re-written-tzselect-as-posix-sh.patch \
"

# get extra config files from openeuler
FILESEXTRAPATHS_append := "${THISDIR}/files/:"
SRC_URI_prepend = " \
        file://glibc/glibc-2.34.tar.xz;name=tarball \
        file://glibc/glibc-c-utf8-locale.patch \
        file://glibc/localedef-Handle-symbolic-links-when-generating-loca.patch \
	file://localedef.tar.gz;name=localedef \
"

SRC_URI[tarball.md5sum] = "31998b53fb39cb946e96abc310af1c89"
SRC_URI[tarball.sha256sum] = "44d26a1fe20b8853a48f470ead01e4279e869ac149b195dda4e44a195d981ab2"
SRC_URI[localedef.md5sum] = "0d1879a0944284a0c0297977ad755fb8"
SRC_URI[localedef.sha256sum] = "f84d21e42cd476f81498041c68a47c357b7588550f20514fe20d7411d3972aa4"

S = "${WORKDIR}/${BP}"

do_copy_localedef() {
	cp -r ${WORKDIR}/glibc-2.34/* ${S}
	mv ${WORKDIR}/localedef ${S}
}

addtask copy_localedef before do_patch after do_unpack
