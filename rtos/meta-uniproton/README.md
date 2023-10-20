# UniProton 构建支持

本元构建层(meta-layer)包含了在openEuler Yocto构建环境下集成构建UniProton的相关配置和配方。

## 使用

1. 当前支持x86_64版本编译构建，构建时自动下载master分支最新代码，如需固定版本，需修改bb文件。

2. 在rtos/meta-openeuler-rtos/conf/layer.conf中添加相应的元构建层

```
 BBFILES_DYNAMIC += " \
 uniproton:${LAYERDIR}/uniproton/*.bb \
 uniproton:${LAYERDIR}/uniproton/*.bbappend \
 "
```

3. 构建UniProton.
```
    bitbake uniproton
```

UniProton构建的结果文件会安装在/lib/firmware目录，并打包成rpm文件。
