#!/usr/bin/python3

import re, fnmatch, os, sys, mmap, struct

if __name__ == '__main__':

    name = sys.argv[2].encode('ascii')

    if sys.argv[3].upper().startswith('0X'):
        value = int(sys.argv[3], 16)
    else:
        value = int(sys.argv[3])

    fmap = mmap.mmap(os.open(sys.argv[1], os.O_RDWR), 0)

    offset = fmap.find(name)
    # print('%s:%d\n' % (sys.argv[2], offset))

    if offset < 0:
        print('error finding ms_bin_option:%s in %s\n' %
              (sys.argv[2], sys.argv[1]))
    else:
        print('offset:0x%08X value:0x%08X' % (offset, value))

        fmap.seek(offset + 8, os.SEEK_SET)
        fmap.write(struct.pack('<I', value))

    fmap.close()
