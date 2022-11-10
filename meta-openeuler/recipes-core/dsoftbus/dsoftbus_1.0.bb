SUMMARY = "dsoftbus"
DESCRIPTION = "dsoftbus"
PR = "r1"
LICENSE = "CLOSED"

# gn\ninja has self contained by this project, no need here
DEPENDS = "python3-native openssl"

S = "${WORKDIR}/dsoftbus-build"
dsoftbus-buildtools="${S}/prebuilts/build-tools/linux-x86/bin"
dsoftbus-thirdparty="${S}/third_party"
dsoftbus-utils="${S}/utils"
dsoftbus-src="${S}/foundation/communication"
dsoftbus-hichain="${S}/base/security"

SRC_URI = " \
        file://libboundscheck/libboundscheck-v1.1.11.tar.gz \
        file://cjson/v1.7.15.tar.gz \
        file://yocto-embedded-tools/dsoftbus/build/build-OpenHarmony-v3.0.2-LTS.zip \
        file://yocto-embedded-tools/dsoftbus/build_tools/gn-linux-x86-1717.tar.gz \
        file://yocto-embedded-tools/dsoftbus/build_tools/ninja-linux-x86-1.10.1.tar.gz \
        file://yocto-embedded-tools/dsoftbus/third_party/libcoap/third_party_libcoap-OpenHarmony-v3.1.2-Release.zip \
        file://yocto-embedded-tools/dsoftbus/third_party/mbedtls/third_party_mbedtls-OpenHarmony-v3.1.2-Release.zip \
        file://yocto-embedded-tools/dsoftbus/utils/commonlibrary_c_utils-OpenHarmony-v3.1.2-Release.zip \
        file://yocto-embedded-tools/dsoftbus/hichain/huks/security_huks-OpenHarmony-v3.1.2-Release.zip \
        file://yocto-embedded-tools/dsoftbus/hichain/deviceauth/security_device_auth-OpenHarmony-v3.1.2-Release.zip \
        file://yocto-embedded-tools/dsoftbus/depend;unpack=true \
        file://yocto-embedded-tools/dsoftbus/productdefine;unpack=true \
        file://dsoftbus_standard;unpack=true \
        file://embedded-ipc;unpack=true \
        file://yocto-embedded-tools/dsoftbus/build/0001-add-dsoftbus-build-support-for-embedded-env.patch;patchdir=${S}/build \
        file://yocto-embedded-tools/dsoftbus/build/0002-support-hichian-for-openeuler.patch;patchdir=${S}/build \
        file://yocto-embedded-tools/dsoftbus/build/0003-remove-build_configs-to-simplify-third-party-tools.patch;patchdir=${S}/build \
        file://yocto-embedded-tools/dsoftbus/utils/0001-Adaptation-for-dsoftbus.patch;patchdir=${dsoftbus-utils}/native \
        file://yocto-embedded-tools/dsoftbus/third_party/bounds_checking_function/0001-Adaptation-for-dsoftbus.patch;patchdir=${dsoftbus-thirdparty}/bounds_checking_function \
        file://yocto-embedded-tools/dsoftbus/third_party/cJSON/0001-adapter-cjson-in-openEuler-for-softbus.patch;patchdir=${dsoftbus-thirdparty}/cJSON \
        file://yocto-embedded-tools/dsoftbus/third_party/mbedtls/0001-Adaptation-for-dsoftbus-v3.1.2.patch;patchdir=${dsoftbus-thirdparty}/mbedtls \
        file://yocto-embedded-tools/dsoftbus/third_party/mbedtls/0002-fix-CVE-2021-43666.patch;patchdir=${dsoftbus-thirdparty}/mbedtls \
        file://yocto-embedded-tools/dsoftbus/third_party/mbedtls/0003-fix-CVE-2021-45451.patch;patchdir=${dsoftbus-thirdparty}/mbedtls \
        file://yocto-embedded-tools/dsoftbus/third_party/mbedtls/0004-CVE-2020-36477.patch;patchdir=${dsoftbus-thirdparty}/mbedtls \
        file://yocto-embedded-tools/dsoftbus/hichain/huks/0001-support-huks-for-openeuler.patch;patchdir=${dsoftbus-hichain}/huks \
        file://yocto-embedded-tools/dsoftbus/hichain/huks/0002-simplify-dependency-on-third-party-packages.patch;patchdir=${dsoftbus-hichain}/huks \
        file://yocto-embedded-tools/dsoftbus/hichain/deviceauth/0001-support-deviceauth-for-openeuler.patch;patchdir=${dsoftbus-hichain}/deviceauth \
        file://yocto-embedded-tools/dsoftbus/hichain/deviceauth/0002-adapter-deviceauth-ipc-service.patch;patchdir=${dsoftbus-hichain}/deviceauth \
        file://yocto-embedded-tools/dsoftbus/hichain/deviceauth/0003-simplify-dependency-on-third-party-packages.patch;patchdir=${dsoftbus-hichain}/deviceauth \
        "

FILES_${PN}-dev = "${includedir}"
FILES_${PN} = "${libdir} ${bindir} /data/"

INSANE_SKIP_${PN} += "already-stripped"
ALLOW_EMPTY_${PN} = "1"

python do_fetch_prepend() {
    repoList = [{
        "repo_name": "yocto-embedded-tools",
        "git_space": "openeuler",
        "branch": "master"
    },{
        "repo_name": "libboundscheck",
        "git_space": "src-openeuler",
        "branch": "master"
    },{
        "repo_name": "cjson",
        "git_space": "src-openeuler",
        "branch": "master"
    },{
        "repo_name": "dsoftbus_standard",
        "git_space": "openeuler",
        "branch": "dev"
    },{
        "repo_name": "embedded-ipc",
        "git_space": "openeuler",
        "branch": "master"
    }]

    d.setVar("PKG_REPO_LIST", repoList)

    bb.build.exec_func("do_openeuler_fetchs", d)
}

do_unpack_append() {
    bb.build.exec_func('do_copy_dsoftbus_source', d)
}

do_copy_dsoftbus_source() {
    mkdir -p ${S}/build
    mkdir -p ${dsoftbus-buildtools}
    mkdir -p ${dsoftbus-thirdparty}
    mkdir -p ${dsoftbus-utils}
    mkdir -p ${dsoftbus-src}
    mkdir -p ${dsoftbus-thirdparty}/cJSON
    mkdir -p ${dsoftbus-thirdparty}/jinja2
    mkdir -p ${dsoftbus-thirdparty}/libcoap
    mkdir -p ${dsoftbus-thirdparty}/markupsafe
    mkdir -p ${dsoftbus-thirdparty}/mbedtls
    mkdir -p ${dsoftbus-thirdparty}/openssl
    mkdir -p ${dsoftbus-thirdparty}/bounds_checking_function
    mkdir -p ${dsoftbus-utils}/native/
    mkdir -p ${dsoftbus-hichain}/huks
    mkdir -p ${dsoftbus-hichain}/deviceauth
    cp -rfp ${WORKDIR}/build-OpenHarmony-v3.0.2-LTS/* ${S}/build/
    cp -rfp ${WORKDIR}/gn ${dsoftbus-buildtools}/
    cp -rfp ${WORKDIR}/ninja ${dsoftbus-buildtools}/
    cp -rfp ${WORKDIR}/third_party_libcoap-OpenHarmony-v3.1.2-Release/* ${dsoftbus-thirdparty}/libcoap/
    cp -rfp ${WORKDIR}/third_party_mbedtls-OpenHarmony-v3.1.2-Release/* ${dsoftbus-thirdparty}/mbedtls/
    cp -rfp ${WORKDIR}/security_huks-OpenHarmony-v3.1.2-Release/* ${dsoftbus-hichain}/huks/
    cp -rfp ${WORKDIR}/security_device_auth-OpenHarmony-v3.1.2-Release/* ${dsoftbus-hichain}/deviceauth/
    cp -rfp ${WORKDIR}/libboundscheck-v1.1.11/* ${dsoftbus-thirdparty}/bounds_checking_function/
    cp -rfp ${WORKDIR}/cJSON-1.7.15/* ${dsoftbus-thirdparty}/cJSON/
    cp -rfp ${WORKDIR}/commonlibrary_c_utils-OpenHarmony-v3.1.2-Release/* ${dsoftbus-utils}/native/

    #init gn root
    ln -s ${S}/build/build_scripts/build.sh ${S}/build.sh
    ln -s ${S}/build/core/gn/dotfile.gn ${S}/.gn

    #link selfcode
    ln -s ${WORKDIR}/yocto-embedded-tools/dsoftbus/productdefine ${S}/productdefine
    ln -s ${WORKDIR}/yocto-embedded-tools/dsoftbus/depend ${S}/depend
    ln -s ${WORKDIR}/embedded-ipc ${S}/depend/ipc
    ln -s ${WORKDIR}/dsoftbus_standard ${dsoftbus-src}/dsoftbus

    #link toolchain
    ln -s ${EXTERNAL_TOOLCHAIN} ${S}/toolchain
}

do_compile() {
    export STAGING_DIR_TARGET="${STAGING_DIR_TARGET}"
    ./build.sh --product-name openEuler
}

do_install() {
    install -d ${D}${libdir}/
    install -d ${D}${bindir}/
    install -d ${D}/${includedir}/
    install -d ${D}/data/data/deviceauth/

    # prepare so
    install -m 0755 ${S}/out/ohos-arm64-release/common/common/*.so ${D}${libdir}/
    install -m 0755 ${S}/out/ohos-arm64-release/communication/dsoftbus_standard/*.so ${D}${libdir}/
    install -m 0755 ${S}/out/ohos-arm64-release/security/huks/*.so ${D}${libdir}/
    install -m 0755 ${S}/out/ohos-arm64-release/security/deviceauth_standard/*.so ${D}${libdir}/

    # prepare bin
    install -m 0755  ${S}/out/ohos-arm64-release/communication/dsoftbus_standard/softbus_server_main ${D}${bindir}/

    # prepare head files
    install -m 554 \
        ${S}/foundation/communication/dsoftbus/interfaces/kits/discovery/*.h \
        ${S}/foundation/communication/dsoftbus/interfaces/kits/common/*.h \
        ${S}/foundation/communication/dsoftbus/interfaces/kits/bus_center/*.h \
        ${S}/foundation/communication/dsoftbus/interfaces/kits/transport/*.h \
        ${S}/foundation/communication/dsoftbus/core/common/include/softbus_errcode.h \
        ${S}/base/security/deviceauth/interfaces/innerkits/*.h \
        ${S}/third_party/cJSON/*.h \
        ${S}/third_party/bounds_checking_function/include/*.h \
        ${S}/depend/syspara/include/*.h \
            ${D}${includedir}/
}
