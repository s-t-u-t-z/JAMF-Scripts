#!/bin/bash


####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#	Type: SELF SERVICE POLICY
#
#	Purpose of this script is to provide machine information to either the user or administrator.
#	The following information will be displayed in a JAMF Message (jamfHelper) window:
#
#(1.0)
#	- Logged in Username
#	- Computer Hostname
#	- Computer Model
#	- macOS Version (Build #)
#	- IP Address for en0, en1, en3, en5, en8 interfaces
#	- MAC Addresses for en0, en1, en3, en5, en8 interfaces
#	- VPN IP (edit "vpnIPSubnet" variable)
#	- Installed Memory
#	- Free Disk Space
#	- Computer Up Time
#	- JSS Status
#	- Active Directory Domain (if bound)
#	- FileVault Status
#	- Kernal Panics (kernal panic log counts the past 7 days)
#	- SIP Status
#	- xProtect Version
#	- Firmware Password Status
#	- Apple Chip Type
#	- Last Reboot (last time the computer has rebooted or turned on)
#	- Up Time (how long the computer has been turned on)
#	- Root User Status
#	- Bootcamp Detected
#	- WiFi SSID (interface ID)
#	- Device Certificate Expiration Date
#	- Avaiable Software Updates
#	- Serial Number
#	- Firewall Status
#	- CPU Type
#	- Graphics Card (also reports on secondary card)
#	- NTP Server (Network Time Protocol)
#	- Sleep Status
#	- Time Zone
#	- Remote Login Status
#	- File System Type (edit "fileSystemName" varaible)
#(1.1)
#	- Gatekeeper Status
#	- MRT Version
#	- CrowdStrke Status
#	- Qualys Status
#	- Hard Drive Type
#	- HD SMART Status
#	- Full Computer Model Name
#	- Administrator Accounts
#
#	NOTE: The returned value of the varaibles will vary from machine to machine.  This will cause
#	your JAMF Message window to look a little messy.  Play with the spacing below (add or remove
#	spaces).
#
# VERSION
#
#	- 1.1
#
# CHANGE HISTORY
#
# 	- Created script - 4/29/19 (1.0)
#	- Added 8 more items to report on - 7/22/19 (1.1)
#
####################################################################################################


##################################################################
## JAMF message window variables (EDIT THIS SECTION)
##################################################################

# Window Typ = (hud, utility, fs)
type="hud"

# Window Title
title="Displaying Computer Information"

# Window Heading
#heading="Displaying Computer Information"

# Window Description
#description=""

# Button Text
button="Close"

# Icon Path
icon="/Applications/Utilities/System Information.app/Contents/Resources/ASP.icns"


##################################################################
## Script Variables (EDIT THIS SECTION)
##################################################################

## Add your VPN IP Subnet
vpnIPSubnet="10.123."

## Add the name of your computers boot partition
fileSystemName="Macintosh HD"


##################################################################
## Information variables (DO NOT EDIT)
##################################################################

hostName=`hostname`
en0IP=`ipconfig getifaddr en0`
en1IP=`ipconfig getifaddr en1`
en3IP=`ipconfig getifaddr en3`
en5IP=`ipconfig getifaddr en5`
en8IP=`ipconfig getifaddr en8`
en0MAC=`ifconfig en0 | awk '/ether/{print $2}' | sed -n 1p`
en1MAC=`ifconfig en1 | awk '/ether/{print $2}' | sed -n 1p`
en3MAC=`ifconfig en3 | awk '/ether/{print $2}' | sed -n 1p`
en5MAC=`ifconfig en5 | awk '/ether/{print $2}' | sed -n 1p`
en8MAC=`ifconfig en8 | awk '/ether/{print $2}' | sed -n 1p`
userName=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
fullName=`finger | grep "$userName" | sed -n 1p | awk '{print $2,$3}'`
bootDisk=`bless --getBoot`
diskInfo=`df -iH / | grep $bootDisk | awk '{print $2}'`
diskInfoFree=`df -iH / | grep $bootDisk | awk '{print $4}'`
upTime=`uptime | awk '{print $3}' | tr -d ','`
jamfCheck=`jamf checkJSSConnection | grep The | awk '{print $4}' | tr -d '.'`
modelInfo=`sysctl hw.model | awk '{print $2}'`
osVer=`sw_vers -productVersion`
osBuild=`sw_vers -buildVersion`
adCheck=`dsconfigad -show | awk '/Active Directory Domain/{print $NF}'`
memCheck=`system_profiler SPHardwareDataType | grep "  Memory:" | awk '{print $2,$3}'`
fvStatus=`fdesetup status | awk '{print $3}' | tr -d '.'`
kerpanCheck=`find /Library/Logs/DiagnosticReports -Btime -7 -name *.panic | awk 'END{print NR}'`
sipStatus=`csrutil status | awk '{print $5}' | tr -d '.'`
xproVer=`defaults read /System/Library/CoreServices/XProtect.bundle/Contents/Resources/XProtect.meta.plist Version`
firmStatus=`/usr/sbin/firmwarepasswd -check | awk '{print $3}'`
lastReboot=`last reboot | sed -n 1p | awk '{print $3,$4,$5,$6}'`
deviceCertExp=$(/usr/bin/security find-certificate -a -c "$hostName" -p -Z "/Library/Keychains/System.keychain" | /usr/bin/openssl x509 -noout -enddate| cut -f2 -d=)
deviceCertExpDate=$(/bin/date -j -f "%b %d %T %Y %Z" "$deviceCertExp" "+%m/%d/%Y")
softwareUpdates=`defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist LastUpdatesAvailable`
serialNumber=`system_profiler SPHardwareDataType | grep Serial | awk '{print $4}'`
firewallStatus=`/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | awk '{print $3}' | tr -d '.'`
cpuType=`sysctl -n machdep.cpu.brand_string | awk '{print $6,$3}' | tr -d '(R)'`
gfxType1=`/usr/sbin/system_profiler SPDisplaysDataType | awk -F': ' '/Chipset Model/ {print $2}' | sed -n 1p`
ntpServer=`systemsetup -getnetworktimeserver | awk '{print $4}'`
sleepStatus=`systemsetup -getcomputersleep | awk '{print $3}'`
timeZone=`systemsetup -gettimezone | awk '{print $3}'`
remoteLogin=`systemsetup -getremotelogin | awk '{print $3}'`
fileSystem=`diskutil list | grep "$fileSystemName" | awk '{print $2}'`
mrtVer=`/usr/bin/defaults read /System/Library/CoreServices/MRT.app/Contents/Info.plist CFBundleShortVersionString`
smartStatus=`diskutil info disk0 | grep SMART | awk '{print $3,$4}'`
modelFull=$(curl -s https://support-sp.apple.com/sp/product?cc=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 9-` | sed 's|.*<configCode>\(.*\)</configCode>.*|\1|')
adminAccts=`dscl . -read /Groups/admin GroupMembership | sed 's/root//g; s/GroupMembership://g' | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}'`


##################################################################
## Script Variables (If Statements) (DO NOT EDIT)
##################################################################

vpnIPStatus=`ifconfig | grep "$vpnIPSubnet" | awk '{print $2}'`
if [ "$vpnIPStatus" ]; then
	vpnIP=$vpnIPStatus
else
	vpnIP="N/A"
fi


wifiINT=`/usr/sbin/networksetup -listallhardwareports | grep -A 1 Wi-Fi | awk '/Device/{ print $2 }'`
wifiIPStatus=`/usr/sbin/networksetup -getairportnetwork $wifiINT | sed 's/Current Wi-Fi Network: //g' | sed -n 1p`
if [ "$wifiIPStatus" = "You are not associated with an AirPort network." ]; then
	wifiSSID="Wi-Fi is off"
else
	wifiSSID=$wifiIPStatus
fi


bootCampStatus=`/usr/sbin/diskutil list disk0 | grep -c "Microsoft Basic Data"`
if [ "$bootCampStatus" == "0" ]; then
	bootCamp="No"
else
	bootCamp="Yes"
fi


rootStatus=`dscl . read /Users/root | grep AuthenticationAuthority 2>&1 > /dev/null ; echo $?`
if [ "$rootStatus" == "1" ]; then
	rootUser="No"
else
	rootUser="Yes"
fi


touchIDStatus=`bioutil -rs | grep functionality | awk '{print $4}'`
if [[ "$touchIDStatus" = "0" ]]; then
	touchID="No"
elif [[ "$touchIDStatus" = "1"  ]]; then
	touchID="Yes"
else
	touchID="N/A"
fi


chipTypeStatus=`system_profiler SPiBridgeDataType | grep "chip\|Chip" | awk '{print$4}'`
if [ "$chipTypeStatus" == "T1" ]; then
	chipType=$chipTypeStatus
elif [[ "$chipTypeStatus" = "T2"  ]]; then
	chipType=$chipTypeStatus
else
	chipType="N/A"
fi


gfxType2Status=`/usr/sbin/system_profiler SPDisplaysDataType | awk -F': ' '/Chipset Model/ {print $2}' | sed -n 2p`
if [ "$gfxType2Status" ]; then
	gfxType2=$gfxType2Status
else
	gfxType2="N/A"
fi


if [ -d "/Applications/QualysCloudAgent.app" ]; then
	qcaVersion=$(defaults read /Applications/QualysCloudAgent.app/Contents/Info.plist CFBundleShortVersionString)
	qcaStatus="$qcaVersion"
else
	qcaVersion="n/a"
	qcaStatus="$qcaVersion"
fi


if [ -d "/Library/CS" ]; then
	csVersion=$(sysctl cs | grep "cs.version:" | awk '{print $2}')
	csStatus="$csVersion"
else
	csVersion="n/a"
	csStatus="$csVersion"
fi


hardDrive=`diskutil info disk0 | grep "Solid State" | awk '{print $3}'`
if [ "$hardDrive" = "Yes" ]; then
	hdType="SSD"
else
	hdType="HDD"
fi


gateKeeper=`spctl --status | awk '{print $2}'`
if [ "$gateKeeper" = "disabled" ]; then
	gatekeeperStatus="Off"
else
	gateKeeperStatus="On"
fi


##################################################################
## JAMF message window (EDIT THIS SECTION IF NEEDED)
##################################################################

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType "$type" -title "$title" -heading "$heading" -description "                    
----------------------------------< SYSTEM >--------------------------------------
Model:  _____  $modelFull ($modelInfo)
User:  _____   $userName ($fullName)                     Serial:  _____  $serialNumber
Hostname:  _____  $hostName                      macOS:  _____  $osVer ($osBuild)
CPU:  _____  $cpuType                                        Memory:  _____  $memCheck
Hard Drive:  _____  ${diskInfo}B (${diskInfoFree}B Free)                        Hard Drive Type:  _____  $hdType
SMART Status:  _____  $smartStatus                           File System Type:  _____  $fileSystem
GFX1:  _____  $gfxType1                              GFX2:  _____  $gfxType2
Last Reboot:  _____  $lastReboot                                         Up Time:  _____  $upTime
Time Zone:  _____  $timeZone				            Sleep Status:  _____  $sleepStatus

----------------------------------< NETWORK >------------------------------------
WiFi:      _____  $wifiSSID ($wifiINT)		en0 IP:   _____  $en0IP ($en0MAC)
en1 IP:    _____  $en1IP ($en1MAC)	en3 IP:   _____  $en3IP ($en3MAC)
en5 IP:   _____  $en5IP ($en5MAC)					en8 IP:   _____  $en8IP ($en8MAC)
VPN IP:  _____  $vpnIP					NTP:  _____  $ntpServer

----------------------------------< SECURITY >------------------------------------
xProtect Version:  _____  $xproVer                               Firmware Password:  _____  $firmStatus
AD Domain:  _____  $adCheck                                  FileVault Status:  _____  $fvStatus
JSS Status:  _____  $jamfCheck                                                 SIP Status:  _____  $sipStatus
Kernal Panics:  _____  $kerpanCheck                                           Root User Enabled:  _____  $rootUser
Chip Type:  _____  $chipType                                           Boot Camp Detected:  _____  $bootCamp
Touch ID:  _____  $touchID                                                Software Updates:  _____  $softwareUpdates
Device Cert Exp:  _____  $deviceCertExpDate                            Firewall Status:  _____  $firewallStatus
Remote Login:  _____  $remoteLogin                                            Gatekeeer Status:  _____  $gatekeeperStatus
CrowdStrike:  _____  $csStatus                                   MRT Version:  _____  $mrtVer
Qualys:  _____  $qcaStatus                         
Admin Accounts:  _____ $adminAccts

" -button1 "$button" -icon "$icon" -lockHUD -startlaunchd

exit 0

