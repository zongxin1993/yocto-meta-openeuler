OPENEULER_SRC_URI_REMOVE = "git https http"

PV = "3.1"

OPENEULER_LOCAL_NAME = "oee_archive"

# remove poky source
SRC_URI:remove = "git://github.com/thkukuk/libnss_nis;branch=master;protocol=https \
                 "

# upstream source
SRC_URI:prepend = " \
            file://${OPENEULER_LOCAL_NAME}/${BPN}/libnss-nis-${PV}.tar.gz  \
           "
