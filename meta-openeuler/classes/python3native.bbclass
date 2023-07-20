# openeuler's python3native.bbclass requires meta/classes/python3native.bbclass. 
# And make some adaptations, the reason is:
# openeuler use python3 from nativesdk tool, not python3-native

require ${COREBASE}/meta/classes/python3native.bbclass

PYTHON="${OPENEULER_NATIVESDK_SYSROOT}/usr/bin/python3"
EXTRANATIVEPATH:remove = "python3-native"
DEPENDS:remove = "python3-native"

