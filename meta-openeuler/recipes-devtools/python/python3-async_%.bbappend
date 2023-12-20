PV = "0.6.2"

OPENEULER_SRC_URI_REMOVE = "http"
OPENEULER_LOCAL_NAME = "oee_archive"

# upstream source
SRC_URI:prepend = " \
            file://${OPENEULER_LOCAL_NAME}/${BPN}/async-${PV}.tar.gz  \
           "

SRC_URI[sha256sum] = "ac6894d876e45878faae493b0cf61d0e28ec417334448ac0a6ea2229d8343051"
