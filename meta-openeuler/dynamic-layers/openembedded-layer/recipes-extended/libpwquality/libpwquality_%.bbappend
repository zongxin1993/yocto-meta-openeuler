# main bbfile: meta-oe/recipes-extended/libpwquality/libpwquality_1.4.4.bb
# change install dir: ${base_libdir}(meta-openeuler) -> ${libdir}(meta-oe)

SRC_URI:remove = "file://add-missing-python-include-dir-for-cross.patch \
"

OPENEULER_SRC_URI_REMOVE = "https git"

PV = "1.4.5"

SRC_URI =+ " \
    file://libpwquality-1.4.5.tar.bz2 \
    file://modify-pwquality_conf.patch \
    file://fix-password-similarity.patch \
    file://fix-doc-about-difok.patch \
"

# do not enable python bindings, as well as not use gettext to translate
DEPENDS:remove = "virtual/gettext ${PYTHON_PN}-native ${PYTHON_PN}"
RDEPENDS:${PN}:remove = "${@['', '${PYTHON_PN}-core']['${CLASSOVERRIDE}' == 'class-target']}"

EXTRA_OECONF:remove = "--with-python-rev=${PYTHON_BASEVERSION} \
                 --with-python-binary=${STAGING_BINDIR_NATIVE}/${PYTHON_PN}-native/${PYTHON_PN} \
                 --with-pythonsitedir=${PYTHON_SITEPACKAGES_DIR} \
"
EXTRA_OECONF += "--enable-python-bindings=no \
"

EXTRA_OECONF += "--with-securedir=${base_libdir}/security \
"
# we use lib64 instead of /usr/lib64 about pam path
FILES:${PN} += "${base_libdir}/security/pam_pwquality.so"
FILES:${PN}-dbg += "${base_libdir}/security/.debug"
FILES:${PN}-staticdev += "${base_libdir}/security/pam_pwquality.a"
FILES:${PN}-dev += "${base_libdir}/security/pam_pwquality.la"
