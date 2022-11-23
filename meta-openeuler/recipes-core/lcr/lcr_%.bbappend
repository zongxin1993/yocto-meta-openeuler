# add patch to support musl
SRC_URI_append_libc-musl = " \
           file://lcr-for-musl.patch \
"
