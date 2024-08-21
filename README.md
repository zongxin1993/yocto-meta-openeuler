```
mkdir tspi && cd tspi
oebuild init buildwork -u git@github.com:zongxin1993/yocto-meta-openeuler.git -b zongxin-dev
cd buildwork && oebuild update
oebuild generate -p tspi-rk3566 -f openeuler-rt -f busybox -f systemd  -d tspi
cd build/tspi
oebuild bitbake
#oebuild bitbake执行后将进入构建交互环境
#注意您此时应该处于进入oebuild bitbkae环境的工作根目录
bitbake openeuler-image
```