SRC_URI_append_libc-musl = " \
          file://lxc-for-musl.patch \
"
CFLAGS_append_libc-musl = " -Wno-error=stringop-overread  -Wno-error=address   -Wno-error=array-bounds -Wno-array-bounds " 
do_compile_prepend_libc-musl() {
       sed -i "s/init_lxc_static_LDFLAGS = -all-static -pthread/init_lxc_static_LDFLAGS = -pthread/" ${S}/src/lxc/Makefile.am
}

