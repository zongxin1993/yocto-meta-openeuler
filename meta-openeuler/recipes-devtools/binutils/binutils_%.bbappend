require binutils_src.inc

# add patch to support musl
FILESEXTRAPATHS_prepend := "${THISDIR}/binutils/:"
SRC_URI_append_libc-musl = " \
    file://use-static_cast.patch \
"
