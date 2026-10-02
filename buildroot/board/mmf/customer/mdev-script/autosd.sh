#!/bin/sh

MNT_PATH=/mnt

SD1_DIR=SDCARD
MNT_DIR=$SD1_DIR


my_umount()
{
	FOLDER=`grep "/dev/$1" /proc/mounts | cut -d ' ' -f 2`
	if [ ! -z "$FOLDER" ]; then
		umount -l "$FOLDER";
	fi
}

my_mount()
{
	MNT_DIR=$SD1_DIR

	if [ -b /dev/$1 ]; then
		MOUNTDEV="/dev/$1"
		if [ -b "/dev/$1p1" ]; then
			MOUNTDEV="/dev/$1p1"
		fi
	fi

	time_offset_sig=`date +%z | cut -c 1`
	time_offset_h=`date +%z | cut -c 2-3`
	time_offset_m=`date +%z | cut -c 4-5`
	time_offset=`expr $local_time - $utc_time`
	if [ $time_offset_sig == + ]; then
		time_offset_sig="";
	fi
	time_offset_total_m=$time_offset_sig`expr $time_offset_h \* 60 + $time_offset_m`

        #/customer/app/fsck.vfat -a "$MOUNTDEV"
	#fat_type=`blkid "$MOUNTDEV" | awk -F'TYPE=' '{print $NF}'`
	#[ "${fat_type}" == "\"vfat\"" ] || ! [ "${fat_type}" == "\"exfat\"" ] 
    
        mount -t vfat -o iocharset=utf8,dirsync,time_offset=$time_offset_total_m "$MOUNTDEV" "${MNT_PATH}/${MNT_DIR}"
        RET="$?"
        if [ $RET != "0" ] ; then
            echo "mount fail!"
            echo "mount: mounting $MOUNTDEV on ${MNT_PATH}/${MNT_DIR} fail" >> /tmp/.mount.log
            echo "$MOUNTDEV $MNT_PATH/$MNT_DIR ignore defaults 0 0" >> /tmp/.mount.log
            exit 1
        fi
}

touch /tmp/.mount.log

if ! [ -e "${MNT_PATH}/${MNT_DIR}" ] ; then
     echo "${MNT_PATH}/${MNT_DIR} not exists" >> /tmp/.mount.log
     exit 1
fi 

if [ -z $DEVPATH ]; then
	echo autosd.sh bootstage $ACTION "$DEVPATH" >> /tmp/.mount.log

	MMCBUSPATH="/sys/bus/mmc/devices/"
	MMCDEVLIST=`ls $MMCBUSPATH`

	for n in $MMCDEVLIST
	do
		# Check if it is not SD device
		SD_TYPE=`cat $MMCBUSPATH/$n/type`
		if ! [ $SD_TYPE == SD ]; then
			continue
		fi

		# Get the block device name
		BLOCKDEV=`ls $MMCBUSPATH/$n/block`
		# Check if device is mounted
		MOUNTED=`grep $BLOCKDEV /proc/mounts`


		# Check if /dev/mmcblk* exists
		if [ -b /dev/$BLOCKDEV ]; then
			MOUNTDEV="/dev/$BLOCKDEV"
			if [ -b "/dev/${BLOCKDEV}p1" ]; then
				MOUNTDEV="/dev/${BLOCKDEV}p1"
			fi
		else
			continue
		fi

		time_offset_sig=`date +%z | cut -c 1`
		time_offset_h=`date +%z | cut -c 2-3`
		time_offset_m=`date +%z | cut -c 4-5`
		time_offset=`expr $local_time - $utc_time`
		if [ $time_offset_sig == + ]; then
			time_offset_sig="";
		fi
		time_offset_total_m=$time_offset_sig`expr $time_offset_h \* 60 + $time_offset_m`

		#fat_type=`blkid "$MOUNTDEV" | awk -F'TYPE=' '{print $NF}' | awk -F ' ' '{print $1}'`
		#[ "${fat_type}" == "\"vfat\"" ] || ! [ "${fat_type}" == "\"exfat\"" ] 

		mount -t vfat -o iocharset=utf8,dirsync,time_offset=$time_offset_total_m "$MOUNTDEV" "${MNT_PATH}/${MNT_DIR}"
		RET="$?"
		if [ $RET != "0" ] ; then
		    echo "mount fail!"
		    echo "mount: mounting $MOUNTDEV on ${MNT_PATH}/${MNT_DIR} fail" >> /tmp/.mount.log
		    echo "$MOUNTDEV $MNT_PATH/$MNT_DIR ignore defaults 0 0" >> /tmp/.mount.log
		    exit 1
		fi

	done

else
	echo autosd.sh bootedup $ACTION $MDEV , "$DEVPATH" >> /tmp/.mount.log
	# This is for booted up stage
	case "${ACTION}" in
	add|"")
		my_umount ${MDEV}
		my_mount ${MDEV}
		;;
	remove)
		my_umount ${MDEV}
		;;
	esac
fi
