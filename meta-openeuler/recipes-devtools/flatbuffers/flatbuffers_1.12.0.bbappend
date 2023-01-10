PV = "2.0.6"

# find patches under openeuler at firse
FILESEXTRAPATHS_prepend := "${THISDIR}/files/:"

SRCREV = "3d79a88adb0eceb2ab5ff994c9b4c03b4b3c0daf"

EXTRA_OECMAKE:append:class-target = " -DFLATBUFFERS_BUILD_FLATC=0"

SRC_URI += " \
        file://0001-muslc_flatbuffers_build_fix.patch \
"
SRC_URI_remove_class-native = " \
        file://0001-muslc_flatbuffers_build_fix.patch \
"

