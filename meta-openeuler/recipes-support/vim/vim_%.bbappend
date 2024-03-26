# bbfile: yocto-poky/meta/recipes-support/vim/vim_9.0.bb

PV = "9.0.2092"

LIC_FILES_CHKSUM = "file://LICENSE;md5=d1a651ab770b45d41c0f8cb5a8ca930e"


# file://vim-7.0-fixkeys.patch
# file://vim-7.4-specsyntax.patch
# file://vim-7.4-fstabsyntax.patch
# file://vim-7.4-globalsyntax.patch
# file://vim-8.0-copy-paste.patch
# file://vim-python3-tests.patch
# file://bugfix-rm-modify-info-version.patch

SRC_URI = " \
        file://vim-9.0.2092.tar.gz \
        file://vimrc \
        file://virc \
"

S = "${WORKDIR}/vim-9.0.2092"
