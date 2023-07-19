PV = "3.10.9"

# remove conflicting patch
SRC_URI:remove = "file://cve-2023-24329.patch"

SRC_URI:prepend = " file://00001-rpath.patch \
           file://00251-change-user-install-location.patch \
           file://backport-Make-urllib.parse.urlparse-enforce-that-a-scheme-mus.patch \
           file://add-the-sm3-method-for-obtaining-the-salt-value.patch \
           file://fix-CVE-2023-24329.patch \
"

# meta-openeuler layer does not need to build python3-native dependency packages,
# but gets them directly from the nativesdk tool
# Find header from nativesdk
CPPFLAGS:append:class-native = " -I${OPENEULER_NATIVESDK_SYSROOT}/usr/include \
    -I${OPENEULER_NATIVESDK_SYSROOT}/usr/include/ncursesw -I${OPENEULER_NATIVESDK_SYSROOT}/usr/include/uuid \
"

# Find library from nativesdk
LDFLAGS:append:class-native = " -L${OPENEULER_NATIVESDK_SYSROOT}/usr/lib"
