#image configuration for tspi-rk3566
require rockchip.inc

IMAGE_INSTALL_append += " wpa-supplicant wireless-regdb-static"