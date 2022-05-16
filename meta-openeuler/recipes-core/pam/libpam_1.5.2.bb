DISABLE_STATIC = ""
SUMMARY = "Linux-PAM (Pluggable Authentication Modules)"
DESCRIPTION = "Linux-PAM (Pluggable Authentication Modules for Linux), a flexible mechanism for authenticating users"
HOMEPAGE = "https://fedorahosted.org/linux-pam/"
BUGTRACKER = "https://fedorahosted.org/linux-pam/newticket"
SECTION = "base"
# PAM is dual licensed under GPL and BSD.
# /etc/pam.d comes from Debian libpam-runtime in 2009-11 (at that time
# libpam-runtime-1.0.1 is GPLv2+), by openembedded
LICENSE = "GPLv2+ | BSD-3-Clause"
LIC_FILES_CHKSUM = "file://COPYING;md5=7eb5c1bf854e8881005d673599ee74d3 \
                    file://libpamc/License;md5=a4da476a14c093fdc73be3c3c9ba8fb3 \
                    "

SRC_URI = "file://pam/Linux-PAM-${PV}.tar.xz \
           file://pam/bugfix-pam-1.1.8-faillock-systemtime.patch \
           file://pam/openEuler-change-ndbm-to-gdbm.patch \
           file://pam/0001-bugfix-cannot-open-database-file.patch \
           file://pam/add-sm3-crypt-support.patch \
           file://99_pam \
           file://pam.d/common-account \
           file://pam.d/common-auth \
           file://pam.d/common-password \
           file://pam.d/common-session \
           file://pam.d/common-session-noninteractive \
           file://pam.d/other \
           file://libpam-xtests.patch \
           file://run-ptest \
           file://pam-volatiles.conf \
"

SRC_URI[sha256sum] = "e4ec7131a91da44512574268f493c6d8ca105c87091691b8e9b56ca685d4f94d"

#DEPENDS = "bison-native flex flex-native cracklib libxml2-native virtual/crypt"
DEPENDS = "cracklib virtual/crypt"

EXTRA_OECONF = "--includedir=${includedir}/security \
                --libdir=${base_libdir} \
                --disable-nis \
                --disable-regenerate-docu \
                --disable-doc \
		--disable-prelude"

CFLAGS_append = " -fPIC "

S = "${WORKDIR}/Linux-PAM-${PV}"


#inherit autotools gettext pkgconfig systemd ptest
inherit autotools gettext

PACKAGECONFIG ??= ""
PACKAGECONFIG[audit] = "--enable-audit,--disable-audit,audit,"
PACKAGECONFIG[userdb] = "--enable-db=db,--enable-db=no,db,"

PACKAGES += "${PN}-runtime ${PN}-xtests ${PN}-pkgconfig ${PN}-service"
FILES_${PN} = "${base_libdir}/lib*${SOLIBS}"
FILES_${PN}-dev += "${base_libdir}/security/*.la ${base_libdir}/*.la ${base_libdir}/lib*${SOLIBSDEV}"
FILES_${PN}-runtime = "${sysconfdir} ${sbindir} ${systemd_system_unitdir}"
FILES_${PN}-xtests = "${datadir}/Linux-PAM/xtests"
FILES_${PN}-pkgconfig = "${base_libdir}/pkgconfig"
FILES_${PN}-service = "/usr/lib/systemd/system"

PACKAGES_DYNAMIC += "^${MLPREFIX}pam-plugin-.*"

def get_multilib_bit(d):
    baselib = d.getVar('baselib') or ''
    return baselib.replace('lib', '')

libpam_suffix = "suffix${@get_multilib_bit(d)}"

RPROVIDES_${PN} += "${PN}-${libpam_suffix}"
RPROVIDES_${PN}-runtime += "${PN}-runtime-${libpam_suffix}"

RDEPENDS_${PN}-runtime = "${PN}-${libpam_suffix} \
    ${MLPREFIX}pam-plugin-deny-${libpam_suffix} \
    ${MLPREFIX}pam-plugin-permit-${libpam_suffix} \
    ${MLPREFIX}pam-plugin-warn-${libpam_suffix} \
    ${MLPREFIX}pam-plugin-unix-${libpam_suffix} \
    "
#RDEPENDS_${PN}-xtests = "${PN}-${libpam_suffix} \
#    ${MLPREFIX}pam-plugin-access-${libpam_suffix} \
#    ${MLPREFIX}pam-plugin-debug-${libpam_suffix} \
#    ${MLPREFIX}pam-plugin-pwhistory-${libpam_suffix} \
#    ${MLPREFIX}pam-plugin-succeed-if-${libpam_suffix} \
#    ${MLPREFIX}pam-plugin-time-${libpam_suffix} \
#    bash coreutils"

# FIXME: Native suffix breaks here, disable it for now
RRECOMMENDS_${PN} = "${PN}-runtime-${libpam_suffix}"
RRECOMMENDS_${PN}_class-native = ""

python populate_packages_prepend () {
    def pam_plugin_hook(file, pkg, pattern, format, basename):
        pn = d.getVar('PN')
        libpam_suffix = d.getVar('libpam_suffix')

        rdeps = d.getVar('RDEPENDS_' + pkg)
        if rdeps:
            rdeps = rdeps + " " + pn + "-" + libpam_suffix
        else:
            rdeps = pn + "-" + libpam_suffix
        d.setVar('RDEPENDS_' + pkg, rdeps)

        provides = d.getVar('RPROVIDES_' + pkg)
        if provides:
            provides = provides + " " + pkg + "-" + libpam_suffix
        else:
            provides = pkg + "-" + libpam_suffix
        d.setVar('RPROVIDES_' + pkg, provides)

    mlprefix = d.getVar('MLPREFIX') or ''
    dvar = d.expand('${WORKDIR}/package')
    pam_libdir = d.expand('${base_libdir}/security')
    pam_sbindir = d.expand('${sbindir}')
    pam_filterdir = d.expand('${base_libdir}/security/pam_filter')
    pam_pkgname = mlprefix + 'pam-plugin%s'

    do_split_packages(d, pam_libdir, r'^pam(.*)\.so$', pam_pkgname,
                      'PAM plugin for %s', hook=pam_plugin_hook, extra_depends='')
    do_split_packages(d, pam_filterdir, r'^(.*)$', 'pam-filter-%s', 'PAM filter for %s', extra_depends='')
}

do_compile_ptest() {
        cd tests
        sed -i -e 's/$(MAKE) $(AM_MAKEFLAGS) check-TESTS//' Makefile
        oe_runmake check-am
        cd -
}

do_install() {
	autotools_do_install

	# don't install /var/run when populating rootfs. Do it through volatile
	rm -rf ${D}${localstatedir}

        if ${@bb.utils.contains('DISTRO_FEATURES','sysvinit','false','true',d)}; then
            rm -rf ${D}${sysconfdir}/init.d/
            rm -rf ${D}${sysconfdir}/rc*
            install -d ${D}${sysconfdir}/tmpfiles.d
            install -m 0644 ${WORKDIR}/pam-volatiles.conf \
                    ${D}${sysconfdir}/tmpfiles.d/pam.conf
        else
            install -d ${D}${sysconfdir}/default/volatiles
            install -m 0644 ${WORKDIR}/99_pam \
                    ${D}${sysconfdir}/default/volatiles/
        fi

	install -d ${D}${sysconfdir}/pam.d/
	install -m 0644 ${WORKDIR}/pam.d/* ${D}${sysconfdir}/pam.d/

	# The lsb requires unix_chkpwd has setuid permission
	chmod 4755 ${D}${sbindir}/unix_chkpwd

	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		echo "session optional pam_systemd.so" >> ${D}${sysconfdir}/pam.d/common-session
	fi
}

do_install_ptest() {
    if [ ${PTEST_ENABLED} = "1" ]; then
        mkdir -p ${D}${PTEST_PATH}/tests
        install -m 0755 ${B}/tests/.libs/* ${D}${PTEST_PATH}/tests
        install -m 0644 ${S}/tests/confdir ${D}${PTEST_PATH}/tests
    fi
}

pkg_postinst_${PN}() {
         if [ -z "$D" ] && [ -e /etc/init.d/populate-volatile.sh ] ; then
                 /etc/init.d/populate-volatile.sh update
         fi
}

inherit features_check
REQUIRED_DISTRO_FEATURES = "pam"

BBCLASSEXTEND = "nativesdk native"

CONFFILES_${PN}-runtime += "${sysconfdir}/pam.d/common-session"
CONFFILES_${PN}-runtime += "${sysconfdir}/pam.d/common-auth"
CONFFILES_${PN}-runtime += "${sysconfdir}/pam.d/common-password"
CONFFILES_${PN}-runtime += "${sysconfdir}/pam.d/common-session-noninteractive"
CONFFILES_${PN}-runtime += "${sysconfdir}/pam.d/common-account"
CONFFILES_${PN}-runtime += "${sysconfdir}/security/limits.conf"

UPSTREAM_CHECK_URI = "https://github.com/linux-pam/linux-pam/releases"

CVE_PRODUCT = "linux-pam"
