def get_kernelversion_headers(p):
    import re

    fn = p + '/include/linux/utsrelease.h'
    if not os.path.isfile(fn):
        # after 2.6.33-rc1
        fn = p + '/include/generated/utsrelease.h'
    if not os.path.isfile(fn):
        fn = p + '/include/linux/version.h'

    try:
        f = open(fn, 'r')
    except IOError:
        return None

    l = f.readlines()
    f.close()
    r = re.compile("#define UTS_RELEASE \"(.*)\"")
    for s in l:
        m = r.match(s)
        if m:
            return m.group(1).replace("+", "")
    return None
