
PV = "1.21.0"

# modify 0002-meson.build-find-the-native-wayland-scanner-directly.patch
FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# 0001-build-Fix-strndup-detection-on-MinGW.patch cannot be applied
SRC_URI:remove = "https://wayland.freedesktop.org/releases/${BPN}-${PV}.tar.xz \
                  file://0001-build-Fix-strndup-detection-on-MinGW.patch \
"
SRC_URI:prepend = "file://wayland-${PV}.tar.gz \
"

# fix ERROR: Problem encountered: -Dtests=true requires -Dlibraries=true
EXTRA_OEMESON:remove:class-native = "-Dlibraries=false"
