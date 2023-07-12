# the main bb file: yocto-poky/meta/recipes-gnome/gobject-introspection/gobject-introspection_1.72.0.bb

# openEuler-23.03 version is 1.74.0, but gobject-introspection-native depends glib2 at least 2.74 version.
# nativesdk provides glib2 is too old to compile, so do not update package version now.

# DEPENDS:remove:class-target = "prelink-native"

SRC_URI:remove = "${GNOME_MIRROR}/${BPN}/${@oe.utils.trim_version("${PV}", 2)}/${BPN}-${PV}.tar.xz \
"

SRC_URI:append = " \
        file://${BP}.tar.xz \
"

do_configure:append:class-target() {
        # delete prelink-rtld
        cat > ${B}/g-ir-scanner-lddwrapper << EOF
#!/bin/sh
\$OBJDUMP -p "\$@"
EOF
}

# RDEPENDS:${PN}:remove:class-native = "python3-pickle python3-xml"
