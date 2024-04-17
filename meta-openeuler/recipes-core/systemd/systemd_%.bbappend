# main bbfile: openembedded-core/meta/recipes-core/systemd/systemd_253.7.bb

#version in openEuler
PV = "255"
S = "${WORKDIR}/${BP}"

require systemd-openeuler.inc

DISTRO_FEATURES:append = " usrmerge"

# depmodwrapper is not valid to do depmod in buildtime, add a service to do it in runtime as a workaround.
# as modutils.sh is not run under systemd
PACKAGE_BEFORE_PN:append = " ${PN}-depmod "
SRC_URI:append = " file://systemd-depmod.service"
FILES:${PN}-depmod = "${systemd_unitdir}/system/systemd-depmod.service"
SYSTEMD_SERVICE:${PN}-depmod = "systemd-depmod.service"
do_install:append () {
    install -m 0644 ${WORKDIR}/systemd-depmod.service ${D}${systemd_unitdir}/system/systemd-depmod.service
    mkdir -p ${D}${systemd_unitdir}/system/sysinit.target.wants/
    ln -sf .${systemd_unitdir}/system/systemd-depmod.service ${D}${systemd_unitdir}/system/sysinit.target.wants/systemd-depmod.service
    # the default DNS servers systemd resolved use cannot be accessed in China
    # so we need to change the default DNS servers to the ones that can be accessed in China
    # for example, we can use AliDNS servers
    sed -i 's/#DNS=/DNS=223.5.5.5/' ${D}${sysconfdir}/systemd/resolved.conf
}

# do_install:append () {
#     install -m 0644 ${B}/units/systemd-binfmt.service ${D}/${systemd_user_unitdir}/systemd-binfmt.service
# }

FILES:${PN}-binfmt:append = " \
        /usr/lib/systemd/system/systemd-binfmt.service \
"

# glib needs meson, meson needs python3-native
# here use nativesdk's meson-native and python3-native
DEPENDS:remove = "python3-native"

FILES:udev += " \
               ${rootlibexecdir}/udev/rules.d/40-elevator.rules \
               ${rootlibexecdir}/udev/rules.d/73-idrac.rules \
"

