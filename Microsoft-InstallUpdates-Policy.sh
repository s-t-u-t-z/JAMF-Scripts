#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#   This script will check and install Microsoft Office Updates.  It will inform the user which 
#   updates are available.  The user will have to click the "Install" button to complete the updates.
#   Prompt will not go away until the "Install" button is pressed.  All Microsoft Office apps will
#   quit before the installation of the updates.
#
# SCRIPT TYPE 
#
#   POLICY - This will run against all machines with Microsoft Office apps installed. If there are no 
#   updates it will not inform the user, the script will just exit.
#
# SCRIPT VERSION
#
#   1.0
#
# NOTES
#
#   The Skype for Business and Remote Desktop installations happen quickly which the tail command
#   does not catch for some reason which causes the jamfHelper window to get stuck and the policy
#   never completes.  Removing the jamfHelper window from those two function fixes this.
#
# RESOURCES
#
#   MSUpdateHelper - pbowden (Microsoft)
#   https://github.com/pbowden-msft/msupdatehelper/blob/master/MSUpdateHelper4JamfPro.sh
#
# CHANGE HISTORY
#
#   - Created script - 1/28/19
#
####################################################################################################


##################################################################
## Script variables
##################################################################
# App icons
MAUicon="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/Resources/AppIcon.icns"
EXCLicon="/Applications/Microsoft Excel.app/Contents/Resources/XCEL.icns"
WORDicon="/Applications/Microsoft Word.app/Contents/Resources/MSWD.icns"
PPTicon="/Applications/Microsoft PowerPoint.app/Contents/Resources/PPT3.icns"
OUTicon="/Applications/Microsoft Outlook.app/Contents/Resources/Outlook.icns"
ONEicon="/Applications/Microsoft OneNote.app/Contents/Resources/OneNote.icns"
# Log files
msulog="/var/tmp/MSupdate.log"
maulog="/Library/Logs/Microsoft/autoupdate.log"
# Jamf Helper (brings up UI window)
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"


##################################################################
## Get the logged in user
##################################################################
function GetLoginUser ()
{
	CONSOLE=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
	if [ "$CONSOLE" == "" ]; then
    
    	echo "No user logged in"
        
		USER=""
        
        exit 1
        
	else
    
    	echo "User $CONSOLE is logged in"
        
    	USER="sudo -u $CONSOLE "
        
	fi
}


##################################################################
## Cleanup files, exit script cleanly
##################################################################
function CleanUp ()
{
    # Delete the MSupdate.log file
    rm -rf $msulog
    
    # Exit script
    exit 0
}


##################################################################
## Calls msupdate file to get list of app updates
##################################################################
function GetUpdateList ()
{
	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --list
}


##################################################################
## EXCEL update
##################################################################
function ExcelUpdate ()
{
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "XCEL2019" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "Excel"
    
   		# Caffinate the update process
    	caffeinate -d -i -m -u &
    	caffeinatepid=$!

		# Display jamfHelper message
		"$jamfHelper" -windowType hud -description "Downloading and installing Excel update, this may take some time...
    
Use Excel online while you wait:
https://login.microsoftonline.com" \
		-icon "$EXCLicon" -lockHUD > /dev/null 2>&1 &

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "XCEL2019"

		# Monitor the autoupdate.log file for completion message
		( tail -f -n0 $maulog & ) | grep -q "Installed update: Excel Update"

    	# Kill jamfhelper
    	killall jamfHelper > /dev/null 2>&1

    	# Kill the caffinate process
    	kill "$caffeinatepid"
    
    else
    
    	echo "No Excel Update"
    
    fi
}


##################################################################
## WORD update
##################################################################
function WordUpdate ()
{
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "MSWD2019" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "Word"
    
   		# Caffinate the update process
    	caffeinate -d -i -m -u &
    	caffeinatepid=$!

		# Display jamfHelper message
		"$jamfHelper" -windowType hud -description "Downloading and installing Word update, this may take some time...
    
Use Word online while you wait:
https://login.microsoftonline.com" \
		-icon "$WORDicon" -lockHUD > /dev/null 2>&1 &

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "MSWD2019"

		# Monitor the autoupdate.log file for completion message
		( tail -f -n0 $maulog & ) | grep -q "Installed update: Word Update"

    	# Kill jamfhelper
    	killall jamfHelper > /dev/null 2>&1

    	# Kill the caffinate process
    	kill "$caffeinatepid"
    
    else
    
    	echo "No Word Update"
    
    fi
}


##################################################################
## POWERPOINT update
##################################################################
function PowerPointUpdate ()
{
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "PPT32019" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "PowerPoint"
    
   		# Caffinate the update process
    	caffeinate -d -i -m -u &
    	caffeinatepid=$!

		# Display jamfHelper message
		"$jamfHelper" -windowType hud -description "Downloading and installing PowerPoint update, this may take some time...
    
Use PowerPoint online while you wait:
https://login.microsoftonline.com" \
		-icon "$PPTicon" -lockHUD > /dev/null 2>&1 &

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "PPT32019"

		# Monitor the autoupdate.log file for completion message
		( tail -f -n0 $maulog & ) | grep -q "Installed update: PowerPoint Update"

    	# Kill jamfhelper
    	killall jamfHelper > /dev/null 2>&1

    	# Kill the caffinate process
    	kill "$caffeinatepid"
    
    else
    
    	echo "No PowerPoint Update"
    
    fi
}


##################################################################
## OUTLOOK update
##################################################################
function OutlookUpdate ()
{    
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "OPIM2019" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "Outlook"
    
   		# Caffinate the update process
    	caffeinate -d -i -m -u &
    	caffeinatepid=$!

		# Display jamfHelper message
		"$jamfHelper" -windowType hud -description "Downloading and installing Outlook update, this may take some time...
    
Use Outlook online while you wait:
https://login.microsoftonline.com" \
		-icon "$OUTicon" -lockHUD > /dev/null 2>&1 &

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "OPIM2019"

		# Monitor the autoupdate.log file for completion message
		( tail -f -n0 $maulog & ) | grep -q "Installed update: Outlook Update"

    	# Kill jamfhelper
    	killall jamfHelper > /dev/null 2>&1

    	# Kill the caffinate process
    	kill "$caffeinatepid"
    
    else
    
    	echo "No Outlook Update"
    
    fi
}


##################################################################
## ONENOTE update
##################################################################
function OneNoteUpdate ()
{  
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "ONMC2019" $msulog)" ] ; then
    
   		# Kill the process
    	pkill -9 "OneNote"
    
   		# Caffinate the update process
    	caffeinate -d -i -m -u &
    	caffeinatepid=$!

		# Display jamfHelper message
		"$jamfHelper" -windowType hud -description "Downloading and installing OneNote update, this may take some time...
    
Use OneNote online while you wait:
https://login.microsoftonline.com" \
		-icon "$ONEicon" -lockHUD > /dev/null 2>&1 &

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "ONMC2019"

		# Monitor the autoupdate.log file for completion message
		( tail -f -n0 $maulog & ) | grep -q "Installed update: OneNote Update"

    	# Kill jamfhelper
    	killall jamfHelper > /dev/null 2>&1

    	# Kill the caffinate process
    	kill "$caffeinatepid"
    
    else
    
    	echo "No OneNote Update"
    
    fi
}


##################################################################
## MAU update
##################################################################
function MAUUpdate ()
{
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "MSau" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "AutoUpdate"

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "MSau"
    
    else
    
    	echo "No MAU Update"
    
    fi
}


##################################################################
## REMOTE DESKTOP update
##################################################################
function RemoteDesktopUpdate ()
{  
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "MSRD10" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "Remote Desktop"

		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "MSRD10"
    
    else
    
    	echo "No Remote Desktop Update"
    
    fi
}


##################################################################
## SKYPE FOR BUSINESS update
##################################################################
function SkypeBusinessUpdate ()
{   
    # Determine if there is an update by looking at the MSupdate.log file
    if [ "$(grep "MSFB16" $msulog)" ] ; then
    
    	# Kill the process
    	pkill -9 "Skype for Business"
    
		# Download and install all updates
    	${USER}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps "MSFB16"
    
    else
    
    	echo "No Skype for Business Update"
    
    fi
}


##################################################################
## Main script
##################################################################
# Script will 'exit 1' (fail) if user not logged in
GetLoginUser

# Clear all contents inside the autoupdate.log file
> $maulog

# Create MSupdate.log file
touch $msulog

# Output all available updates to the log file
GetUpdateList > $msulog

# Count the number of updates available from MSupdate.log file
updateCount=`grep -c '\<\(ONMC2019\|OPIM2019\|MSRD10\|PPT32019\|MSFB16\|MSWD2019\|XCEL2019\)\>' $msulog`

# Clean up the jamfHelper window to show what updates are available
secho=`sed 's/Checking for updates.../The following updates are ready to install:/g' $msulog \
	| sed '/Updates available:/d' \
	| sed 's/Outlook Update/• Outlook/g' \
	| sed 's/OneNote Update/• OneNote/g' \
    | sed 's/Excel Update/• Excel/g' \
    | sed 's/PowerPoint Update/• PowerPoint/g' \
    | sed 's/Word Update/• Word/g' \
    | sed 's/Microsoft Remote Desktop/• Remote Desktop/g' \
    | sed 's/Skype For Business Update/• Skype For Business/g' \
    | sed 's/Auto Update/• Auto Update/g' \
    | sed 's/ONMC2019//g' \
    | sed 's/OPIM2019//g' \
    | sed 's/PPT32019//g' \
    | sed 's/MSWD2019//g' \
    | sed 's/XCEL2019//g' \
    | sed 's/MSRD10//g' \
    | sed 's/MSFB16//g' \
    | sed 's/MSau//g' \
    | sed 's/[a-zA-Z0-9_!]*[()][a-zA-Z0-9_!]*//g' `

if [ "$(grep "Updates available:" $msulog)" ] ; then
  userChoice=$("$jamfHelper" -windowType hud -lockHUD -title "MUM Found ($updateCount) Updates" -heading "Microsoft Update Manager" \
  -icon "$MAUicon" -description "$secho

Microsoft apps will be closed during the update process. Please SAVE your work before clicking install." \
  -button1 "INSTALL" -defaultButton 0 -lockHUD)
  
        echo "Installing $secho"
        
        ExcelUpdate
        
        WordUpdate
        
        PowerPointUpdate
        
        OutlookUpdate
        
        OneNoteUpdate
        
        MAUUpdate
        
        RemoteDesktopUpdate
        
        SkypeBusinessUpdate
        
        CleanUp
        
else

    echo "There are no Microsoft updates available."
    
    CleanUp
    
fi
