# main bbfile: meta-qt5/recipes-qt/qt5/qtbase_git.bb

# add file search path
FILESEXTRAPATHS_prepend := "${OPENEULER_SP_DIR}/qt5-qtbase:"

PV = "5.15.2"
#S = "${OPENEULER_SP_DIR}/qt5-qtbase"

# Use the source packages from openEuler, remove patch conflict with openeuler
SRC_URI_remove = " \
        ${QT_GIT}/${QT_MODULE}.git;name=${QT_MODULE};${QT_MODULE_BRANCH_PARAM};protocol=${QT_GIT_PROTOCOL} \
        file://0002-cmake-Use-OE_QMAKE_PATH_EXTERNAL_HOST_BINS.patch \
        file://0003-qlibraryinfo-allow-to-set-qt.conf-from-the-outside-u.patch \
        file://0004-configure-bump-path-length-from-256-to-512-character.patch \
        file://0005-Disable-all-unknown-features-instead-of-erroring-out.patch \
        file://0006-Pretend-Qt5-wasn-t-found-if-OE_QMAKE_PATH_EXTERNAL_H.patch \
        file://0007-Delete-qlonglong-and-qulonglong.patch \
        file://0008-Replace-pthread_yield-with-sched_yield.patch \
        file://0009-Add-OE-specific-specs-for-clang-compiler.patch \
        file://0010-linux-clang-Invert-conditional-for-defining-QT_SOCKL.patch \
        file://0011-tst_qlocale-Enable-QT_USE_FENV-only-on-glibc.patch \
        file://0013-Disable-ltcg-for-host_build.patch \
        file://0014-Qt5GuiConfigExtras.cmake.in-cope-with-variable-path-.patch \
        file://0015-corelib-Include-sys-types.h-for-uint32_t.patch \
        file://0016-Define-QMAKE_CXX.COMPILER_MACROS-for-clang-on-linux.patch \
        file://0018-tst_qpainter-FE_-macros-are-not-defined-for-every-pl.patch \
        file://0019-Always-build-uic-and-qvkgen.patch \
        file://0019-Define-__NR_futex-if-it-does-not-exist.patch \
        file://0020-Avoid-renameeat2-for-native-sdk-builds.patch \
        file://0020-Revert-Fix-workaround-in-pthread-destructor.patch \
        file://0021-Bootstrap-without-linkat-feature.patch \
        file://0021-qfloat16-Include-limits-header.patch \
"

SRC_URI_append = " \
                file://qtbase-everywhere-src-${PV}.tar.xz \
        "

# yocto-poky specifies 'S = "${WORKDIR}/git', but since we are using the openeuler package,
# we need to re-specify it
