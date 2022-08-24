PV = "5.15"

SRC_URI_remove = "${KERNELORG_MIRROR}/software/network/ethtool/ethtool-${PV}.tar.gz \
           file://avoid_parallel_tests.patch \
           "

SRC_URI = "file://ethtool-${PV}.tar.xz"

SRC_URI[sha256sum] = "686fd6110389d49c2a120f00c3cd5dfe43debada8e021e4270d74bbe452a116d"
