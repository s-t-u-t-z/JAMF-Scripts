#!/bin/bash


####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#   This script utilizes the jamfHelper window to inform users before a policy runs.  The parameters
#   in the script policy control what is said in the message.  The script also has a built in app
#   running checker to make sure the app quits before the app updates.
#
#  Parameters for jamfHelper window:
#   $4	= Window Type (hud, utility, fs)
#   $5	= Window Title
#   $6	= Window Heading
#   $7	= Window Description
#   $8	= Button Text
#   $9	= Kill app process
#   $10	= Icon Path (ex: /Applications/Self Service.app/Contents/Resources/AppIcon.icns)
#
# VERSION
#
#   - 1.0
#
# CHANGE HISTORY
#
#   - Created script - 2/18/19 (1.0)
#
####################################################################################################


##########################################################################################
# Script variables
##########################################################################################
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
app="$9"


##########################################################################################
# Determine if the app is running
##########################################################################################

    # If app process is found, present jamfHelper window
	if pgrep "$app"; then
    
    	echo "Script result: $app is currently running!"
        
        # jamfHelper window
        "$jamfHelper" -windowType "$4" -title "$5" -heading "$6" -description "$7" -button1 "$8" -icon "${10}" -lockHUD
    
    	# Kill the app process
		pkill -9 "$app"  
            
	else
    
        echo "$app is not running."
        
	fi


exit 0
