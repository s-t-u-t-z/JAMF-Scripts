#!/bin/bash

####################################################################################################
#
# CREATED BY
#
#	Brian Stutzman
#
# DESCRIPTION
#
# 	Type: SELF SERVICE POLICY
#
#	This script fixes if a user changes their password, chooses to update their keychain but doesn't
#	remember their old password to update keychain.  This causes the OS to throw up a bunch of
#	authenication windows to various apps and services. Creating a new keychain database will
#	resolve this.
#
#	Script Features:
#		- Creates a backup directory for all keychain database backups
#		- Organize keychain backups by formatting backup folder name
#		- Informs the user to logout or restart after script finishes
#
# VERSION
#
#	- 1.1
#
# CHANGE HISTORY
#
#	- Created script - 12/1/17 (1.0)
#	- Cleaned up script, added better variables and refined commands - 5/9/19 (1.1)
#
####################################################################################################


##################################################################
## JAMF message window variables (EDIT THIS SECTION - OPTIONAL)
##################################################################

# Location of jamfHelper binary
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Window Typ = (hud, utility, fs)
type="hud"

# Window Title
#title=""

# Window Heading
#heading=""

# Window Description
description="The current keychain database has been backed up.  Log out or restart to create a new database."

# Button Text
button="Close"

# Icon Path
icon="/Applications/Self Service.app/Contents/Resources/AppIcon.icns"


##################################################################
## Script variables (DO NOT EDIT)
##################################################################

# Get current console user
userNAME=`/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`	

# Date format
dateFORMAT=`date +"%m-%d-%Y_%H.%M.%S"`

# User Keychain folder location
keyFOLD=/Users/$userNAME/Library/Keychains

# MAIN backup folder
backFOLD=/Users/$userNAME/Library/Keychains/backups


##################################################################
## Script functions (DO NOT EDIT)
##################################################################

function backupsCreated ()
{
	# Create the formatted backup folder in the user's Keychain folder
    mkdir $keyFOLD/backup_${dateFORMAT}
	
    sleep 2

	# Move the backups folder to /var/tmp
    mv $keyFOLD/backups /var/tmp
	
	# Move the formatted backup folder to /var/tmp
    mv $keyFOLD/backup_${dateFORMAT} /var/tmp
	
    sleep 2

	# Move the current keychain folder contents into the formatted backup folder
	mv -v $keyFOLD/* /var/tmp/backup_${dateFORMAT}
	
    sleep 2

	# Move the formatted backup folder to the backups folder
	mv -v /var/tmp/backup_${dateFORMAT} /var/tmp/backups
	
	# Move the backups folder to the users Keychain folder
    mv /var/tmp/backups $keyFOLD
  
	# Display jamfHelper message confirming database backup is completed
	"$jamfHelper" -windowType "$type" -description "$description" \
	-button1 "$button" -icon "$icon" -lockHUD
}


function backupsNotCreated ()
{
	# Create the "backups" folder in the user's Keychain folder
	mkdir $keyFOLD/backups

	# Create the formatted backup folder in the user's Keychain folder
    mkdir $keyFOLD/backup_${dateFORMAT}
	
    sleep 2

	# Move the backups folder to /var/tmp
    mv $keyFOLD/backups /var/tmp
	
	# Move the formatted backup folder to /var/tmp
    mv $keyFOLD/backup_${dateFORMAT} /var/tmp
	
    sleep 2

	# Move the current keychain folder contents into the formatted backup folder
	mv -v $keyFOLD/* /var/tmp/backup_${dateFORMAT}
	
    sleep 2

	# Move the formatted backup folder to the backups folder
	mv -v /var/tmp/backup_${dateFORMAT} /var/tmp/backups
	
	# Move the backups folder to the users Keychain folder
    mv /var/tmp/backups $keyFOLD
  
	# Display jamfHelper message confirming database backup is completed
	"$jamfHelper" -windowType "$type" -description "$description" \
	-button1 "$button" -icon "$icon" -lockHUD
}


##################################################################
## Main script (DO NOT EDIT)
##################################################################

## Check to see if backup folder already exists, if not create it
if [ -d "$backFOLD" ]; then

	echo "backups folder exists..."
    
    backupsCreated

else

	echo "backups folder does not exist...creating..."
    
    backupsNotCreated

fi


exit 0
