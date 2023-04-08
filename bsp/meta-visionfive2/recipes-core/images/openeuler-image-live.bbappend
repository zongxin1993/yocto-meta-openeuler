# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

DEPENDS = "coremark dhrystone"

INITRAMFS_SCRIPTS = "\
                      initramfs-boot packagegroup-core-boot \
		     "

PACKAGE_INSTALL = "${INITRAMFS_SCRIPTS} ${VIRTUAL-RUNTIME_base-utils} base-passwd ${ROOTFS_BOOTSTRAP_INSTALL}  helloworld coremark dhrystone"
PACKAGE_INSTALL += "sudo base-files curl iptables openssh tar libcgroup docker"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "openeuler-image-live"
IMAGE_NAME_SUFFIX ?= ""
IMAGE_LINGUAS = ""

INITRAMFS_IMAGE_BUNDLE = "1"
INITRAMFS_FSTYPES = "cpio.gz"
INITRAMFS_MAXSIZE ="15728640"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"
EXTRA_IMAGEDEPENDS ?= ""

# Use the same restriction as initramfs-module-install
COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|aarch64.*|riscv64.*|rv64.*)-(linux.*|freebsd.*)'

# Override this as the qspi-image will populate the sdk_ext
do_populate_sdk_ext () {
}


