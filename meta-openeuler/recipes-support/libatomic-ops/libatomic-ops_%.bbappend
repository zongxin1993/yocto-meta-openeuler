# main bbfile: yocto-poky/meta/recipes-support/libatomic-ops/libatomic-ops_7.6.10.bb

PV = "7.6.14"
OPENEULER_REPO_NAME = "libatomic_ops"

# apply src and patch from openEuler
SRC_URI = "file://libatomic_ops-${PV}.tar.gz \
	   file://libatomic_ops-7.6.12-sw.patch \
	  "

SRC_URI[md5sum] = "ee8251f5091b7938d18be4dda843a515"
SRC_URI[sha256sum] = "390f244d424714735b7050d056567615b3b8f29008a663c262fb548f1802d292"
