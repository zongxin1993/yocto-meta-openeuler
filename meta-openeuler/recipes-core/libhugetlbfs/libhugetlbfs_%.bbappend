# add patch to support musl
SRC_URI_append_libc-musl = " \
        file://libhugetlbfs-musl.patch \
"
