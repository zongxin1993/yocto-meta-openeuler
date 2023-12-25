# main bbfile: yocto-poky/meta/recipes-devtools/perl/libxml-parser-perl_2.46.bb
PV = "6.5.3"

OPENEULER_SRC_URI_REMOVE = "http https git"
OPENEULER_LOCAL_NAME = "btrfs-tools"
# remove poky attr
SRC_URI:remove = "\
           git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git;branch=master \
           file://0001-Add-a-possibility-to-specify-where-python-modules-ar.patch \
           "

# attr from 6.5.3.bb
DEPENDS = "lzo util-linux zlib"
SRCREV = "a45c360b64660477c726e192d9e92ceb73a50f80"
PACKAGECONFIG[manpages] = "--enable-documentation, --disable-documentation, python3-sphinx-native"
PACKAGECONFIG[lzo] = "--enable-lzo,--disable-lzo,lzo"

# openeuler source
SRC_URI:prepend = "file://btrfs-progs-v${PV}.tar.xz \
                  "

S = "${WORKDIR}/btrfs-progs-v${PV}"
