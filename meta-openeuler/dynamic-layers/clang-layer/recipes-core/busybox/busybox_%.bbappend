CFLAGS:append:raspberrypi4-64 = " -DBB_GLOBAL_CONST='' "
CC:append:toolchain-clang = "${@bb.utils.contains('DISTRO_FEATURES', 'ld-is-lld', ' -fuse-ld=lld', '', d)}"
