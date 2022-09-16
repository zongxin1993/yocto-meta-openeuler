PV = "3.3"

DEPENDS += "${@bb.utils.contains('LIBC', 'musl', 'fts', '', d)}"

do_configure_prepend_libc-musl () {
    if  ! grep -q "-lfts" ${S}/src/Makefile ; then  sed -i 's/FTS_LDLIBS ?=/FTS_LDLIBS ?= -lfts/' ${S}/src/Makefile; fi    
        sed -i '/.*FTS_LDLIBS*/c\override LDLIBS += -lselinux -lfts'  ${S}/utils/Makefile
        sed -i 's/malloc_trim/malloc/g'        ${S}/src/load_policy.c
}
