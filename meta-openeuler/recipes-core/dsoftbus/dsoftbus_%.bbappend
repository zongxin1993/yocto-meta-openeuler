# add patch to support musl
SRC_URI_append_libc-musl = " \
        file://change-musl-toolchain.patch;patchdir=${S}/build \
        file://dsoftbus-musl.patch;patchdir=${WORKDIR}/dsoftbus_standard \
"
