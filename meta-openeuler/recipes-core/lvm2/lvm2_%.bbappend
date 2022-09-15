# for musl
SRC_URI_append_libc-musl =" \
    file://add_mallinfo.patch \
    file://lvmcmdline.patch \
"
