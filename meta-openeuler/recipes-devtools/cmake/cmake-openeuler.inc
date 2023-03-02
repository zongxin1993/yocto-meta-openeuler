# main inc: yocto-poky/meta/recipes-devtools/cmake/cmake.inc

OPENEULER_SRC_URI_REMOVE = "https git http"
OPENEULER_REPO_NAME = "cmake"
OPENEULER_BRANCH = "openEuler-22.03-LTS-SP1"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LIC_FILES_CHKSUM = "file://Copyright.txt;md5=31023e1d3f51ca90a58f55bcee8e2339"

# version in openEuler
PV = "3.22.0"
S = "${WORKDIR}/cmake-${PV}"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
"

# files, patches that come from openeuler
SRC_URI_prepend = " \
    file://cmake-3.22.0.tar.gz \
    file://cmake-findruby.patch \
    file://cmake-fedora-flag_release.patch \
    file://cmake-mingw-dl.patch \
    file://cmake-3.22.0-sw.patch \
"

