DEPENDS = "opensbi deploy-bootfiles"

IMAGE_FSTYPES = "qspi"

do_rootfs[depends] = "openeuler-image-live:do_rootfs"
do_image[depends] += " deploy-bootfiles:do_deploy"
do_image[depends] += " opensbi:do_deploy"
do_image[depends] += " virtual/kernel:do_deploy"

IMAGE_CMD:qspi () {
	dd if=${DEPLOY_DIR_IMAGE}/bootcode.bin of=${DEPLOY_DIR_IMAGE}/QSPI-Image.bin bs=32 seek=0 count=128
	dd if=${DEPLOY_DIR_IMAGE}/bootjump.bin of=${DEPLOY_DIR_IMAGE}/QSPI-Image.bin bs=32 seek=128 count=1
	dd if=${DEPLOY_DIR_IMAGE}/jh7110-visionfive-v2.dtb of=${DEPLOY_DIR_IMAGE}/QSPI-Image.bin bs=32 seek=129 count=255
	dd if=${DEPLOY_DIR_IMAGE}/fw_payload.bin of=${DEPLOY_DIR_IMAGE}/QSPI-Image.bin bs=32 seek=384
}
