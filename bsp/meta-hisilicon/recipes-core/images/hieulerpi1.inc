DEPENDS += "hieulerpi1-tf-a"
copy_kernel_distro() {
    cp ${DEPLOY_DIR_IMAGE}/kernel-pi ${OUTPUT_DIR}
}
IMAGE_POSTPROCESS_COMMAND:append = "copy_kernel_distro;"
