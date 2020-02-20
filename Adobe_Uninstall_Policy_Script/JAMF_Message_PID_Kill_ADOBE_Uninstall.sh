#!/bin/bash


####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
# 	Parameters for jamfHelper window:
# 	$4	= Window Type (hud, utility, fs)
# 	$5	= Window Title
# 	$6	= App Name
# 	$7	= Window Description
# 	$8	= App Path (ex: /Applications/Self Service.app)
# 	$9	= Kill app process
# 	$10	= Icon Path (ex: /Applications/Self Service.app/Contents/Resources/AppIcon.icns)
# 	$11	= Run a policy custom trigger
#
# VERSION
#
#	- 1.0
#
# CHANGE HISTORY
#
# 	- Created script - 2/19/20 (1.0)
#
####################################################################################################


##########################################################################################
# Script variables
##########################################################################################

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
issueicon="/System/Library/CoreServices/Problem Reporter.app/Contents/Resources/ProblemReporter.icns"
trashicon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FullTrashIcon.icns"


##########################################################################################
# main script
##########################################################################################

######
# S1
######

# If app process is found, present jamfHelper window
if pgrep "$9"; then
    
	echo "Script result: $9 is currently running!"

	if [ -d "$8" ]; then

		echo "Script result: $6 installed"

	else

		echo "Script result: $6 not installed"
    
    	exit 0

	fi

######
# S2
######

	# jamfHelper window
	userChoice=$("$jamfHelper" -windowType "$4" -title "$5" -description "An old version of $6 has been detected on your machine.  This version can no longer be installed due to security vulnerabilities. 

Please uninstall this app and use the Adobe Creative Cloud app to install the latest version." -icon "${10}" -button1 "CANCEL" -button2 "UNINSTALL" -defaultButton 0 -lockHUD)

	# Uninstall button is pressed
	if [ "$userChoice" == "2" ]; then

		echo "Script result: Attempting to uninstall $6"

    	# Display jamfHelper message
    	"$jamfHelper" -windowType "$4" -description "All versions of $9 will be closed.  
    
SAVE ALL CURRENT WORK." -icon "${10}" -button1 "CONTINUE" -lockHUD

   		# Caffinate the update process
    	caffeinate -d -i -m -u &
    	caffeinatepid=$!

    	# Display jamfHelper message
    	"$jamfHelper" -windowType "$4" -description "Attempting to uninstall:
    
$6" -icon "${10}" -lockHUD > /dev/null 2>&1 &

		# Kill the app process
		pkill -9 "$9"

		sleep 3

		echo "Script result: Executing Policy ID $9"

		# Run uninstall policy id
		/usr/local/bin/jamf policy -id "${11}"
     
   		sleep 5
    
		# Run inventory update
    	/usr/local/bin/jamf recon
    
    	# Kill jamfhelper
    	killall jamfHelper > /dev/null 2>&1

    	# Kill the caffinate process
    	kill "$caffeinatepid"
    
    	sleep 3

		# Cancel button is pressed
    	elif [ "$userChoice" == "0" ]; then

        	echo "Script result: User Canceled"
        
        	exit 0

	fi

######
# S3
######

	if [ -d "$8" ]; then

		echo "Script result: $6 failed to uninstall"

		# jamfHelper window
		"$jamfHelper" -windowType "$4" -title "Uninstall Failed" -description "The attempt to uninstall $9 failed.  
    
Please contact the Service Desk for assistance." \
    -icon "$issueicon" -button1 "CLOSE" -defaultButton 0 -lockHUD

	else

		echo "Script result: $6 has been removed"
    
    	# Display jamfHelper message
    	"$jamfHelper" -windowType "$4" -description "Successfully uninstalled:

$6" -icon "$trashicon" -button1 "CLOSE" -defaultButton 0 -lockHUD

	fi

else
    
######
# S4
######

	echo "$9 is not running"
        
	if [ -d "$8" ]; then

		echo "Script result: $6 installed"
        
		echo "Script result: Attempting to remove silently"
        
		# Run uninstall policy id
		/usr/local/bin/jamf policy -id "${11}"
    
		# Run inventory update
		/usr/local/bin/jamf recon
        
	else

		echo "Script result: $6 not installed"
    
    	exit 0

	fi
        
fi

exit 0