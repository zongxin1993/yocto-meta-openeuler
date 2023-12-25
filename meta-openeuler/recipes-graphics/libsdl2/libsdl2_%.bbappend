# openeuler version
PV = "2.28.4"

# remove poky src_uri
OPENEULER_SRC_URI_REMOVE = "git https http"
# remove poky license
LIC_FILES_CHKSUM:remove = "file://LICENSE.txt;md5=68a088513da90254b2fbe664f42af315"

# add openeuler license
LIC_FILES_CHKSUM:append = "file://LICENSE.txt;md5=31f575634fd56b27fc6b6cbe8dc9bd38"

# bb setting from 2.28.4
EXTRA_OECMAKE = "-DSDL_OSS=OFF -DSDL_ESD=OFF -DSDL_ARTS=OFF \
                 -DSDL_DISKAUDIO=OFF -DSDL_NAS=OFF -DSDL_ESD_SHARED=OFF \
                 -DSDL_DUMMYVIDEO=OFF \
                 -DSDL_RPI=OFF \
                 -DSDL_PTHREADS=ON \
                 -DSDL_RPATH=OFF \
                 -DSDL_SNDIO=OFF \
                 -DSDL_X11_XCURSOR=OFF \
                 -DSDL_X11_XDBE=OFF \
                 -DSDL_X11_XFIXES=OFF \
                 -DSDL_X11_XINPUT=OFF \
                 -DSDL_X11_XRANDR=OFF \
                 -DSDL_X11_XSCRNSAVER=OFF \
                 -DSDL_X11_XSHAPE=OFF \
"

PACKAGECONFIG ??= " \
    ${PACKAGECONFIG_GL} \
    ${@bb.utils.filter('DISTRO_FEATURES', 'alsa directfb pulseaudio pipewire x11 vulkan', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'wayland gles2', '', d)} \
    ${@bb.utils.contains("TUNE_FEATURES", "neon","arm-neon","",d)} \
"

# attr from 2.28.4
PACKAGECONFIG[libusb] = ",,libusb1"
PACKAGECONFIG[libdecor] = "-DSDL_WAYLAND_LIBDECOR=ON,-DSDL_WAYLAND_LIBDECOR=OFF,libdecor,libdecor"
PACKAGECONFIG[pipewire] = "-DSDL_PIPEWIRE_SHARED=ON,-DSDL_PIPEWIRE_SHARED=OFF,pipewire"
PACKAGECONFIG[vulkan]    = "-DSDL_VULKAN=ON,-DSDL_VULKAN=OFF"

FILES:${PN} += "${datadir}/licenses/SDL2/LICENSE.txt"

# remove 2.0.20.bb SRC_URI
SRC_URI:remove = "\
           http://www.libsdl.org/release/SDL2-${PV}.tar.gz \
           file://optional-libunwind-generic.patch \
           file://0001-sdlchecks.cmake-pass-cflags-to-the-appropriate-cmake.patch \
           file://0001-Fix-potential-memory-leak-in-GLES_CreateTextur.patch \
           "
SRC_URI:remove:class-native = " file://0001-Disable-libunwind-in-native-OE-builds-by-not-looking.patch"

# add 2.28.4.bb SRC_URI
SRC_URI:prepend = "file://SDL2-${PV}.tar.gz\
                  "
SRC_URI[sha256sum] = "888b8c39f36ae2035d023d1b14ab0191eb1d26403c3cf4d4d5ede30e66a4942c"

S = "${WORKDIR}/SDL2-${PV}"

# setting openeuler name
OPENEULER_LOCAL_NAME = "libsdl2"
