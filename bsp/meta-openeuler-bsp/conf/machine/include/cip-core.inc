DEBIAN_BASED = "${@bb.utils.contains('CIP_CORE', '1', 'debian', 'nondebian', d)}"
#DEBIAN_BASED = "nondebian"
OVERRIDES .= ":${DEBIAN_BASED}"

BBMASK:append:nondebian = " recipes-debian"

BBMASK:append:debian = " perl_debian"

# Select gcc,gdb, python3 debian version
GCCVERSION_debian = "8.3.0"
SDKGCCVERSION_debian = "${GCCVERSION}"

GLIBCVERSION_debian = "2.31%"
PREFERRED_VERSION_glibc_debian = "${GLIBCVERSION}"
PREFERRED_VERSION_nativesdk-glibc_debian = "${GLIBCVERSION}"
PREFERRED_VERSION_nativesdk-glibc-locale_debian = "${GLIBCVERSION}" 

BINUVERSION_debian = "2.31.%"
PREFERRED_VERSION_nativesdk-binutils_debian = "${BINUVERSION}"

PREFERRED_VERSION_gdb_debian = "9.1"

PREFERRED_VERSION_busybox_debian = "1.31.%"

RDEPENDS:xz:append:debian = "bash"
RDEPENDS:gzip:append:debian = "bash"
RDEPENDS:adduser:append:debian = "perl"

