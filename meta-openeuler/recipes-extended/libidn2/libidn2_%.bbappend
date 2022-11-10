# main bbfile: yocto-poky/meta/recipes-extended/libidn/libidn2_2.3.0.bb

# version in openEuler
PV = "2.3.3"

# solve lic check failed
LIC_FILES_CHKSUM_remove = " \
        file://src/idn2.c;endline=16;md5=426b74d6deb620ab6d39c8a6efd4c13a \
        file://lib/idn2.h.in;endline=27;md5=c2cd28d3f87260f157f022eabb83714f \
"
LIC_FILES_CHKSUM += " \
        file://src/idn2.c;endline=16;md5=0f347a5b17acf44440bf53e406f1df70 \
        file://lib/idn2.h.in;endline=27;md5=4d7b3771faa9c60067ed1da914508bc5 \
"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
        ${GNU_MIRROR}/libidn/${BPN}-${PV}.tar.gz \
"

# files, patches that come from openeuler
SRC_URI += " \
        file://${BP}.tar.gz;name=tarball \
        file://bugfix-libidn2-change-rpath.patch \
"

SRC_URI[tarball.md5sum] = "82c0739df7ad818c70953453fb9c626d"
SRC_URI[tarball.sha256sum] = "f3ac987522c00d33d44b323cae424e2cffcb4c63c6aa6cd1376edacbf1c36eb0"
