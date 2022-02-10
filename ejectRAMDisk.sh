#!/bin/sh

MKRAMDISK="/Users/hayato/Scripts/mkRAMDisk.sh"
RDIR="/Volumes/RAMDisk"

if [ ! -e "${MKRAMDISK}" ]; then
   echo "No mkramdisk found." >&2
   exit 1
fi
if [ ! -e "${RDIR}" ]; then
   echo "No RAMDisk found." >&2
   exit 2
fi

DISKUTIL="diskutil info"

DEVID="$( ${DISKUTIL} ${RDIR} | grep "Device Identifier" | awk '{print $3}' )"
DEVNAME="$( ${DISKUTIL} ${RDIR} | grep "Part of Whole" | awk '{print $4}' )"


CONTAINERID=$(diskutil list | grep "Apple_APFS Container" |\
		       grep "${DEVNAME}" | awk '{print $7}')
CONTAINERDEVNAME="$( ${DISKUTIL} ${CONTAINERID} | grep "Part of Whole" | awk '{print $4}' )"

echo "RAMDisk Partition (eject 1st): ${DEVNAME}"
echo "RAMDisk Device Name: ${DEVID}"
echo "Container Partition Name: ${CONTAINERID}"
echo "Container Device Name (eject 2nd): ${CONTAINERDEVNAME}"


echo "Ejecting ${DEVNAME}..."
hdiutil detach -force ${DEVNAME}

echo "Ejecting ${CONTAINERDEVNAME}..."
hdiutil detach -force ${CONTAINERDEVNAME}
