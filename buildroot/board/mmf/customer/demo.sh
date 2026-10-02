insmod /config/modules/4.9.84/mhal.ko
insmod /config/modules/4.9.84/mi_common.ko

major=`cat /proc/devices | busybox awk "\\$2==\""mi"\" {print \\$1}"\n`
minor=0

insmod /config/modules/4.9.84/mi_sys.ko cmdQBufSize=128 logBufSize=0
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_sys c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_gfx.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_gfx c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_divp.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_divp c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_vdec.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_vdec c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_ao.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_ao c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_disp.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_disp c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_ipu.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_ipu c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_ai.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_ai c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_venc.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_venc c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_panel.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_panel c $major $minor
	let minor++
fi

insmod /config/modules/4.9.84/mi_alsa.ko
if [ $? -eq 0 ]; then
	busybox mknod /dev/mi_alsa c $major $minor
	let minor++
fi

major=`cat /proc/devices | busybox awk "\\$2==\""mi_poll"\" {print \\$1}"`
busybox mknod /dev/mi_poll c $major 0
insmod /config/modules/4.9.84/fbdev.ko
mdev -s

export TERM=vt102
export TERMINFO=/config/terminfo
#/customer/main &
