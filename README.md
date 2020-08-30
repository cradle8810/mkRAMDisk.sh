# mkRAMDisk.sh
This shell script creates a RAMDisk (a disk on main-memory.)

## How to use
This repository contains two files. The one is mkRAMDisk.sh creating a RAMDisk, and the other is the config file for the launchctl(1) plist file.

There is an instruction to install. 
  1. Place mkRAMDisk.sh where you want. 
  2. Add "execute flag" using chmod(1). like:
   ``` $ chmod +x mkRAMDisk.sh ``` 
  3. Replace "ProgramArguments" value with your mkRAMDisk.sh path on com.user.mkramdisk.plist.
  4. Place com.user.mkramdisk.plist to /Library/LaunchDaemons/ . It might need root privilege. Use cp(1) with sudo(8).
   ``` $ sudo cp com.user.mkramdisk.plist /Library/LaunchDaemons/ ``` 
  5. Activate your com.user.mkramdisk.plist daemon following command:
   ``` $ launchctl load -w /Library/LaunchDaemons/com.user.mkramdisk.plist ```

