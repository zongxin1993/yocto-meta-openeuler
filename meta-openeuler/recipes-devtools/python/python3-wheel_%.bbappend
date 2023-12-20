PV = "0.37.1"

OPENEULER_SRC_URI_REMOVE = "http"
OPENEULER_LOCAL_NAME = "oee_archive"

# upstream source
SRC_URI:prepend = " \
            file://${OPENEULER_LOCAL_NAME}/${BPN}/wheel-${PV}.tar.gz  \
            "

SRC_URI[sha256sum] = "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"


