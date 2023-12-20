PV = "0.5.1"

OPENEULER_SRC_URI_REMOVE = "http"
OPENEULER_LOCAL_NAME = "oee_archive"

# upstream source
SRC_URI:prepend = " \
            file://${OPENEULER_LOCAL_NAME}/${BPN}/installer-${PV}.tar.gz  \
           "

SRC_URI[sha256sum] = "f970995ec2bb815e2fdaf7977b26b2091e1e386f0f42eafd5ac811953dc5d445"
