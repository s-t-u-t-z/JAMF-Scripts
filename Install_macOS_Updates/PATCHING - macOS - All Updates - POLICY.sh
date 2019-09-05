#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
# This script has the following features:  
#  * Installs all available software updates.
#  * If there ARE software updates it will inform the user which updates will be installed.
#  * If there are NO updates available, the script will just exit without notifying the user.  
#  * The user will be informed IF there are updates that will require a reboot.
#  * To initiate the install of updates the user has to click the "Install" button.
#  * This script is designed to handle reboots for T2 chips machines by way of the shutdown 
#    command so updates (ex: security updates) install correctly.
#
# SCRIPT TYPE 
#
#  POLICY - This can be ran against all computers. If there are no updates it will NOT inform the
#  user, the script will just exit.
#
# SCRIPT VERSION
#
#  1.1
#
# CHANGE HISTORY
#
# - Created - 12/21/18
# - Modified the IF statement for the icon variable to support 10.15 - (1.1) - 9/5/19
#
####################################################################################################


##################################################################
## Script Variables
##################################################################
osVersion=`sw_vers -productVersion | cut -c 1-5`
log=/var/tmp/SWU.log
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
chip=$( system_profiler SPiBridgeDataType | grep "chip\|Chip" | awk '{print$4}' )

if [ "$osVersion" = "10.13" ]; then
icon="/Applications/App Store.app/Contents/Resources/AppIcon.icns"
fi

if [ "$osVersion" = "10.14" ] || [ "$osVersion" = "10.15" ]; then
icon="/System/Library/PreferencePanes/SoftwareUpdate.prefPane/Contents/Resources/SoftwareUpdate.icns"
fi

##################################################################
## Reboot function
##################################################################
reboot ()
{
	# Determine if reboot is required (from SWU.log), if not show completion message
	if [ "$(grep "restart" $log)" ]; then

    	echo "Script >> Reboot required.  Determining type of reboot needed."
        
        sleep 3
        
        # Delete the SWU log file
    	rm -rf $log
    
    else
            
        echo "Script >> No reboot required.  Exiting script..."

        sleep 3

       	# Delete the SWU log file
    	rm -rf $log

		# Display jamfHelper message
       	"$jamfHelper" -windowType hud -lockHUD -title "Software Update Manager" \
  		-icon "$icon" -description "Updates have been installed." -button1 "CLOSE" -defaultButton 0
        
        # Exit script
		exit 0
	
    fi
	
    # Machines that have a T2 chip
	if [ "$chip" = "T2" ]; then

		echo "Script >> T2 chip found, shutting down."
        
        # Shutdown with a 1 minute delay timer
    	shutdown -h +1 &
        
        # Display jamfHelper message
        "$jamfHelper" -windowType hud -lockHUD -title "Software Update Manager" \
  		-icon "$icon" -description "The computer will shutdown to finish installing updates.
        
Press the power button after the computer turns off." \
        -timeout 57 -countdown -countdownPrompt "" -alignCountdown right
        
        # Exit script
		exit 0
        
	else 

		# Machines that do not have a T2 chip
		echo "Script >> Standard Reboot."
        
        # Reboot with a 1 minute delay timer
    	shutdown -r +1 &
        
        # Display jamfHelper message
        "$jamfHelper" -windowType hud -lockHUD -title "Software Update Manager" \
  		-icon "$icon" -description "The computer will reboot to finish installing updates." \
        -timeout 57 -countdown -countdownPrompt "" -alignCountdown right
        
        # Exit script
		exit 0
        
    fi
    
	# Exit script
	exit 0
}

##################################################################
## Install updates function
##################################################################
installUpdates ()
{   
    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and Installing Updates, this may take some time..." \
    -icon "$icon" -lockHUD > /dev/null 2>&1 &

	# Install all updates
	softwareupdate -ia

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"
    
    echo "Script >> All updates have been installed."
}

##################################################################
## Script
##################################################################

# Create SWU.log and output update contents
touch $log

softwareupdate -l > $log

# Get the number of updates available from SWU.log
updateCount=`grep -c "*" $log`

# Determine if any updates require a reboot from SWU.log
if [ "$(grep "restart" $log)" ] ; then

	rebootStatus="Reboot Required.  Save all work, then click install."

else

	rebootStatus="Reboot NOT required."

fi

# Clean up the jamfHelper window to cleanly show what updates are available
secho=`sed 's/Software Update found the following new or updated software:/----------------------------------------------/g' $log \
    | sed 's/Finding available software/Mandatory updates are ready to install:/g' \
	| sed '/Software Update Tool/d' \
   	| sed '/recommended/d' \
    | sed 's/*/•/g' `

if [ "$(grep "Software Update found the following" $log)" ] ; then
  userChoice=$("$jamfHelper" -windowType hud -lockHUD -title "Found ($updateCount) macOS Updates" -heading "Software Update Manager" \
  -icon "$icon" -description "$secho
----------------------------------------------

$rebootStatus" \
  -button1 "INSTALL" -defaultButton 0)
        
        echo "Script >> Installing $secho"
        
        installUpdates

		reboot
else

	# Delete the SWU log file
    rm -rf $log
    
	# Exit script
	exit 0

fi
