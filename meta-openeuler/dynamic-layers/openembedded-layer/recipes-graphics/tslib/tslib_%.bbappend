# main bbfile: meta-oe/recipes-graphics/tslib/tslib_1.22.bb

PV = "1.16"

SRC_URI:remove = "https://github.com/kergoth/tslib/releases/download/${PV}/tslib-${PV}.tar.xz;downloadfilename=tslib-${PV}.tar.xz \
"

SRC_URI:prepend = "file://${BP}.tar.bz2 \
"

S = "${WORKDIR}/${BP}"
