#!/bin/sh

MKRAMDISK="/Users/hayato/Scripts/mkRAMDisk.sh"
RDIR="/Volumes/RAMDisk_1"

if [ ! -e "${MKRAMDISK}" ]; then
   echo "No mkramdisk found." >&2
   exit 1
fi
if [ ! -e "${RDIR}" ]; then
   echo "No RAMDisk found." >&2
   exit 2
fi

DISKUTIL="diskutil"

# RAMDISKパーティション (ex)disk2s1
DEVID="$( ${DISKUTIL} info ${RDIR} | grep "Device Identifier" | awk '{print $3}' )"
#RAMDISKデバイス名 (ex)disk2
DEVNAME="$( ${DISKUTIL} info ${RDIR} | grep "Part of Whole" | awk '{print $4}' )"

# RAMDISKパーティションを含んでいたAPFSコンテナ
CONTAINERID=$("${DISKUTIL}" info "${DEVNAME}" | grep "APFS Physical Store" | awk '{print $4}')
# APFSコンテナを含む物理デバイス名
CONTAINERDEVNAME="$( ${DISKUTIL} info ${CONTAINERID} | grep "Part of Whole" | awk '{print $4}' )"

echo "RAMDisk Partition (eject 1st): ${DEVNAME}"
echo "RAMDisk Device Name: ${DEVID}"
echo "Container Partition Name: ${CONTAINERID}"
echo "Container Device Name (eject 2nd): ${CONTAINERDEVNAME}"


echo "Ejecting ${DEVNAME}..."
hdiutil detach -force ${DEVNAME}

echo "Ejecting ${CONTAINERDEVNAME}..."
hdiutil detach -force ${CONTAINERDEVNAME}
