# main bbfile: yocto-poky/meta/recipes-devtools/perl/libxml-parser-perl_2.46.bb
PV = "2.46"

OPENEULER_SRC_URI_REMOVE = "http"
OPENEULER_LOCAL_NAME = "libxml-parser-perl"

# openeuler source
SRC_URI:prepend = "file://XML-Parser-${PV}.tar.gz"

S = "${WORKDIR}/XML-Parser-${PV}"
