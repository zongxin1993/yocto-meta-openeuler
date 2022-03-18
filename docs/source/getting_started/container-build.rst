openEuler容器构建指导
======================

1. 准备主机端docker工具
************************

a) 检查当前环境是否已安装docker环境
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

    docker version

b) 如果没有安装，可参考官方链接安装
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

官网地址：http://www.dockerinfo.net/document

openEuler环境可参考Centos安装Docker

.. code-block:: console

    sudo yum install docker

2. 获取容器镜像
****************

a) 从华为云pull镜像到宿主机
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

    docker pull swr.cn-north-4.myhuaweicloud.com/openeuler-embedded/rtos-openeuler-21.03:v001

3. 拉起容器构建环境（启动命令仅供参考）
*************************************

a) 启动容器
^^^^^^^^^^^^^

.. code-block:: console

    docker run -idt swr.cn-north-4.myhuaweicloud.com/openeuler-embedded/rtos-openeuler-21.03:v001 bash

b) 查看已启动的容器id
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

    docker ps

c) 进入容器
^^^^^^^^^^^^

.. code-block:: console

    docker exec -it 容器id bash

4. yocto一键式构建流程
*************************************

a) 下载代码
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

    git clone https://gitee.com/openeuler/yocto-meta-openeuler.git -b openEuler-21.09

b) bash执行scripts/download_code.sh脚本
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

    sh scripts/download_code.sh

c) bash执行scripts/compile.sh一键式构建脚本
******************************************

.. code-block:: console

    sh scripts/compile.sh

d) 获取结果件
**************

- /usr1/output

5. 目录说明
*************

a) 源码目录
^^^^^^^^^^^^
- /usr1/openeuler/src

b) 构建目录
^^^^^^^^^^^^
- /usr1/openeuler/src/build

c) 结果件目录
^^^^^^^^^^^^^^
- /usr1/output
