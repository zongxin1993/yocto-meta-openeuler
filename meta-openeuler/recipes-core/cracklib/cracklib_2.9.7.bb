SUMMARY = "Password strength checker library"
HOMEPAGE = "http://sourceforge.net/projects/cracklib"

LICENSE = "LGPLv2.1+"

SRC_URI = "file://cracklib/cracklib-${PV}.tar.gz \
           file://cracklib/fix-problem-of-error-message-about-simplistic-passwo.patch \
           file://cracklib/backport-cracklib-2.9.6-lookup.patch \
"

LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=e3eda01d9815f8d24aae2dbd89b68b06"

DEPENDS = "cracklib-native zlib"
#use command(create-cracklib-dict cracklib-format cracklib-packer) on the host, not from cracklib-native
DEPENDS_remove += "cracklib-native"
DEPENDS_class-native = "zlib"

EXTRA_OECONF = "--without-python --libdir=${base_libdir}"

UPSTREAM_CHECK_URI = "http://sourceforge.net/projects/cracklib/files/cracklib/"
UPSTREAM_CHECK_REGEX = "/cracklib/(?P<pver>(\d+[\.\-_]*)+)/"

inherit autotools gettext

BBCLASSEXTEND = "native"

do_install_append_class-target() {
        create-cracklib-dict -o ${D}${datadir}/cracklib/pw_dict ${D}${datadir}/cracklib/cracklib-small
}

do_compile_prepend() {
       sed -i "s|GETTEXT_MACRO_VERSION =.*|GETTEXT_MACRO_VERSION = ${HOST_GETTEXT_VER}|" ${B}/po/Makefile
}
