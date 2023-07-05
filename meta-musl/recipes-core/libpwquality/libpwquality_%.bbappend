DEPENDS:append ="\
  gcompat \
"
LDFLAGS:append = " -lgcompat"

#add patch to support musl
FILESEXTRAPATHS:prepend := "${THISDIR}/libpwquality/:"
SRC_URI:append = " \
          file://libpwquality-musl.patch \
"
