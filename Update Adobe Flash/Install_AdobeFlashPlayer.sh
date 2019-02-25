#!/bin/bash


####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#	This can be used as a Jamf POLICY to provide users weekly updates or it can be used as a 
#	SELF SERVICE workflow.  It will install the latest version of Adobe Flash.  It has a version
#	checker to see if the installed version needs to be updated.  The user will never be prompted
#   throughout the update process.  The script acts silently.
#
# VERSION
#
#	- 1.0
#
# CHANGE HISTORY
#
# 	- Created script - 2/22/19 (1.0)
#
####################################################################################################


##########################################################################################
# Script variables
##########################################################################################
dmg="flash.dmg"
filepath="/tmp"
##########################################################################################


##########################################################################################
# Compare the newest version with the installed version
##########################################################################################
function CompareVersions () 
{

	# Report the latest version of Adobe Flash
	NewVersion=$(curl --connect-timeout 8 --max-time 8 -sf "http://fpdownload2.macromedia.com/get/flashplayer/update/current/xml/version_en_mac_pl.xml" 2>/dev/null | xmllint --format - 2>/dev/null | awk -F'"' '/<update version/{print $2}' | sed 's/,/./g')

	# Check to see if Adobe Flash is currently installed
	if [[ -d '/Library/Internet Plug-Ins/Flash Player.plugin' ]]; then

		InstalledVersion=$(defaults read "/Library/Internet Plug-Ins/Flash Player.plugin/Contents/version" CFBundleShortVersionString)
		
        echo "Installed version: $InstalledVersion"

	else
    
		InstalledVersion="Not Installed"
    
		echo "Adobe Flash not installed."
    
    fi
    
    # New app version and installed app version are the same
	if [[ "$NewVersion" = "$InstalledVersion" ]]; then
        
		echo "Script result: Adobe Flash is current."
            
		exit 0
            
    fi
    
    # New app version is greater than the installed version
    if [[ "$NewVersion" > "$InstalledVersion" ]]; then
        
    	echo "Script result: Installing latest Adobe Flash version."
        
        InstallAdobeFlash
            
    fi
    
    # App not currently installed
    if [[ "$InstalledVersion" = "Not Installed" ]]; then
    
        echo "Script result: Installing latest Adobe Flash version."
                
		InstallAdobeFlash
            
	fi

}


##########################################################################################
# Install Adobe Flash
##########################################################################################
function InstallAdobeFlash () 
{

	# Adobe Flash link
	AFPLink="https://fpdownload.adobe.com/get/flashplayer/pdc/"$NewVersion"/install_flash_player_osx.dmg"
    
	# Download new version
	curl -s -o "${filepath}/${dmg}" $AFPLink
    
	# Mount disk image
	hdiutil attach "${filepath}/${dmg}" -nobrowse -quiet
        
	# Install Adobe Flash
	installer -pkg /Volumes/Flash\ Player/Install\ Adobe\ Flash\ Player.app/Contents/Resources/Adobe\ Flash\ Player.pkg -target / > /dev/null

	sleep 10
    
   	# Un-mount/eject the dmg file
	umount -f /Volumes/Flash*/
	diskutil eject "Flash Player"

	sleep 10

}


##########################################################################################
# Report on the Adobe Flash version
##########################################################################################
function ReportVersion () 
{

	NewInstalledVersion=$(defaults read "/Library/Internet Plug-Ins/Flash Player.plugin/Contents/version.plist" CFBundleShortVersionString)
                    
	echo "Script result: Adobe Flash is now running version:" "$NewInstalledVersion"

}


##########################################################################################
# Remove files in the /tmp folder
##########################################################################################
function CleanUp () 
{

	# Delete disk image
	rm "${filepath}/${dmg}"

}
 
    
##########################################################################################
# Main script
##########################################################################################

CompareVersions

ReportVersion

CleanUp


exit 0
