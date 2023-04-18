require linux-mainline-common.inc
BRANCH = "JH7110_VisionFive2_devel"
SRCREV = "7b7b4eddd8d5ae55f6e0ee09b93e16e23ab4f97b"

LINUX_VERSION = "5.15"
LINUX_VERSION_EXTENSION:append = "-starlight"

FILESEXTRAPATHS_append := "${THISDIR}/files/:"

SRC_URI = "git://github.com/starfive-tech/linux.git;protocol=https;branch=${BRANCH} \
	   file://config/defconfig \
	   "

INITRAMFS_IMAGE_BUNDLE = "1"
INITRAMFS_IMAGE = "openeuler-image-live"

COMPATIBLE_MACHINE = "(starfive-dubhe)"

KERNEL_VERSION_SANITY_SKIP="1"

RDEPENDS_${KERNEL_PACKAGE_NAME}-base = ""

pkg_postinst_${KERNEL_PACKAGE_NAME}-base () {
    :
}

