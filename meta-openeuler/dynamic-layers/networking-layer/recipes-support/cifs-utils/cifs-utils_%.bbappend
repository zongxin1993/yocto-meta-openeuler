PV = "6.15"

OPENEULER_SRC_URI_REMOVE = "https git http"
SRC_URI_prepend = "file://${BP}.tar.bz2 \
           "

SRC_URI[sha256sum] = "a7b6940e93250c1676a6fa66b6ead91b78cd43a5fee99cc462459c8b9cf1e6f4"

S = "${WORKDIR}/${BP}"

# keep the same as before, otherwise a large number of dependencies will be introduced
DEPENDS_remove = "libtalloc"
