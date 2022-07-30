PV = "3.5.2"

SRC_URI[sha256sum] = "5f245bd5176bc5f67428eb0aa497e09979264a153a074d35416521a5b8e86189"

# add patches from openeuler
SRC_URI += " \
    file://backport-libarchive-3.5.2-symlink-fix.patch \
    file://backport-CVE-2021-36976.patch \
    file://backport-CVE-2021-31566.patch \
    file://libarchive-uninitialized-value.patch \
"

#${STAGING_INCDIR_NATIVE}/ext2fs not exist when not building e2fsprogs-native
python() {
    openeuler_sysroot = d.getVar('OPENEULER_NATIVESDK_SYSROOT')
    if openeuler_sysroot:
       d.setVar('STAGING_INCDIR_NATIVE', "%s/usr/include" % openeuler_sysroot)
}
