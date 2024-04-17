.. _tasks:

=======
6 任务
=======

任务是 BitBake 的执行单位。配方（ .bb 文件）使用任务来完成配置、编译和打包软件。本章提供了OpenEmbedded构建系统中定义的任务的参考。

6.1 普通配方构建任务
==================

以下各节介绍与构建配方相关的常规任务。有关任务和依赖关系的更多信息，请参阅BitBake用户手册中的 `“任务” <https://docs.yoctoproject.org/bitbake/2.6/bitbake-user-manual/bitbake-user-manual-metadata.html#tasks>`_ 和 `“依赖关系” <https://docs.yoctoproject.org/bitbake/2.6/bitbake-user-manual/bitbake-user-manual-execution.html#dependencies>`_ 部分。

6.1.1 do_build
---------------

所有配方的默认任务。此任务取决于构建配方所需的所有其他常规任务。

6.1.2 do_compile
------------------

编译源代码。此任务在当前工作目录设置为${`B <https://docs.yoctoproject.org/ref-manual/variables.html#term-B>`_}的情况下运行。

此任务的默认行为是在找到生成文件（Makefile 、 makefile 或 GNUmakefile）时运行该 oe_runmake 函数。如果未找到此类文件，则do_compile任务不执行任何操作。

6.1.3 do_compile_ptest_base
----------------------------

编译正在构建的软件中包含的运行时测试套件。

6.1.4 do_configure
---------------------------

通过启用和禁用正在构建的软件的任何构建时和配置选项来配置源。任务在当前工作目录设置为${`B <https://docs.yoctoproject.org/ref-manual/variables.html#term-B>`_}的情况下运行。

此任务的默认行为是在找到生成文件（Makefile、makefile或GNUmakefile）且 `CLEANBROKEN <https://docs.yoctoproject.org/ref-manual/variables.html#term-CLEANBROKEN>`_ 未设置为“1”时运行oe_runmake clean。如果未找到此类文件或CLEANBROKEN变量设置为“1”，则do_configure任务不执行任何操作。

6.1.5 do_configure_ptest_base
------------------------------

配置正在构建的软件中包含的运行时测试套件。

6.1.6 do_deploy
-----------------

将要被部署的输出文件写入到${`DEPLOY_DIR_IMAGE <https://docs.yoctoproject.org/ref-manual/variables.html#term-DEPLOY_DIR_IMAGE>`_}。任务在当前工作目录设置为${`B <https://docs.yoctoproject.org/ref-manual/variables.html#term-B>`_}的情况下运行。

实现此任务的配方应继承 `deploy <https://docs.yoctoproject.org/ref-manual/classes.html#ref-classes-deploy>`_ 类，并应将输出写入${`DEPLOYDIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-DEPLOYDIR>`_}，这不应与${DEPLOY_DIR}混淆。`deploy <https://docs.yoctoproject.org/ref-manual/classes.html#ref-classes-deploy>`_ 类将do_deploy设置为共享状态（sstate）任务，可以通过使用sstate来加速。sstate机制负责将输出从${DEPLOYDIR}复制到${DEPLOY_DIR_IMAGE}。

.. note::

    不要将输出直接写入${DEPLOY_DIR_IMAGE}，因为这会导致状态机制出现故障。

默认情况下，do_deploy任务不会添加为任务，因此需要手动添加。如果希望任务在do_compile后运行，可以通过执行以下操作来添加它：

::

    addtask deploy after do_compile

在其他任务之后添加do_deploy的工作方式相同。

.. note::

    您不需要添加到before do_build addtask命令中（尽管它是无害的），因为 `基类 <https://docs.yoctoproject.org/ref-manual/classes.html#ref-classes-base>`_ 包含以下内容：
    ::
       do_build[recrdeptask] += "do_deploy"

    有关更多信息，请参阅BitBake用户手册中的 `“依赖关系” <https://docs.yoctoproject.org/bitbake/2.6/bitbake-user-manual/bitbake-user-manual-execution.html#dependencies>`_ 部分。

如果重新执行do_deploy任务，则删除任何以前的输出（即“清理”）。

6.1.7 do_fetch
---------------

获取源代码。此任务使用 `SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 变量和参数的前缀来确定正确的 `提取器 <https://docs.yoctoproject.org/bitbake/2.6/bitbake-user-manual/bitbake-user-manual-fetching.html#fetchers>`_ 模块。

6.1.8 do_image
---------------

do_image任务启动了镜像生成过程。在OpenEmbedded构建系统运行 `do_rootfs <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-rootfs>`_ 任务期间，该任务会运行，此时会确定要安装到镜像中的软件包并创建根文件系统，包括后处理。

do_image任务通过对镜像执行 `IMAGE_PREPROCESS_COMMAND <https://docs.yoctoproject.org/ref-manual/variables.html#term-IMAGE_PREPROCESS_COMMAND>`_ 来进行预处理，并根据需要动态生成支持的 `do_image_* <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-image>`_ 任务。

有关镜像创建的更多信息，请参阅Yocto项目概述和概念手册中的 `"镜像生成" <https://docs.yoctoproject.org/overview-manual/concepts.html#image-generation>`_ 部分。

6.1.10 do_install
------------------

将需要打包的文件复制到临时区域 ${`D <https://docs.yoctoproject.org/ref-manual/variables.html#term-D>`_} 中。该任务执行时，当前工作目录设置为 ${`B <https://docs.yoctoproject.org/ref-manual/variables.html#term-B>`_}，即编译目录。do_install 任务以及其他直接或间接依赖已安装文件的任务（例如 `do_package <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-package>`_ 、`do_package_write_* <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-package-write-deb>`_ 和 `do_rootfs <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-rootfs>`_ ）在 `fakeroot <https://docs.yoctoproject.org/overview-manual/concepts.html#fakeroot-and-pseudo>`_ 下运行。

.. Note::

    在安装文件时，请小心不要将安装文件的所有者和组ID设置为意外的值。某些复制文件的方法（特别是在使用递归cp命令时）可以保留原始文件的UID和/或GID，这通常不是您想要的。主机用户污染的QA检查会检查可能具有错误所有权的文件。

    安全的文件安装方法包括以下几种：

    * 使用install工具。这是首选的方法。

    * 使用cp命令并加上--no-preserve=ownership选项。

    * 使用tar命令并加上--no-same-owner选项。可以参考 `Source Directory <https://docs.yoctoproject.org/ref-manual/terms.html#term-Source-Directory>`_ 中的meta/classes-recipe子目录下的bin_package.bbclass文件作为示例。



6.1.11 do_install_ptest_base
-----------------------------

将运行时测试套件文件从编译目录复制到一个临时区域。

6.1.12 do_package
------------------

分析临时区域 ${`D <https://docs.yoctoproject.org/ref-manual/variables.html#term-D>`_} 的内容，并根据可用的软件包和文件将内容分割成子集。该任务利用了 `PACKAGES <https://docs.yoctoproject.org/ref-manual/variables.html#term-PACKAGES>`_ 和 `FILES <https://docs.yoctoproject.org/ref-manual/variables.html#term-FILES>`_ 变量。

do_package 任务与 `do_packagedata <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-packagedata>`_ 任务一起，还会保存一些重要的软件包元数据。有关额外信息，请参阅Yocto项目概述和概念手册中的 `PKGDESTWORK <https://docs.yoctoproject.org/ref-manual/variables.html#term-PKGDESTWORK>`_ 变量和 `“自动添加的运行时依赖项” <https://docs.yoctoproject.org/overview-manual/concepts.html#automatically-added-runtime-dependencies>`_ 章节。

6.1.13 do_package_qa
---------------------

对打包的文件运行 QA 检查。有关这些检查的更多信息，请参阅insane类。

6.1.14 do_package_write_deb
----------------------------

创建 Debian 软件包（即 *.deb 文件），并将它们放置在软件包源区域的 ${`DEPLOY_DIR_DEB <https://docs.yoctoproject.org/ref-manual/variables.html#term-DEPLOY_DIR_DEB>`_} 目录中。有关更多信息，请参阅Yocto项目概述和概念手册中的 `“软件包源” <https://docs.yoctoproject.org/overview-manual/concepts.html#package-feeds>`_ 章节。

6.1.15 do_package_write_ipk
----------------------------

创建 IPK 软件包（即 *.ipk 文件），并将它们放置在软件包源区域的 ${`DEPLOY_DIR_IPK <https://docs.yoctoproject.org/ref-manual/variables.html#term-DEPLOY_DIR_IPK>`_} 目录中。有关更多信息，请参阅Yocto项目概述和概念手册中的 `“软件包源” <https://docs.yoctoproject.org/overview-manual/concepts.html#package-feeds>`_ 章节。

6.1.16 do_package_write_rpm
----------------------------

创建 RPM 软件包（即 *.rpm 文件），并将它们放置在软件包源区域的 ${`DEPLOY_DIR_RPM <https://docs.yoctoproject.org/ref-manual/variables.html#term-DEPLOY_DIR_RPM>`_} 目录中。有关更多信息，请参阅Yocto项目概述和概念手册中的 `“软件包源” <https://docs.yoctoproject.org/overview-manual/concepts.html#package-feeds>`_ 章节。

6.1.17 do_packagedata
----------------------

将由 `do_package <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-package>`_ 任务生成的软件包元数据保存在 `PKGDATA_DIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-PKGDATA_DIR>`_ 中，以便全局使用。

6.1.18 do_patch
----------------

定位修补程序文件并将其应用于源代码。

在获取和解包源文件后，构建系统使用配方的 `SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 语句来定位补丁文件并将其应用于源代码。

.. note::

    在搜索修补程序时，生成系统使用 `FILESPATH <https://docs.yoctoproject.org/ref-manual/variables.html#term-FILESPATH>`_ 变量来确定默认目录集。

默认情况下，补丁文件是创建的*.Patch和*.diff文件，并保存在保存配方文件的目录的子目录中。例如，考虑OE核心层的 `bluez5 <https://git.yoctoproject.org/poky/tree/meta/recipes-connectivity/bluez5>`_ 配方（即poky/meta）：

::

    poky/meta/recipes-connectivity/bluez5

此配方有两个补丁文件位于此处：

::

    poky/meta/recipes-connectivity/bluez5/bluez5

在 bluez5 配方中，`SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 语句指向构建包所需的源文件和补丁文件。

.. note::

     在bluez5_5.48.bb配方的情况下，`SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 语句来自包含文件bluez5.inc。

如前所述，构建系统将文件类型为.patch和.diff的文件视为补丁文件。但是，您可以将“apply=yes”参数与 `SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 语句一起使用，以将任何文件指示为修补文件：

::

    SRC_URI = " \
    git://path_to_repo/some_package \
    file://file;apply=yes \
    "

相反，如果您有一个文件类型为.patch或.diff的文件，并且您希望将其排除在外，以便do_patch任务在修补阶段不应用它，则可以在 `SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 语句中使用“apply=no”参数：

::

    SRC_URI = " \
    git://path_to_repo/some_package \
    file://file1.patch \
    file://file2.patch;apply=no \
    "

在前面的示例中，file1.patch默认情况下会作为修补程序应用，而file2.patch则不会应用。

您可以在Yocto项目概述和概念手册的 `“修补” <https://docs.yoctoproject.org/overview-manual/concepts.html#patching>`_ 部分和Yocto开发任务手册的 `“补丁代码” <https://docs.yoctoproject.org/dev-manual/new-recipe.html#patching-code>`_ 部分了解更多关于修补过程的信息。

6.1.19 do_populate_lic
-----------------------

写入配方的许可证信息，该信息稍后在构建镜像时收集。

6.1.20 do_populate_sdk
-----------------------

为可安装的SDK创建文件和目录结构。有关更多信息，请参阅Yocto项目概述和概念手册中的 `“SDK生成” <https://docs.yoctoproject.org/overview-manual/concepts.html#sdk-generation>`_ 部分。

6.1.21 do_populate_sdk_ext
---------------------------

为可安装的可扩展SDK（eSDK）创建文件和目录结构。有关更多信息，请参阅Yocto项目概述和概念手册中的 `“SDK生成” <https://docs.yoctoproject.org/overview-manual/concepts.html#sdk-generation>`_ 部分。

6.1.22 do_populate_sysroot
---------------------------

将do_install任务安装的文件的子集暂存（复制）到相应的sysroot中。有关如何从其他配方访问这些文件的信息，请参阅 `STAGING_DIR* <https://docs.yoctoproject.org/ref-manual/variables.html#term-STAGING_DIR_HOST>`_ 变量。默认情况下，不会复制其他配方在构建时通常不需要的目录（例如/etc）。

有关默认情况下复制哪些目录的信息，请参阅 `SYSROOT_DIRS* <https://docs.yoctoproject.org/ref-manual/variables.html#term-SYSROOT_DIRS>`_ 变量。如果您需要在构建时为其他配方提供额外（或更少）的目录，您可以在配方中更改这些变量。

do_populate_sysroot任务是一个共享状态（sstate）任务，这意味着可以通过使用sstate来加速任务。还要意识到，如果任务被重新执行，任何以前的输出都会被删除（即“清除”）。

6.1.23 do_prepare_recipe_sysroot
---------------------------------

将文件安装到各个配方特定的系统根中（即配方系统根和基于 `DEPENDS <https://docs.yoctoproject.org/ref-manual/variables.html#term-DEPENDS>`_ 指定的依赖项的${`WORKDIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-WORKDIR>`_}下的本机配方系统根）。有关详细信息，请参阅 `“暂存” <https://docs.yoctoproject.org/ref-manual/classes.html#ref-classes-staging>`_ 类。

6.1.24 do_rm_work
------------------

在OpenEmbedded生成系统使用完工作文件后删除这些文件。您可以通过查看 `“rm_work” <https://docs.yoctoproject.org/ref-manual/classes.html#ref-classes-rm-work>`_ 部分了解更多信息。

6.1.25 do_unpack
-----------------

将源代码解压缩到${`WORKDIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-WORKDIR>`_}指向的工作目录中。S变量也在解包的源文件最终驻留的位置中发挥作用。有关如何解包源文件的更多信息，请参阅Yocto项目概述和概念手册中的 `“源获取” <https://docs.yoctoproject.org/overview-manual/concepts.html#source-fetching>`_ 部分，也请参阅 `WORKDIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-WORKDIR>`_ 和 `S <https://docs.yoctoproject.org/ref-manual/variables.html#term-S>`_ 变量描述。

6.2 手动调用的任务
=================

这些任务通常是手动触发的（例如，通过使用bitbake-c命令行选项）：

6.2.1 do_checkuri
------------------

验证 `SRC_URI <https://docs.yoctoproject.org/ref-manual/variables.html#term-SRC_URI>`_ 值。

6.2.2 do_clean
---------------

从do_unpack任务中删除目标的所有输出文件（即 do_unpack、do_configure、do_compile、do_install 和 do_package）。

您可以使用BitBake运行此任务，如下所示：

::

    $ bitbake -c clean recipe

运行此任务不会删除 `sstate <https://docs.yoctoproject.org/overview-manual/concepts.html#shared-state-cache>`_ 缓存文件。因此，如果未进行任何更改，并且在清理后重建配方，则输出文件只需从sstate缓存中恢复即可。如果要删除配方的sstate缓存文件，则需要改用do_cleansstate任务（即bitbake -c cleansstate配方）。

6.2.3 do_cleanall
------------------

删除目标的所有输出文件、共享状态 （ `sstate <https://docs.yoctoproject.org/overview-manual/concepts.html#shared-state-cache>`_ ） 缓存和下载的源文件（即 `DL_DIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-DL_DIR>`_ 的内容）。从本质上讲，do_cleanall任务与do_cleansstate任务相同，只是增加了对下载源文件的删除。

您可以使用BitBake运行此任务，如下所示：

::

    $ bitbake -c cleanall recipe

在正常情况下，切勿使用do_cleanall任务。如果要重新开始do_fetch任务，请改用：

::

    $ bitbake -f -c fetch recipe

.. note::

    首选bitbake -f -c fetch的原因是do_cleanall任务在某些情况下会中断，例如：
    ::
        $ bitbake -c fetch    recipe
        $ bitbake -c cleanall recipe-native
        $ bitbake -c unpack   recipe
    因为在第一步之后，针对recipe的do_fetch任务会有一个stamp文件，而在第二步时它不会被移除，因为第二步使用了不同的工作目录。所以第三步中的解压任务将尝试提取已下载的压缩包，但由于它在第二步中被删除了，因此会失败。

    请注意，当设置了共享下载目录（ `DL_DIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-DL_DIR>`_ ）时，这也适用于并发进程中的BitBake。

6.2.4 do_cleansstate
---------------------

移除目标的所有输出文件和共享状态（ `sstate <https://docs.yoctoproject.org/overview-manual/concepts.html#shared-state-cache>`_ ）缓存。本质上，do_cleansstate任务与do_clean任务相同，但额外包含了对共享状态（ `sstate <https://docs.yoctoproject.org/overview-manual/concepts.html#shared-state-cache>`_ ）缓存的移除。

您可以使用BitBake运行此任务，如下所示：

::

    $ bitbake -c cleansstate recipe

当你运行do_cleansstate任务时，OpenEmbedded构建系统将不再使用任何sstate。因此，从头开始构建recipe是有保障的。

.. note::

    使用共享的 `SSTATE_DIR <https://docs.yoctoproject.org/ref-manual/variables.html#term-SSTATE_DIR>`_ 运行do_cleansstate并不推荐，因为这可能会在构建另一个BitBake实例时触发错误。这是因为构建会提前检查sstate，但稍后才会下载文件，如果在这段时间内被删除，将会导致错误而不是完全失败，因为它会重新构建它。

    强制进行新构建的可靠且首选的方法是使用bitbake -f。

.. note::

    do_cleansstate任务无法从远程sstate镜像中移除sstate。如果你需要使用远程镜像从头构建目标，请按照以下方式使用“-f”选项：
    ::
        $ bitbake -f -c do_cleansstate target

6.2.5 do_pydevshell
--------------------

启动一个shell，在该shell中，交互式Python解释器允许你与BitBake构建环境进行交互。在此shell内，你可以直接从数据存储中检查和设置位，并像在BitBake环境中一样执行函数。有关使用pydevshell的更多信息，请参阅Yocto项目开发任务手册中的 `“使用Python开发Shell” <https://docs.yoctoproject.org/dev-manual/python-development-shell.html#using-a-python-development-shell>`_ 部分。

6.2.6 do_devshell
------------------

启动一个环境设置用于开发、调试或两者兼有的shell。有关使用devshell的更多信息，请参阅Yocto项目开发任务手册中的 `“使用开发Shell” <https://docs.yoctoproject.org/dev-manual/development-shell.html#using-a-development-shell>`_ 部分。

6.2.7 do_listtasks
-------------------

列出目标的所有已定义任务。

6.2.8 do_package_index
-----------------------

创建或更新 `Package Feeds <https://docs.yoctoproject.org/overview-manual/concepts.html#package-feeds>`_ 区域中的索引。

.. note::

    这个任务不会像本节中的其他任务那样使用bitbake -c命令行选项触发。因为这个任务是专门针对package-index配方的，所以你需要使用bitbake package-index来运行它。

6.3 镜像相关任务
===============

以下任务适用于镜像配方。

6.3.1 do_bootimg
-----------------

创建可启动的实时镜像。有关现场镜像类型的额外信息，请参阅 `IMAGE_FSTYPES <https://docs.yoctoproject.org/ref-manual/variables.html#term-IMAGE_FSTYPES>`_ 变量。

6.3.2 do_bundle_initramfs
--------------------------

将 `Initramfs <https://docs.yoctoproject.org/ref-manual/terms.html#term-Initramfs>`_ 镜像和内核组合在一起以形成单个镜像。

6.3.3 do_rootfs
----------------

为镜像创建根文件系统（文件和目录结构）。有关如何创建根文件系统的更多信息，请参阅Yocto项目概述和概念手册中的 `“镜像生成” <https://docs.yoctoproject.org/overview-manual/concepts.html#image-generation>`_ 部分。

6.3.4 do_testimage
-------------------

启动镜像并在镜像中执行运行时测试。有关自动测试镜像的信息，请参阅Yocto项目开发任务手册中的 `“执行自动运行时测试” <https://docs.yoctoproject.org/dev-manual/runtime-testing.html#performing-automated-runtime-testing>`_ 部分。

6.3.5 do_testimage_auto
------------------------

启动镜像，并在生成镜像后立即在镜像中执行运行时测试。当您将 `TESTIMAGE_AUTO <https://docs.yoctoproject.org/ref-manual/variables.html#term-TESTIMAGE_AUTO>`_ 设置为等于“1”时，将启用此任务。

有关自动测试镜像的信息，请参阅《Yocto 项目开发任务手册》中的 `“执行自动运行时测试” <https://docs.yoctoproject.org/dev-manual/runtime-testing.html#performing-automated-runtime-testing>`_ 部分。

6.4 内核相关任务
===============

以下任务适用于内核配方。其中一些任务（例如 `do_menuconfig <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-menuconfig>`_ 任务）也适用于使用Linux内核样式配置的配方，例如BusyBox配方。

6.4.1 do_compile_kernelmodules
-------------------------------

运行生成内核模块的步骤（如果需要）。构建内核包括两个步骤：1）构建内核（vmlinux），2）构建模块（即make modules）。

6.4.2 do_diffconfig
--------------------

当用户调用时，此任务会创建一个文件，其中包含由 `do_kernel_configme <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-kernel-configme>`_ 任务生成的原始配置与用户使用其他方法（即使用 （ `do_kernel_menuconfig <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-kernel-menuconfig>`_ ）所做的更改之间的差异。创建差异文件后，它可用于创建仅包含差异的配置片段。您可以从命令行调用此任务，如下所示：

::

    $ bitbake linux-yocto -c diffconfig

有关更多信息，请参阅Yocto项目Linux内核开发手册中的 `“创建配置片段” <https://docs.yoctoproject.org/kernel-dev/common.html#creating-configuration-fragments>`_ 部分。

6.4.3 do_kernel_checkout
-------------------------

将新解压的内核源代码转换为OpenEmbedded构建系统可以处理的形式。由于可以通过几种不同的方式来获取内核源代码，do_kernel_checkout任务确保后续任务获得的是内核的干净工作树副本，并且已经检出了正确的分支。

6.4.4 do_kernel_configcheck
----------------------------

验证do_kernel_menuconfig任务生成的配置。当请求的配置未显示在最终 .config 文件中时，或者当您覆盖硬件配置片段中的策略配置时，do_kernel_configcheck任务将生成警告。您可以使用以下命令显式运行此任务并查看输出：

::

    $ bitbake linux-yocto -c kernel_configcheck -f

有关详细信息，请参阅Yocto项目Linux内核开发手册中的 `“验证配置” <https://docs.yoctoproject.org/kernel-dev/common.html#validating-configuration>`_ 部分。

6.4.5 do_kernel_configme
-------------------------

在内核通过do_patch任务打补丁之后，do_kernel_configme任务将组装并合并所有内核配置片段成为一个合并后的配置，然后可以传递给适当的内核配置阶段。这也是应用用户指定的defconfigs（如果存在）的时候，以及应用如--allnoconfig这样的配置模式的时候。

6.4.6 do_kernel_menuconfig
---------------------------

由用户调用以操作用于构建linux-yocto配方.config的文件。此任务将启动Linux内核配置工具，然后您可以使用该工具修改内核配置。

.. Note::

    您还可以从命令行调用此工具，如下所示：
    ::
        $ bitbake linux-yocto -c menuconfig

有关此配置工具的更多信息，请参阅Yocto Project Linux内核开发手册中的 `“使用menuconfig” <https://docs.yoctoproject.org/kernel-dev/common.html#using-menuconfig>`_ 部分。

6.4.7 do_kernel_metadata
-------------------------

收集给定内核构建所需的所有特性，无论这些特性是来自SRC_URI还是来自Git仓库。收集之后，do_kernel_metadata任务会处理这些特性，生成一系列的配置片段和补丁，然后可以由后续的任务如do_patch和do_kernel_configme应用。

6.4.8 do_menuconfig
--------------------

为内核运行make menuconfig。有关menuconfig的信息，请参阅Yocto项目Linux内核开发手册中的 `“使用menuconfig” <https://docs.yoctoproject.org/kernel-dev/common.html#using-menuconfig>`_ 部分。

6.4.9 do_savedefconfig
-----------------------

当用户调用时，创建一个可以替代默认defconfig的defconfig文件。保存的defconfig包含默认defconfig和用户使用其他方法（即do_kernel_menuconfig任务）所做的更改之间的差异。您可以使用以下命令调用此任务：

::

    $ bitbake linux-yocto -c savedefconfig

6.4.10 do_shared_workdir
-------------------------

在内核编译完成但内核模块尚未编译之前，此任务将复制构建模块所需的文件以及从内核生成的文件到共享工作目录中。成功复制这些文件后，`do_compile_kernelmodules <https://docs.yoctoproject.org/ref-manual/tasks.html#ref-tasks-compile-kernelmodules>`_ 任务可以在构建的下一步成功构建内核模块。

6.4.11 do_sizecheck
--------------------

在内核构建完成后，此任务会检查去除符号的内核镜像的大小是否超过了 `KERNEL_IMAGE_MAXSIZE <https://docs.yoctoproject.org/ref-manual/variables.html#term-KERNEL_IMAGE_MAXSIZE>`_ 。如果设置了该变量，并且去除符号的内核大小超过该值，内核构建会产生相应的警告。

6.4.12 do_strip
-----------------

如果定义了KERNEL_IMAGE_STRIP_EXTRA_SECTIONS变量，则此任务将从vmlinux中删除该变量中指定的部分。这种剥离通常用于从大小敏感的配置中删除非必要的部分，例如.comment部分。

6.4.13 do_validate_branches
----------------------------

在内核解压缩但未打补丁之前，此任务确保由SRCREV变量指定的机器和元数据分支实际上存在于指定的分支上。否则，如果未使用 `AUTOREV <https://docs.yoctoproject.org/ref-manual/variables.html#term-AUTOREV>`_ ，则do_validate_branches任务将在构建期间失败。
