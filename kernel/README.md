## Steps
1. Toolchain
```
$ cd
$ wget https://github.com/steward-fu/website/releases/download/miyoo-mini-flip/ssd202d_toolchain.tar.gz
$ tar xvf ssd202d_toolchain.tar.gz
$ sudo mv ssd202d /opt
```

2. Flash SPI (https://github.com/steward-fu/website/releases/download/miyoo-mini-flip/spi_uboot_load_uimage.bin)
```
bootargs=
bootcmd=gpio output 73 1;sleepms 50;gpio output 73 0;sleepms 150;gpio output 73 1;sleepms 200;gpio output 85 1;bootlogo 0 0 0 0 0;mw 1f001cc0 11;gpio out 8 0;mmc dev 0;mmc read 0x22000000 0x320 0x4000;mmc read 0x23000000 0x258 0x80;bootm 0x22000000 - 0x23000000
```

3. Build Kernel  
```
$ export PATH=/opt/ssd202d/bin:$PATH

$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make distclean
$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make mmf_defconfig
$ vim scripts/dtc/dtc-lexer.lex.c +640
    extern YYLTYPE yylloc;

$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- LOADADDR=0x22000000 make uImage modules -j4
```

4. Flash into MicroSD
```
sudo dd if=arch/arm/boot/uImage of=$1 bs=1024 seek=400
sudo dd if=arch/arm/boot/dts/mmf.dtb of=$1 bs=1024 seek=300
```
