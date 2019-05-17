#!/bin/bash

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
# 	Type: SELF SERVICE POLICY
#
#	This script will remove (if currently enabled) the logged in users account from FileVault and
#	then re-add the account back to FileVault. Ecryption must be completed in order for this script
#	to work correctly. This script is intended to fix the password sync with FileVault and the login
#	screen when the user changes their password.
#
# VERSION
#
#	- 1.3
#
# CHANGE HISTORY
#
#	- Cleaned up script varaiables and functions - 5/17/19 (1.3)
#
####################################################################################################


##################################################################
## JAMF message window variables (EDIT - OPTIONAL)
##################################################################

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Window Typ = (hud, utility, fs)
type="hud"

# Window Title
#title=""

# Window Heading
#heading=""

# Window Description
#description=""

# Button Text
button="Close"

# Icon shown throughout script process
icon1="/System/Library/PreferencePanes/Security.prefPane/Contents/Resources/FileVault.icns"
# Icon shown when issue occurs
icon2="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"


##################################################################
## Script variables (EDIT)
##################################################################

adminUser="MANAGEMENT_ACCOUNT"
tempADMuser="TEMP_ADMIN_ACCOUNT"
tempADMpass="TEMP_ADMIN_PASSWORD"


##################################################################
## Script variables...continued (DO NOT EDIT)
##################################################################

userName=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
userCheck=`fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}'`
fvStatus=`fdesetup status | awk '{print $3}' | sed -n 1p | tr -d '.'`


##################################################################
## Script functions	(DO NOT EDIT)
##################################################################

# VERIFY FILEVAULT STATUS
function checkFVStatus()
{
  # Verify the status of FileVault
  if [ "${fvStatus}" == "On" ]; then

	echo "FileVault is Enabled."

  else

	echo "FileVault is Disabled."

  # Display Failed jamfHelper message
  "$jamfHelper" -windowType "$type" -description "FileVault is disabled.

Please enabled FileVault first." \
  -button1 "$button" -icon "$icon2" -lockHUD

	exit 1

  fi
}


# REMOVE LOGGED IN USER FROM FILEVAULT
function removeLoggedInUserFromFV()
{
	# FileVault Removal Process
  if [ "${userCheck}" == "${userName}" ]; then

	   fdesetup remove -user $userName

     "$jamfHelper" -windowType "$type" -description "User (${userName}) was removed from FileVault." \
     -button1 "$button" -icon "$icon1" -lockHUD

     echo "(${userName}) was removed from FileVault."

  else

    "$jamfHelper" -windowType "$type" -description "User (${userName}) is not currently FileVault enabled." \
    -button1 "$button" -icon "$icon1" -lockHUD

    echo "(${userName}) is not currently FileVault enabled."

	fi
}


# ADD LOGGED IN USER TO FILEVAULT
function addLoggedInUserToFV()
{
	# Ask for the "adminUser" account password via AppleScript prompt
	adminUserPass="$(osascript -e 'Tell application "System Events" to display dialog "Enter the password for ('$adminUser'):" default answer "" with text buttons {"OK"} default button 1 with icon file "System:Library:PreferencePanes:Security.prefPane:Contents:Resources:FileVault.icns" with hidden answer' -e 'text returned of result')"

  # Ask for the "logged in user's" account password via AppleScript prompt
  userPass="$(osascript -e 'Tell application "System Events" to display dialog "Enter current password for ('${userName}'):" default answer "" with text buttons {"OK"} default button 1 with icon file "System:Library:PreferencePanes:Security.prefPane:Contents:Resources:FileVault.icns" with hidden answer' -e 'text returned of result')"

	# Get Secure Token for "tempADMuser" account
	sysadminctl -adminUser "$adminUser" -adminPassword "$adminUserPass" -secureTokenOn "$tempADMuser" -password "$tempADMpass"

  sleep 2

  # Get Secure Token for "logged in user's" account
	sysadminctl -adminUser "$tempADMuser" -adminPassword "$tempADMpass" -secureTokenOn "$userName" -password "$userPass"

# Create the plist file:
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Username</key>
<string>'$tempADMuser'</string>
<key>Password</key>
<string>'$tempADMpass'</string>
<key>AdditionalUsers</key>
<array>
    <dict>
        <key>Username</key>
        <string>'$userName'</string>
        <key>Password</key>
        <string>'$userPass'</string>
    </dict>
</array>
</dict>
</plist>' > /tmp/DV03ES7J-9FC93EX2-LAPEX03B-QWLZ02ZV.plist

	# Add account to FileVault based on plist info
	fdesetup add -inputplist < /tmp/DV03ES7J-9FC93EX2-LAPEX03B-QWLZ02ZV.plist
}


# CLEANUP FILES
function cleanUpFiles()
{
## Overwrite plist file
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Tell_EX</key>
<string>Default</string>
<key>KOUn_ID</key>
<string>SDFKLJSKFJJW90RJ309RC3490WJRMW4RJ904J9RJ4RV49ERJ9WQ4J9QWJM9WJM90J90J9M04WJM90VW4JM90JM90MWA4VFIOEJWMFIOVEWJFIDJDOWAJVPMOEIRJFAMOELKCJSDCLIAJWEOFAWJ392UROERV8UJH5E729O1230U98IDQCWDP9MIC23IE0943RVUN98Q4F983WUUR90W4VR09MWIVWD09IAPWOEFIVMSPEORIUSE498SUVE5PT8MUSE4PM98UAW4FMP98U498SE5F89AWFVUP9MORJSVDROIFJVA499J</string>
<key>T32_UMC_32_11_0_388</key>
<array>
    <dict>
        <key>HDSAO_Helper</key>
        <string>cbdb03f0329059vuwcut86uifj934ugj5608580ghwjqwj2mvng5984ucwh839t9vnsnes893959hjs022dkw02k1ksjszrt1gafzeqgekt0b5498uv349i43rv9uw54nt98uw4t098u45ym9b8u43809q3rmpicapw4f8vejrfv5498tun5to87yvah4osu8e5ngv98s5rup89ve4fpa9w4imfavw3im9e85vho89i5904mic0wkmd90u9lyumjk80tuduch348fgasv37rjgjnbne8</string>
        <key>HDSAO_Caller</key>
        <string>i9609imt09i4r90i390iqecfehiuefhv4t785ht78f87d67c367ggq673e2e98ucf09im0r9fiv509tb589ue4978yqd87yqd87sydhcuhdffob6my9t690rtgm98omjscjmoawu98qc98qd39camociej904t895b8mmyegywceyfn97cw</string>
    </dict>
</array>
</dict>
</plist>' > /tmp/DV03ES7J-9FC93EX2-LAPEX03B-QWLZ02ZV.plist

	# Create directory, move plist file, change file permission/owner, remove directory
	mkdir /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2

	mv /tmp/DV03ES7J-9FC93EX2-LAPEX03B-QWLZ02ZV.plist /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2

	chmod 444 /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2

	chmod 444 /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2/DV03ES7J-9FC93EX2-LAPEX03B-QWLZ02ZV.plist

	chown root:admin /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2

	chown root:admin /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2/DV03ES7J-9FC93EX2-LAPEX03B-QWLZ02ZV.plist

	rm -rf /tmp/FK42V502-DT4HDA36-20LSX0E1-EWC0R5M2

	sleep 3

  # Delete "tempADMuser" account
  dscl . delete /Users/$tempADMuser
  # Delete "tempADMuser" Home folder
  rm -rf /Users/$tempADMuser
}


# UPDATE THE FILEVAULT PREBOOT SCREEN
function updateFVPrebootScreen()
{
	diskutil apfs updatePreboot /
}


# CONFIRM LOGGED IN USER IS FILEVAULT ENABLED
function confirmUserFVEnabled()
{
	## Verifies the account was enabled for FileVault successfully
  fvuserCheck=`fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}' | grep -c "$userName"`

	if [ "${fvuserCheck}" == "1" ]; then

    # Display Success jamfHelper message
    userChoice=$("$jamfHelper" -windowType "$type" -description "Successfully added (${userName}) to FileVault." \
    -button1 "$button" -button2 "Reboot" -icon "$icon1" -lockHUD)

    echo "Successfully added (${userName}) to FileVault."

    	if [ "$userChoice" == "2" ]; then

			     echo ">> User Clicked Reboot"

           # Reboot with a 1 minute delay timer
           shutdown -r +1 &

        	# Display jamfHelper message
        	"$jamfHelper" -windowType hud -lockHUD -title "" \
  			-icon "$icon1" -description "The computer will reboot shortly." \
        	-timeout 57 -countdown -countdownPrompt "" -alignCountdown right &

          exit 0

		else

        	echo ">> User Clicked Close"

        	exit 0

		fi

  	else

    # Display Failed jamfHelper message
    "$jamfHelper" -windowType "$type" -description "Failed to add (${userName}) to FileVault.

Please make sure the current password is being entered.

Contact the Service Desk if this error continues." \
    -button1 "$button" -icon "$icon2" -lockHUD

    echo "Failed adding (${userName}) to FileVault."

    exit 1

  fi
}


##################################################################
## Main script (DO NOT EDIT)
##################################################################

checkFVStatus

removeLoggedInUserFromFV

addLoggedInUserToFV

cleanUpFiles

updateFVPrebootScreen

confirmUserFVEnabled


exit 0
