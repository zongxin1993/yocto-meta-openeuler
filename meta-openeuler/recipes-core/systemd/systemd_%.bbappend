#main bbfile: yocto-poky/meta/recipes-core/systemd/systemd_247.6.bb

#version in openEuler
PV = "249"
S = "${WORKDIR}/${BP}"

require systemd-openeuler.inc

OPENEULER_REPO_NAME = "systemd"
FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

# feature sync with systemd_249.7.bb from poky honister
# see https://git.yoctoproject.org/poky/tree/meta/recipes-core/systemd/systemd_249.7.bb?h=honister
PACKAGECONFIG_append += "wheel-group"
# we don't wan zstd PACKAGECONFIG += "zstd"
PACKAGECONFIG_remove += "xz"
PACKAGECONFIG[tpm2] = "-Dtpm2=true,-Dtpm2=false,tpm2-tss,tpm2-tss libtss2 libtss2-tcti-device"
PACKAGECONFIG[repart] = "-Drepart=true,-Drepart=false"
PACKAGECONFIG[homed] = "-Dhomed=true,-Dhomed=false"
PACKAGECONFIG[wheel-group] = "-Dwheel-group=true, -Dwheel-group=false"
PACKAGECONFIG[zstd] = "-Dzstd=true,-Dzstd=false,zstd"
FILES_${PN}-container += "${exec_prefix}/lib/tmpfiles.d/README "
FILES_${PN}-extra-utils += "${bindir}/systemd-sysext "
FILES_${PN} += "${rootlibexecdir}/modprobe.d/README ${datadir}/dbus-1/system.d/org.freedesktop.home1.conf "
FILES_udev += "${rootlibexecdir}/udev/dmi_memory_id \
        ${rootlibexecdir}/udev/rules.d/40-elevator.rules \
        ${rootlibexecdir}/udev/rules.d/70-memory.rules \
        ${rootlibexecdir}/udev/rules.d/73-idrac.rules \
        ${rootlibexecdir}/udev/rules.d/81-net-dhcp.rules \
        ${rootlibexecdir}/udev/rules.d/README \
        "
python __anonymous() {
    if not bb.utils.contains('DISTRO_FEATURES', 'sysvinit', True, False, d):
        d.setVar("INHIBIT_UPDATERCD_BBCLASS", "1")

    if bb.utils.contains('PACKAGECONFIG', 'repart', True, False, d) and not bb.utils.contains('PACKAGECONFIG', 'openssl', True, False, d):
        bb.error("PACKAGECONFIG[repart] requires PACKAGECONFIG[openssl]")

    if bb.utils.contains('PACKAGECONFIG', 'homed', True, False, d) and not bb.utils.contains('PACKAGECONFIG', 'userdb openssl cryptsetup', True, False, d):
        bb.error("PACKAGECONFIG[homed] requires PACKAGECONFIG[userdb], PACKAGECONFIG[openssl] and PACKAGECONFIG[cryptsetup]")
}
# rules.d come from openeuler patches: /lib/udev/rules.d/73-idrac.rules   /lib/udev/rules.d/40-elevator.rules
FILES_udev += " \
        ${rootlibexecdir}/udev/rules.d/40-elevator.rules \
        ${rootlibexecdir}/udev/rules.d/73-idrac.rules \
        "

# depmodwrapper is not valid to do depmod in buildtime, add a service to do it in runtime as a workaround.
# as modutils.sh is not run under systemd
PACKAGE_BEFORE_PN_append = "${PN}-depmod "
SRC_URI_append += "file://systemd-depmod.service"
FILES_${PN}-depmod = "${systemd_unitdir}/system/systemd-depmod.service"
SYSTEMD_SERVICE_${PN}-depmod = "systemd-depmod.service"
do_install_append () {
    install -m 0644 ${WORKDIR}/systemd-depmod.service ${D}${systemd_unitdir}/system/systemd-depmod.service
    ln -sf ../systemd-depmod.service ${D}${systemd_unitdir}/system/sysinit.target.wants/systemd-depmod.service
}

SRC_URI[tarball.md5sum] = "8e8adf909c255914dfc10709bd372e69"
SRC_URI[tarball.sha256sum] = "174091ce5f2c02123f76d546622b14078097af105870086d18d55c1c2667d855"

# glib needs meson, meson needs python3-native
# here use nativesdk's meson-native and python3-native
DEPENDS_remove += "python3-native"

pkg_postinst_udev-hwdb () {
    # current we don't support qemuwrapper to pre build the config for rootfs
    # so if you wan't to update hwdb, do 'udevadm hwdb --update' in your own script on service or copy the configs into rootfs directly.
    :
}

SRC_URI_remove_libc-musl += " ${SRC_URI_MUSL}"

SRC_URI_append_libc-musl += " \
                            file://0002-don-t-use-glibc-specific-qsort_r-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0003-missing_type.h-add-__compare_fn_t-and-comparison_fn_openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0004-add-fallback-parse_printf_format-implementation-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0005-src-basic-missing.h-check-for-missing-strndupa-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0006-Include-netinet-if_ether.h-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0007-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0008-add-missing-FTW_-macros-for-musl.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0009-fix-missing-of-__register_atfork-for-non-glibc-build.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0010-Use-uintmax_t-for-handling-rlim_t.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0011-test-sizeof.c-Disable-tests-for-missing-typedefs-in-.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0012-don-t-pass-AT_SYMLINK_NOFOLLOW-flag-to-faccessat-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0013-Define-glibc-compatible-basename-for-non-glibc-syste.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0014-Do-not-disable-buffering-when-writing-to-oom_score_a.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0015-distinguish-XSI-compliant-strerror_r-from-GNU-specif-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0016-Hide-__start_BUS_ERROR_MAP-and-__stop_BUS_ERROR_MAP.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0017-missing_type.h-add-__compar_d_fn_t-definition.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0018-avoid-redefinition-of-prctl_mm_map-structure.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0019-Handle-missing-LOCK_EX.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0020-Fix-incompatible-pointer-type-struct-sockaddr_un.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0021-test-json.c-define-M_PIl.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0022-do-not-disable-buffer-in-writing-files-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0025-Handle-__cpu_mask-usage.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0026-Handle-missing-gshadow-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://0028-missing_syscall.h-Define-MIPS-ABI-defines-for-musl-openeuler.patch;patchdir=${WORKDIR}/systemd-${PV} \
                            file://systemd-musl.patch;patchdir=${WORKDIR}/systemd-${PV} \
"
