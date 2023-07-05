PV = "0.42.2"

SRC_URI:remove = "https://www.cairographics.org/releases/${BP}.tar.gz \
"

SRC_URI:prepend = "file://${BPN}-${BP}.tar.bz2 \
"

S = "${WORKDIR}/${BPN}-${BP}"
