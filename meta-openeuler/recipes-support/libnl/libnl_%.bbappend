PV = "3.7.0"

OPENEULER_REPO_NAME = "libnl3"

SRC_URI_remove += "https://github.com/thom311/${BPN}/releases/download/${BPN}${@d.getVar('PV').replace('.','_')}/${BP}.tar.gz \
"

SRC_URI += "file://${BP}.tar.gz;name=tarball"

SRC_URI[tarball.md5sum] = "b381405afd14e466e35d29a112480333"
SRC_URI[tarball.sha256sum] = "9fe43ccbeeea72c653bdcf8c93332583135cda46a79507bfd0a483bb57f65939"