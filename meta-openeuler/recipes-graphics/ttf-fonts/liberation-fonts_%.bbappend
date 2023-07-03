# main bb file: yocto-poky/meta/recipes-graphics/ttf-fonts/liberation-fonts_2.1.5.bb

PV = "2.00.5"

S = "${WORKDIR}/liberation-fonts-${PV}"

SRC_URI:remove = "https://github.com/liberationfonts/liberation-fonts/files/7261482/liberation-fonts-ttf-${PV}.tar.gz \
"

SRC_URI:prepend = "file://${PV}.tar.gz \
"
