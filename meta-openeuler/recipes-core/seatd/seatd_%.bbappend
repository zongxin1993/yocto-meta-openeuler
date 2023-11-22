# main bb: yocto-poky/meta/recipes-core/seatd/seatd_0.6.4.bb

OPENEULER_SRC_URI_REMOVE = "https http git"

OPENEULER_LOCAL_NAME = "oee_archive"

PV = "0.6.4"

SRC_URI += "file://${OPENEULER_LOCAL_NAME}/${BPN}/seatd-${PV}.tar.gz \
"

S = "${WORKDIR}/seatd-${PV}"

