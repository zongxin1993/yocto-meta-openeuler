OPENEULER_REPO_NAME = "raspberrypi-firmware"
SRC_URI = "file://firmware-1.20220308.tar.gz \
"

S = "${WORKDIR}/firmware-1.20220308/boot"

# add uefi grub package
# rpi-tf-a package don't support clang compile
# and standard image don't use uefi and grub.
# so using MCS_FEATURES to distinguish standard image and mcs image.
do_deploy[depends] += "${@bb.utils.contains('MCS_FEATURES', 'rpi4', 'grub-efi:do_deploy grub-bootconf:do_deploy rpi-uefi:do_deploy', '', d)}"

# fix runtime error: Could not find DRM device!
# instead of bcm2711-rpi-4-b.dtb from kernel_devicetree
do_deploy_append() {
    cp ${S}/bcm2711-rpi-4-b.dtb ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}
}

inherit ${@bb.utils.contains('MCS_FEATURES', 'lopper-devicetree', 'lopper-devicetree', '', d)}

INPUT_DT = "${S}/bcm2711-rpi-4-b.dtb"
OUTPUT_DT = "${S}/bcm2711-rpi-4-b.dtb"
