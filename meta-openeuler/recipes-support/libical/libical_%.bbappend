# main bb yocto-poky/meta/recipes-support/libical/libical_3.0.16.bb

# todo: The new version has some bbclass introductions and cmake changes, not clear the usefulness, and
# improve the BB file later


SRC_URI = "\
    file://${BP}.tar.gz \
    file://libical-bugfix-timeout-found-by-fuzzer.patch \
"
