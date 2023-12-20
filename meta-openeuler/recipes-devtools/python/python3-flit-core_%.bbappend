PV = "3.7.1"

OPENEULER_SRC_URI_REMOVE = "http"
OPENEULER_LOCAL_NAME = "oee_archive"

# upstream source
SRC_URI:prepend = " \
            file://${OPENEULER_LOCAL_NAME}/${BPN}/flit-${PV}.tar.gz  \
           "

SRC_URI[sha256sum] = "3c9bd9c140515bfe62dd938c6610d10d6efb9e35cc647fc614fe5fb3a5036682"
