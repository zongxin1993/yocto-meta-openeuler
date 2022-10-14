# add libexecinfo libmallocutils DEPENDS to support musl
DEPENDS_append_libc-musl = " libexecinfo libmallocutils "

SRC_URI_append_libc-musl = " \
        file://isulad-musl.patch \
"

do_configure_prepend_libc-musl () {
        if grep -q "\-Werror" ${S}/cmake/set_build_flags.cmake ; then
              sed -i 's/-Werror/-Werror -w/' ${S}/cmake/set_build_flags.cmake
        fi
}
