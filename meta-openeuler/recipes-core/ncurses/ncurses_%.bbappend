# main bbfile: yocto-poky/meta/recipes-core/ncurses_6.2.bb

# ncurses version in openEuler
PV = "6.3"

# use the source packages from openEuler
SRC_URI_prepend = "file://ncurses/${BP}.tar.gz \
"

# remove src_uri from git and patchs can't apply
SRC_URI_remove = "git://salsa.debian.org/debian/ncurses.git;protocol=https \
		  file://0002-configure-reproducible.patch \
		  file://0003-gen-pkgconfig.in-Do-not-include-LDFLAGS-in-generated.patch \
"

# patchs in openEuler
SRC_URI += "file://ncurses/ncurses-config.patch \
           file://ncurses/ncurses-libs.patch \
           file://ncurses/ncurses-urxvt.patch \
           file://ncurses/ncurses-kbs.patch \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=f852913c5d988a5f5a2f1df7ba7ee893"

S = "${WORKDIR}/${BP}"
