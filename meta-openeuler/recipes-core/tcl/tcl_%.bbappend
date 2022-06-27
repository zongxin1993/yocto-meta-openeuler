# tcl version in openEuler
PV = "8.6.10"

SRC_URI[sha256sum] = "5196dbf6638e3df8d5c87b5815c8c2b758496eb6f0e41446596c9a4e638d87ed"

# /usr/bin/crossscripts is a empty directory, we don't need it
tcl_package_preprocess_append() {
        rm -rf ${PKGD}${bindir_crossscripts}
}
