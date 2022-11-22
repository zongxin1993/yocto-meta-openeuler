# make ros libs compatible with lib64
do_configure:prepend:class-target() {
    if [[ "${libdir}" =~ "lib64" ]]; then
        cat ${S}/rosidl_generator_cpp-extras.cmake.in | grep "lib64/rosidl_" || sed -i 's:lib/rosidl_:lib64/rosidl_:g' ${S}/rosidl_generator_cpp-extras.cmake.in
    fi
}

