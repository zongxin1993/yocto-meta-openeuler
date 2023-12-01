 yocto-meta-openeuler

## introduce

The build tool for openEuler Embedded is based on the Yocto Poky Project. Poky is a reference distro for the Yocto Project. One of the most important concepts in the Yocto Project is the Layer Model. We can put some related recipes into the same recipe layer, simplifying the customization process. Recipes in later tiers can override recipes that already exist in tiers already added. 

yocto-meta-openeuler is a collection of build recipes for building openEuler Embedded, that is, a collection of recipe layers, as well as related build tools and development documents for openEuler Embedded. By modifying the recipe layer in yocto-meta-openeuler, such as meta-openeuler, we have implemented a large number of customization requirements for openEuler Embedded, including but not limited to:

*It shares software packages with openEuler in other scenarios and evolves together.
*Adopt pre-built toolchains and libc libraries to accelerate builds.
*Whenever possible, use pre-built host tools to speed up builds, as well as containerized builds.
*Optimize for embedded scenarios.

## Directory schema

* **scripts** : A set of auxiliary tools to help build environments, such as downloading code repositories, creating build environments, and so on
* **meta-openeuler : The Yocto layer created by building openEuler Embedded, including the corresponding configuration, build recipe, etc
* **bsp** : The BSP (Board Support Package) abstraction layer of openEuler Embedded, which contains the hardware BSPs currently supported by openEuler Embedded, such as QEMU, Raspberry Pi 4B, etc
* **RTOS** : The RTOS (Real-Time Operating System) abstraction layer of openEuler Embeddd is mainly aimed at scenarios where Linux and RTOS are mixed key deployments, and currently supports RT-Thread and Zephyr
* **docs** : openEuler Embedded usage and development documentation, CI will automatically build the documentation and publish it at the following address:

[**openEuler Embeddeddevelopment documentation**](https://openeuler.gitee.io/yocto-meta-openeuler)

## Get started quickly

Quickly build openeuler embedded using oebuild

Currently, only x86 64-bit Linux environments can be used to build openEuler Embedded. For details, please refer to the documentation:

 [**quickly build openEuler Embedded using oebuild**](https://openeuler.gitee.io/yocto-meta-openeuler/master/yocto/oebuild.html)

OEbuild will automatically git clone the repository in the src directory, and switch to the latest development branch, i.e., master, by default.

After OEbuild is built, the following directory structure will be automatically generated:

 ```
<openEuler Embedded构建顶层目录（自己创建的目录）>
├── build  实际构建目录
    ├── output  镜像输出目录
    ├── tmp  构建工作临时文件目录
├── src    openEuler Embedded所有代码包目录
```

## Get involved

1.Fork this repository

2.Create a new Feat_xxx branch (the name corresponds to the feature you want to develop). Using a separate branch for each feature has the advantage of being able to develop multiple unrelated features at the same time, without affecting each other when creating new pull requests. Reduces the complexity of code repository management.

3.Submit code to your own repository:

A good git commit is as follows, please describe the relevant information in the commit as much as possible, such as where the change was made, the reason for the change, how to verify it, etc. (The content that needs to be replaced is included in "[]", and the actual submission information does not need to include "[]")

  ```
    [module name, e.g. docs]: [git commit msg titile (what to change)]

    [git commit msg body (detailed explaination of what to change, why to change, and even how to verify)]

    Signed-off-by: [name] <[email]>
    ```

This repository uses gitlint to check every git commit, it is recommended to use gitlint to check your commits before committing to avoid CI gate check failures.

4.Create a new Pull Request, wait for the review and merge the code into this repository (you can choose to delete the branch for development after merging) 