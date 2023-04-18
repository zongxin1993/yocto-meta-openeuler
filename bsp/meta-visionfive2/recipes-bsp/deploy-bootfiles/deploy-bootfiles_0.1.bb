SUMMARY = "Deploy Boot files recipe"
DESCRIPTION = "Recipe to deploy boot files to the deploy directory"
LICENSE = "CLOSED"

LIC_FILES_CHKSUM = ""

SRC_URI = "file://bootcode.bin \
           file://bootjump.bin \
           file://uEnv.txt \
          "
          
S = "${WORKDIR}"

inherit deploy
do_deploy(){
	install -m 755 ${WORKDIR}/bootcode.bin ${DEPLOYDIR}/
	install -m 755 ${WORKDIR}/bootjump.bin ${DEPLOYDIR}/
    install -m 755 ${WORKDIR}/uEnv.txt ${DEPLOYDIR}/
}

addtask deploy before do_build after do_install
