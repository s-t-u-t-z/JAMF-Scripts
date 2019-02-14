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
#   SELF SERVICE workflow.  It will install the latest version of Sketch.  It has a version checker
#   to see if the installed version needs to be updated.  The user will only be prompted if the app
#   is currently running.  Otherwise the update process is a silent install.
#
# VERSION
#
#   - 1.0
#
# CHANGE HISTORY
#
#   - Created script - 2/12/19 (1.0)
#
####################################################################################################


##########################################################################################
# Script variables
##########################################################################################
AppIcon="/Applications/Sketch.app/Contents/Resources/app.icns"
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
##########################################################################################


##########################################################################################
# Download the latest Sketch version
##########################################################################################
function DownloadSketch () 
{
	
    # Remove any previous files left from prior updates
    CleanUp
        
    # Download Sketch
    curl -L -o /tmp/sketch.zip "http://download.sketchapp.com/sketch.zip" >/dev/null 2>&1

	# Change to /tmp directory
    cd /tmp/
        
    # Unzipping app
    unzip sketch.zip  >/dev/null 2>&1
    
    # Setting app permissions
	chown -R root:wheel /tmp/Sketch.app
	chmod -R 755 /tmp/Sketch.app
	cd ~
        
    NewVersion=$(defaults read /tmp/Sketch.app/Contents/Info.plist CFBundleShortVersionString)
        
    echo "New Version: $NewVersion"
    
}


##########################################################################################
# Get the installed Sketch version
##########################################################################################
function LocalVersion () 
{

    if [[ -d '/Applications/Sketch.app' ]]; then
        
        InstalledVersion=$(defaults read /Applications/Sketch.app/Contents/Info.plist CFBundleShortVersionString)
        
        echo "Script result: Installed Version: $InstalledVersion"

	else
    
		InstalledVersion="Not Installed"
    
    	echo "Script result: Sketch not installed."

    fi
    
}


##########################################################################################
# Compare new and installed app versions
##########################################################################################
function CompareVersions () 
{

    if [[ "$InstalledVersion" = "$NewVersion" ]]; then
        
    	echo "Script result: Sketch is current."
        
        SketchStatus=Current
        
    fi
    
    
    if [[ "$NewVersion" > "$InstalledVersion" ]]; then
        
    	echo "Script result: Installing latest Sketch version."
        
        SketchStatus=Update
        
    fi
    
    
    if [[ "$InstalledVersion" = "Not Installed" ]]; then
        
        echo "Script result: Installing latest Sketch version."
        
        SketchStatus=None
        
    fi
    
}


##########################################################################################
# Determine how to install Sketch
##########################################################################################
function HandleSketch () 
{

    if [ "$SketchStatus" = "Current" ]; then
        
        CleanUp
        
        exit 0
        
    fi
        
   	if [ "$SketchStatus" = "Update" ]; then
    
    	# Inform user that Sketch is running and needs closed before update can complete
		if pgrep '[S]ketch'; then
    
    		echo "Script result: Sketch is currently running!"
        
			userChoice=$("$jamfHelper" -windowType hud -lockHUD -heading "Sketch Update Manager" \
    		-icon "$AppIcon" -description "New version: $NewVersion
Installed version: $InstalledVersion
        
There is an update available.  It requires the app be closed during this process.  
        
Proceed with installation?" \
    		-button1 "INSTALL" -button2 "CANCEL" -defaultButton 0 -lockHUD)

		# User chose to install    
    	if [ "$userChoice" == "0" ]; then
        		
			echo "Script result: User clicked install."
        
        	# Kill the Sketch app process
        	pkill -9 "Sketch"
        
        	RemoveSketch
    
			InstallSketch
        
        	sleep 5
        
    		"$jamfHelper" -windowType hud -heading "Sketch Update Manager" \
    		-description "Update completed!" \
    		-icon "$AppIcon" -button1 CLOSE -defaultButton 0 -lockHUD
    
    	# User chose to cancel
    	elif [ "$userChoice" == "2" ]; then
        
        	echo "Script result: User clicked cancel...exiting."
        
        	CleanUp
        
        	exit 0
        
    	fi
	fi
fi
      
	if [ "$SketchStatus" = "None" ]; then
            
        RemoveSketch
    
		InstallSketch
        
    fi
    
}


##########################################################################################
# Move the new version to the Applications folder
##########################################################################################
function InstallSketch () 
{
    
	# Moving new Sketch.app to the Applications directory
	mv /tmp/Sketch.app /Applications

}

##########################################################################################
# Remove the installed version
##########################################################################################
function RemoveSketch () 
{

    if [[ -d '/Applications/Sketch.app' ]]; then
        until [[ ! -d '/Applications/Sketch.app' ]]; do
            rm -rf /Applications/Sketch.app
        done
    fi

}


##########################################################################################
# Remove files in the /tmp folder
##########################################################################################
function CleanUp () 
{

	# Remove /tmp files
    if [[ -e /tmp/sketch.zip ]]; then
            rm -rf /tmp/sketch.zip   
    fi
   	if [[ -d /tmp/__MACOSX ]]; then
            rm -rf /tmp/__MACOSX/
	fi
	if [[ -d /tmp/Sketch.app ]]; then
            rm -rf /tmp/Sketch.app
	fi

}


##########################################################################################
# Report on the Sketch version
##########################################################################################
function ReportVersion () 
{

	localSketchVersion=$(defaults read /Applications/Sketch.app/Contents/Info.plist CFBundleShortVersionString)
    
	echo "Script result: Sketch is now running version:" "$localSketchVersion"

}


##########################################################################################
# Main script
##########################################################################################
DownloadSketch

LocalVersion

CompareVersions

HandleSketch

ReportVersion

CleanUp


exit 0
