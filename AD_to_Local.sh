#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#	1 - Package the MigrateADMobileAccounttoLocalAccount.command file into the "/var/tmp" folder. 
#	    Link to file is found below under resources.
#	2 - Upload package to JAMF Pro.
#	3 - Add this script to JAMF Pro, set to run "After".
#	4 - Create a Self Service policy to install the .command package file.  Add this script to the
#	    policy and ensure it runs after the package gets installed.
#	5 - Use a computer with Active Directory bound and an exisiting mobile user added.
#	6 - Ensure when the policy is ran by an admin (requires sudo rights).
#
# VERSION
#
#	- 1.0
#
# RESOURCES
#
#	https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/migrate_ad_mobile_account_to_local_account
#
# CHANGE HISTORY
#
# 	- Created script - 7/16/19 (1.0)
#
####################################################################################################


##################################################################
## Script variables
##################################################################

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
icon="/Applications/Utilities/Terminal.app/Contents/Resources/command_icon.icns"
icon2="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
script="/var/tmp/MigrateADMobileAccounttoLocalAccount.command"
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
userType="$(dscl . -read /Groups/admin GroupMembership | grep -c $user)"


##################################################################
## Define Functions 
##################################################################
function confirmAction ()
{

if [ "$userType" == "1" ]; then

userChoice=$("$jamfHelper" -windowType hud -lockHUD -title "AD to Local Account Conversion" \
  -icon "$icon" -description "You are about to run an interactive script that will convert (mobile) active directory accounts to local accounts.
  
Continue?" \
  -button1 "QUIT" -button2 "YES" -defaultButton 0 -lockHUD)

	if [ "$userChoice" == "2" ]; then

		echo ">> User clicked YES."

		open "$script"
        
		# Display jamfHelper message
		"$jamfHelper" -windowType hud -description "Click the 'DONE' button AFTER you have finished converting accounts." \
		-icon "$icon" -button1 "DONE" -lockHUD
        
		osascript -e '
		tell application "Terminal"
			quit
		end tell
		'

	else

		echo ">> User clicked QUIT."

	fi

else

	echo ">> FAILED! No admin account detected."

	cleanUP

	"$jamfHelper" -windowType hud -lockHUD -description "This needs to be ran from an admin account with elevated rights." \
  	-icon "$icon2" -button1 "QUIT" -lockHUD

    exit 1

fi

}


function cleanUP ()
{

	rm -rf "$script"

	echo ">> Script was deleted."

}


##################################################################
## Main script 
##################################################################

confirmAction

cleanUP


exit 0
