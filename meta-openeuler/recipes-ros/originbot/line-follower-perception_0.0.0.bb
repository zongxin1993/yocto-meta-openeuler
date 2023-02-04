# originbot-v1.0.2/originbot_deeplearning/line_follower_perception/line-follower-perception_0.0.0.bb 
#
# Generated by ros2recipe.py
#
# Copyright openeuler

inherit ros_distro_foxy
inherit ros_superflore_generated

DESCRIPTION = "TODO: Package description"
AUTHOR = "kairui"
SECTION = "devel"
LICENSE = "Apache-License-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=8;endline=8;md5=12c26a18c7f493fdc7e8a93b16b7c04f"

ROS_CN = ""
PV = "0.0.0"
ROS_BPN = "line-follower-perception"

ROS_BUILD_DEPENDS = " \
    ai-msgs \
    dnn-node \
    geometry-msgs \
    hbm-img-msgs \
    rclcpp \
    std-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = ""

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = ""

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

OPENEULER_REPO_NAME = "yocto-embedded-tools"
OPENEULER_LOCAL_NAME = "ros-dev-tools"
OPENEULER_BRANCH = "dev_ros"
OPENEULER_GIT_SPACE = "openeuler"

SRC_URI = " \
    file://${OPENEULER_LOCAL_NAME}/ros_depends/originbot/v1.0.2.tar.gz \
"

S = "${WORKDIR}/originbot-v1.0.2/originbot_deeplearning/line_follower_perception"
ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

