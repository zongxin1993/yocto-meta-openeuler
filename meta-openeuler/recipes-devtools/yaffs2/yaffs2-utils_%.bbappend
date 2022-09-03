# The recipe and patch files are from: http://git.openembedded.org/meta-openembedded/tree/meta-filesystems/recipes-filesystems/yaffs2

# Used when the repository name is inconsistent with the software package.
OPENEULER_REPO_NAME = "yaffs2"

# Modify the version number according to the local software package from openEuler.
PV = "b4ce1bb"

# Remove the package download address in the original bb file.
SRC_URI_remove = "git://www.aleph1.co.uk/yaffs2;protocol=git;branch=master \
                  "

# Change SRC_URI to local package.
# Since the bb name is yaffs2-utils, but the local package name is yaffs2, so yaffs2-${PV} not ${BP}.
SRC_URI_prepend = "file://yaffs2-${PV}.tar.gz \
                   "

# Verify SHA-256 and MD5 checksum to ensure that the file is downloaded accurately.
SRC_URI[md5sum] = "e9e02b1fc4ef543d0d750294047c563c"
SRC_URI[sha256sum] = "2633a083ed89f27a6037b616e0b7a496c04581a57f4ae2f48b6e559d377530a0"

# S needs to be consistent with the package name in SRC_URI above.
S = "${WORKDIR}/yaffs2-${PV}"
