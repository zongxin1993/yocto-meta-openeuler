
OPENEULER_LOCAL_NAME = "oee_archive"

PV = "20211108"

SRC_URI:prepend = "file://${OPENEULER_LOCAL_NAME}/${BPN}/${BP}.tar.gz \
"
