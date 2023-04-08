SUMMARY = "Docker recipe"
DESCRIPTION = "	Deploy docker recipe"
LICENSE = "CLOSED"

SRC_URI = "file://mount_cgroup.sh \
		  file://docker_deploy.sh \
		  file://net_config.sh \
		  file://daemon.json \
		  file://alpine \
		  file://docker_pkg_deb \
         "
		
do_install()  { 

  install -d ${D}${datadir}/docker 
 
  install -m 0755 ${WORKDIR}/mount_cgroup.sh  ${D}${datadir}/docker/
  install -m 0755 ${WORKDIR}/docker_deploy.sh  ${D}${datadir}/docker/
  install -m 0755 ${WORKDIR}/net_config.sh ${D}${datadir}/docker/
  install -m 0755 ${WORKDIR}/daemon.json  ${D}${datadir}/docker/
  
  cp -rvf ${WORKDIR}/docker_pkg_deb  ${D}${datadir}/docker/docker-v20.10.2-dev_riscv64.deb
  cp -rvf ${WORKDIR}/alpine ${D}${datadir}/docker/alpine.tar

}

FILES:${PN} += " ${datadir}/docker"
