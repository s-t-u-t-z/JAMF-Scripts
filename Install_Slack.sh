#!/bin/bash


####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#   This can be used as a Jamf POLICY to provide users weekly updates or it can be used as a 
#   SELF SERVICE workflow.  It will install the latest version of Slack.  It has a version checker
#   to see if the installed version needs to be updated.  The user will only be prompted if the app
#   is currently running.  Otherwise the update process is a silent install.
#
# VERSION
#
#   - 1.0
#
# CHANGE HISTORY
#
#   - Created script - 2/13/19 (1.0)
#
####################################################################################################


##########################################################################################
# Script variables
##########################################################################################
AppIcon="/Applications/Slack.app/Contents/Resources/slack.icns"
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
ConsoleUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
DownloadLink="https://slack.com/ssb/download-osx"
DownloadURL=$(curl "$DownloadLink" -s -L -I -o /dev/null -w '%{url_effective}')
FileName=$(printf "%s" "${DownloadURL[@]}" | sed 's@.*/@@')
FilePath="/tmp/$FileName"
##########################################################################################


##########################################################################################
# Compare the newest version with the installed version
##########################################################################################
function CompareVersions () 
{
    
    # Get the latest Slack version
	NewVersion=$(/usr/bin/curl -s 'https://downloads.slack-edge.com/mac_releases/releases.json' | grep -o "[0-9]\.[0-9]\.[0-9]" | tail -1)

	# Determine if app is currently installed, if so get version
	if [[ -d '/Applications/Slack.app' ]]; then
    
    	InstalledVersion=$(defaults read /Applications/Slack.app/Contents/Info.plist CFBundleShortVersionString)
        
		echo "Installed version: $InstalledVersion"
    
    else
    
    	InstalledVersion="Not Installed"
    
        echo "Slack not installed."
    
    fi
    
    # New app version and installed app version are the same
	if [[ "$NewVersion" = "$InstalledVersion" ]]; then
        
		echo "Script result: Slack is current."
            
		exit 0
            
    fi
    
    # New app version is greater than the installed version
    if [[ "$NewVersion" > "$InstalledVersion" ]]; then
        
    	echo "Script result: Installing latest Slack version."
        
        HandleSlack
            
    fi
    
    # App not currently installed
    if [[ "$InstalledVersion" = "Not Installed" ]]; then
    
        echo "Script result: Installing latest Slack version."
                
		HandleSlack
            
	fi

}


##########################################################################################
# Download/install Slack app and change permissions
##########################################################################################
function DownloadSlack () 
{
    
    # Download the latest version of Slack
	curl -L -o "$FilePath" "$DownloadURL"

	# Mount the dmg file
	hdiutil attach -nobrowse $FilePath

	# Copy new app to the applications folder
	sudo cp -R /Volumes/Slack*/Slack.app /Applications

	# Un-mount/eject the dmg file
	MountName=$(diskutil list | grep Slack | awk '{ print $3 }')
	umount -f /Volumes/Slack*/
	diskutil eject $MountName

	# Change Slack permissions on new version
	chown -R $ConsoleUser:admin "/Applications/Slack.app"
    
}


##########################################################################################
# Determine how to install Slack and notify user if process is running
##########################################################################################
function HandleSlack () 
{

    # If Slack app is running present prompt to user
	if pgrep '[S]lack'; then
    
		echo "Script result: Slack is currently running!"
    
			UserChoice=$("$jamfHelper" -windowType hud -lockHUD -heading "Slack Update Manager" \
    		-icon "$AppIcon" -description "New version: $NewVersion
Installed version: $InstalledVersion
        
There is an update available.  It requires the app be closed during this process.  
        
Proceed with installation?" \
    		-button1 "INSTALL" -button2 "CANCEL" -defaultButton 0 -lockHUD)
        
       	# User clicked install  
		if [ "$UserChoice" == "0" ]; then
        
			echo "Script result: User clicked install."
        
			RemoveSlack
            
            DownloadSlack
            
            sleep 5
        
    		"$jamfHelper" -windowType hud -heading "Slack Update Manager" \
    		-description "Update completed!" \
    		-icon "$AppIcon" -button1 CLOSE -defaultButton 0 -lockHUD
        
        # User clicked cancel
  		elif [ "$UserChoice" == "2" ]; then
        
        	echo "Script result: User clicked cancel...exiting."
        
        	CleanUp
        
        	exit 0
            
    	fi

	else
    
		# If the Slack app is not running
		RemoveSlack
            
        	DownloadSlack

	fi  

}


##########################################################################################
# Remove the installed version of Slack
##########################################################################################
function RemoveSlack () 
{

    if [[ -d '/Applications/Slack.app' ]]; then
    
        # Kill the Slack app process
		pkill -9 "Slack"
    
        # Delete app
		rm -rf /Applications/Slack.app
        
    fi

}


##########################################################################################
# Remove files in the /tmp folder
##########################################################################################
function CleanUp () 
{

    if [[ -e ${FilePath} ]]; then

    	rm -rf $FilePath
        
    fi

}


##########################################################################################
# Report on the Slack version
##########################################################################################
function ReportVersion () 
{

	localSlackVersion=$(defaults read /Applications/Slack.app/Contents/Info.plist CFBundleShortVersionString)
    
	echo "Script result: Slack is now running version:" "$localSlackVersion"

}


##########################################################################################
# Main script
##########################################################################################
CompareVersions

ReportVersion

CleanUp


exit 0
