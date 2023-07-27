PV = "3.9.9"

FILESEXTRAPATHS:append := "${THISDIR}/files/:"

SRC_URI[sha256sum] = "06828c04a573c073a4e51c4292a27c1be4ae26621c3edc7cf9318418ce3b6d27"

SRC_URI:remove = " \
           file://0001-Makefile-fix-Issue36464-parallel-build-race-problem.patch \
"

OPENEULER_BRANCH = "openEuler-22.03-LTS"

SRC_URI =+ " \
    file://00001-rpath.patch \
    file://00111-no-static-lib.patch \
    file://00251-change-user-install-location.patch \
    file://backport-Add--with-wheel-pkg-dir-configure-option.patch \
    file://backport-bpo-46811-Make-test-suite-support-Expat-2.4.5.patch \
    file://backport-bpo-20369-concurrent.futures.wait-now-deduplicates-f.patch \
    file://Make-mailcap-refuse-to-match-unsafe-filenam.patch \
    file://backport-CVE-2021-28861.patch \
    file://backport-CVE-2020-10735.patch \
    file://backport-bpo-35823-subprocess-Use-vfork-instead-of-fork-on-Li.patch \
    file://backport-bpo-35823-subprocess-Fix-handling-of-pthread_sigmask.patch \
    file://backport-bpo-35823-Allow-setsid-after-vfork-on-Linux.-GH-2294.patch \
    file://backport-bpo-42146-Unify-cleanup-in-subprocess_fork_exec-GH-2.patch \
    file://add-the-sm3-method-for-obtaining-the-salt-value.patch \
"

# meta-openeuler layer does not need to build python3-native dependency packages,
# but gets them directly from the nativesdk tool
# Find header from nativesdk
CPPFLAGS:append:class-native = " -I${OPENEULER_NATIVESDK_SYSROOT}/usr/include \
    -I${OPENEULER_NATIVESDK_SYSROOT}/usr/include/ncursesw -I${OPENEULER_NATIVESDK_SYSROOT}/usr/include/uuid \
"

# Find library from nativesdk
LDFLAGS:append:class-native = " -L${OPENEULER_NATIVESDK_SYSROOT}/usr/lib"
