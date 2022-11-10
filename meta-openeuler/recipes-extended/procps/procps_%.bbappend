#main bbfile: yocto-poky/meta/recipes-extended/procps/procps_3.3.17.bb

#version in openEuler
PV = "4.0.0"

S = "${WORKDIR}/${BPN}-ng-${PV}"

FILESEXTRAPATHS_append := "${THISDIR}/procps/:"

OPENEULER_REPO_NAME = "${BPN}-ng"

# files, patches can't be applied in openeuler or conflict with openeuler
SRC_URI_remove = " \
            git://gitlab.com/procps-ng/procps.git;protocol=https \
            git://gitlab.com/procps-ng/procps.git;protocol=https;branch=master \
            file://0001-w.c-correct-musl-builds.patch \
            file://0002-proc-escape.c-add-missing-include.patch \
            "
# files, patches that come from openeuler
SRC_URI += " \
        file://procps-ng-${PV}.tar.xz \
        file://0001-add-M-and-N-options-for-top.patch \
        file://0002-top-exit-with-error-when-pid-overflow.patch \
        file://0003-top-eliminate-a-potential-abend-when-exiting-A-mode.patch \
        "

do_configure_prepend() {
    # cannot run po/update-potfiles in new version
    if [ ! -f ${S}/po/update-potfiles ]; then
        touch ${S}/po/update-potfiles
        chmod +x ${S}/po/update-potfiles
    fi
}

SRC_URI[tarball.md5sum] = "eedf93f2f6083afb7abf72188018e1e5"
SRC_URI[tarball.sha256sum] = "0f4d92794edb7a1c95bb3b8c1f823de62be5d0043459c2155fd07fa859c16513"
