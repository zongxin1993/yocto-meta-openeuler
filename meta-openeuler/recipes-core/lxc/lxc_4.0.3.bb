SUMMARY = "Protocol Buffers - structured data serialization mechanism"
DESCRIPTION = "Yet Another JSON Library - A Portable JSON parsing and serialization library in ANSI C"
SECTION = "console/tools"
LICENSE = "BSD-2-Clause"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://${BP}.tar.gz \
           file://0001-refactor-patch-code-of-utils-commands-and-so-on.patch \
           file://0002-refactor-patch-code-of-isulad-for-conf-exec-attach.patch \
           file://0003-refactor-patch-code-of-isulad-for-selinux-attach.patch \
           file://0004-refactor-patch-code-of-lxccontianer-and-so-on.patch \
           file://0005-refactor-patch-code-of-attach-and-seccomp.patch \
           file://0006-refactor-patch-about-namespace-log-terminal.patch \
           file://0007-refactor-patches-on-terminal.c-start.c-and-so-on.patch \
           file://0008-refactor-patch-code-of-json.patch \
           file://0009-fix-HOME-env-of-container-unset-error.patch \
           file://0010-check-yajl-only-when-have-isulad.patch \
           file://0011-drop-security_context_t.patch \
           file://0012-only-set-user-or-image-set-non-empty-HOME.patch \
           file://0013-return-fail-if-no-args-or-no-rootfs-path-found.patch \
           file://0014-fix-tools-using-option-give-error-message.patch \
           file://0015-fix-do-mask-pathes-after-parent-mounted.patch \
           file://0016-skip-kill-cgroup-processes-if-no-hierarchies.patch \
           file://0017-lxc-Add-sw64-architecture.patch \
"

SRC_URI_append = " \
		   file://check_only_rootfs_as_filesystem_type.patch \
		   file://support_arm32.patch \
"

DEPENDS = "yajl libseccomp libcap"

EXTRA_OECONF = "--disable-static --disable-openssl --with-rootfs-path=/var/lib/lxc/rootfs --with-distro=openeuler"

inherit autotools

BBCLASSEXTEND = "native nativesdk"

CFLAGS_append = "-Wno-error=stringop-overflow -Wno-error=strict-prototypes -Wno-error=old-style-definition"
