# main bbfile: yocto-poky/meta/recipes-core/update-rc.d/update-rc.d_0.8.bb

DOWNLOAD_REPO = "yocto-embedded-tools"

# source from from yocto-embedded-tools
SRC_URI = "file://yocto-embedded-tools/build_tools/update-rc.d"

S = "${WORKDIR}/yocto-embedded-tools/build_tools/update-rc.d"
