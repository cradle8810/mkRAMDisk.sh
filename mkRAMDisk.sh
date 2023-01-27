#!/bin/sh

RDIR=/Volumes/RAMDisk
VOLNAME="RAMDisk"

#RAMDiskがマウントされている場合は処理を中止
if [ -e "${RDIR}" ]; then
 echo 'It has already RAMDisk directory exist.'
 exit 1
fi

while [ ! -e /Volumes ]
do
  echo 'Waiting for mounting /Volumes directory'
  sleep 2
done

if [ ! -e ${RDIR} ]; then
  #1Block=512Bytes. 1MiB=2048Blocks.
  # 1300MiB
  # RAMDisk領域の確保。DISKBLOCKは確保した領域のデバイススペシャルファイルのパス
  # を返す 例えば"/dev/disk2"
  DISKBLOCK=$(hdiutil attach -nomount ram://2662400 | awk '{print $1}')

  sleep 1

  # APFS形式でフォーマットする。DEVICENAMEは新規に作成されたAPFSフォーマットの
  # デバイススペシャルファイル名を返す 例えば"disk2s1"
  DEVICENAME=$(diskutil partitionDisk "${DISKBLOCK}" 1 GPT APFS "${VOLNAME}" "100%" | \
		   grep "Formatting" | \
		   awk '{print $2}' )

  #RAMDiskがマウントされていない場合、明示的にマウントする
  mountRDir="$(mount | grep "${DEVICENAME}")"
  if [ "${mountRDir}" ]; then
      mount "${mountRDir}" "${RDIR}"
  fi

  ##################
  # フォルダの作成   #
  ##################
  if [ ! -d ${RDIR} ]; then
      echo "No RAMDisk Found."
      exit 3
  fi

  #ログ
  mkdir "${RDIR}/.logs"
  chmod 777 "${RDIR}/.logs"

  #Xcodeのキャッシュ
  mkdir "${RDIR}/.XCODEDebug/"

  # ${TMPDIR}
  ## ※ Safariのブックマークが変更されない(ロールバックする)不具合が発生するようになったので、
  ##    もはや${TMPDIR}はRAMDiskに移動すべきではない
  #TMPDIR_PATH="/var/folders/15/42q15pbs2759839xh2xrlcr80000gn"
  mkdir "${RDIR}/.tmpdirT"
  chmod 777 "${RDIR}/.tmpdirT"

  # /tmp用
  mkdir "${RDIR}/.tmp"

  # Saved Application State
  mkdir "${RDIR}/.Saved Application State"
  chmod 777 "${RDIR}/.Saved Application State"

  #Spotlight Token
  mkdir "${RDIR}/.SpotlightToken"

  #######################
  # Application Caches  #
  #######################
  CACHEDIR="${RDIR}/.cache"

  #iCloud Photo?
  mkdir -p "${CACHEDIR}/com.apple.iLifeMediaBrowser.ILPhotosTranscodeCache"

  #QuickLook
  mkdir -p "${CACHEDIR}/QuickLook"
  mkdir -p "${CACHEDIR}/QuickLook32"
  mkdir -p "${CACHEDIR}/qlmanage"

  chmod 777 "${CACHEDIR}/QuickLook"
  chmod 777 "${CACHEDIR}/QuickLook32"
  chmod 777 "${CACHEDIR}/qlmanage"

  #iconservices
  mkdir "${CACHEDIR}/com.apple.iconservices"

  #nsurlsessiond
  mkdir "${CACHEDIR}/com.apple.nsurlsessiond"

  #Appstore
  mkdir -p "${CACHEDIR}/com.apple.appstore"

  #RDP
  mkdir -p "${CACHEDIR}/Microsoft Remote Desktop Beta"

  #Photo
  mkdir -p "${CACHEDIR}/com.apple.Photos"
  mkdir -p "${CACHEDIR}/Photos"
  mkdir -p "${CACHEDIR}/Photos_Cache.noindex"

  #Safari
  mkdir -p "${CACHEDIR}/Metadata"
  mkdir -p "${CACHEDIR}/com.apple.safari"
  mkdir -p "${CACHEDIR}/Safari_CloudKit"
  mkdir -p "${CACHEDIR}/Safari"

  #Apps
  mkdir -p "${CACHEDIR}/Finder"
  mkdir -p "${CACHEDIR}/fsCachedData"
  mkdir -p "${CACHEDIR}/com.apple.Automator"

  #Chrome
  mkdir -p "${CACHEDIR}/Chrome"
  mkdir -p "${CACHEDIR}/Chrome/Sync Data"
  mkdir -p "${CACHEDIR}/Chrome/Session Storage"
  mkdir -p "${CACHEDIR}/Chrome/blob_storage"

  #Firefox
  mkdir -p "${CACHEDIR}/Firefox"

  #iMazing
  mkdir -p "${CACHEDIR}/iMazing"

  #HomeBrew
  mkdir -p "${CACHEDIR}/Homebrew"

  #Autosave
  mkdir -p "${CACHEDIR}/Autosave Information"

  #lsd
  mkdir -p "${CACHEDIR}/lsd"

  #Photosweeper
  mkdir -p "${CACHEDIR}/com.overmacs.photosweeperpaddle"

  #Evernote
  mkdir -p "${CACHEDIR}/com.evernote.Evernote"

  # Docker Desktop for Mac
  mkdir -p "${RDIR}/.logs/docker/log"

  # Discord for Mac
  mkdir -p "${CACHEDIR}/discord/Cache"

  # Ansible cache
  mkdir -p "${CACHEDIR}/ansible/cp"
  mkdir -p "${CACHEDIR}/ansible/tmp"
fi


#Clean if old Ramdisk area exist.
CURRENTAREA=$(mount|grep RAMDisk| grep -v RAMDisk1|awk '{print $1}'|sed -e "s:/dev/::g")
KILLAREA=$(diskutil list|grep RAMDisk| grep -v "${CURRENTAREA}"|awk '{print $5}')

#Kill oldarea from diskutil
echo "$KILLAREA"
if [ -n "${KILLAREA}" ]; then
    if [ -e "/dev/${KILLAREA}" ]; then
	echo "Try to eject ${KILLAREA}"
	diskutil eject "/dev/${KILLAREA}"
    fi
fi

if [ -e '/Volumes/RAMDisk 1' ]; then
    diskutil eject "$(mount |grep "RAMDisk 1"|awk '{print $1}')"
fi
