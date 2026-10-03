## How to build kernel
In order to run the customized kernel, you need flash spi flash using this file (https://github.com/steward-fu/website/releases/download/miyoo-mini-flip/spi_uboot_load_uimage.bin)
```
$ cd
$ wget https://github.com/steward-fu/website/releases/download/miyoo-mini-flip/ssd202d_toolchain.tar.gz
$ tar xvf ssd202d_toolchain.tar.gz
$ sudo mv ssd202d /opt
$ export PATH=/opt/ssd202d/bin:$PATH

$ cd kernel
$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make distclean
$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make mmf_defconfig
$ vim scripts/dtc/dtc-lexer.lex.c +640
    extern YYLTYPE yylloc;

$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- LOADADDR=0x22000000 make uImage modules -j4
```

## How to flash uImage into MicroSD
```
sudo dd if=arch/arm/boot/uImage of=/dev/sdX bs=1024 seek=400
sudo dd if=arch/arm/boot/dts/mmf.dtb of=/dev/sdX bs=1024 seek=300
```

## How to build buildroot
```
$ cd buildroot
$ make mmf_defconfig
```

## How to build mininit
```
$ cd mininit
$ make
```
