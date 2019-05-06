#!/bin/bash


####################################################################################################
#
# CREATED BY
#
# Brian Stutzman
#
# DESCRIPTION
#
# Type: SELF SERVICE POLICY
#
# Environments that require users to authenicate to the Ethernet network will create an entry
# in the login keychain.  If the user changes their password, the keychain will not update. Running
# this script will remove the keychain entry with the old stored password.  The user will be
# instructed to toggle the disconnect/connect button for the Etherent connection so it allows the
# user to re-authenicate with their new password.
#
# VERSION
#
# - 1.1
#
# CHANGE HISTORY
#
# - Created script - 10/15/18 (1.0)
# - Cleaned up script removed un-needed parts and added better variables - 5/6/19 (1.1)
#
####################################################################################################


#########################################################################
# jamfHelper window variables (EDIT THIS SECTION IF NEEDED)
#########################################################################

# Window Typ = (hud, utility, fs)
type="hud"

# Button Text
button="CLOSE"

# Icon Path
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns"


#########################################################################
# Script Variables
#########################################################################

# Get logged in users name
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Determine if Keychain entry is default or profileID (com.apple.network.eap.user.item.default or com.apple.network.eap.user.item.profileid)
itemDefault=`security find-generic-password -a "$user" | grep -c "default"`
itemprofileID=`security find-generic-password -a "$user" | grep -c "profileid"`

# Get full service name (com.apple.network.eap.user.item.default)
serviceFullDef=`security find-generic-password -a "$user" | grep -p svce | cut -c 19-57`

# Get full service name (com.apple.network.eap.user.item.profileid.13DCE60F-0C11-4D3E-8036-91E0935203B3)
serviceFullPro=`security find-generic-password -a "$user" | grep -p svce | cut -c 19-96`


#########################################################################
# Remove Keychain entry (EDIT jamfHelper window info if needed)
#########################################################################

if [ "$itemDefault" = "1" ]; then

	echo "Removed Keychain entry $serviceFullDef"

	# Removes the 802.1X Password entry from keychain
	security delete-generic-password -s "$serviceFullDef"

	# Open Network System Preferences pane
	open /System/Library/PreferencePanes/Network.prefPane

    "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType "$type" -heading "Found Keychain Entry" -alignHeading left -description "Within System Preferences > Networking:
    
- Select the Ethernet service on the left.
    
- Click the Disconnect/Connect button if available, otherwise unplug Ethernet cable.
    
- Enter username and password." -alignDescription left -icon "$icon" -button1 "$button" -defaultButton 0 -lockHUD
    
elif [ "$itemprofileID" = "1" ]; then

	echo "Removed Keychain entry $serviceFullPro"

	# Removes the 802.1X Password entry from keychain
	security delete-generic-password -s "$serviceFullPro"

	# Open Network System Preferences pane
	open /System/Library/PreferencePanes/Network.prefPane

    "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType "$type" -heading "Found Keychain Entry" -alignHeading left -description "Within System Preferences > Networking:
    
- Select the Ethernet service on the left.
    
- Click the Disconnect/Connect button if available, otherwise unplug Ethernet cable.
    
- Enter username and password." -alignDescription left -icon "$icon" -button1 "$button" -defaultButton 0 -lockHUD

else

	echo "No 802.1X Ethernet entry found in keychain."

	# Open Network System Preferences pane
	open /System/Library/PreferencePanes/Network.prefPane

    "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType "$type" -heading "No Keychain Entry Found" -alignHeading left -description "Within System Preferences > Networking:
    
- Select the Ethernet service on the left.
    
- Click the Disconnect/Connect button if available, otherwise unplug Ethernet cable.
    
- Enter username and password." -alignDescription left -icon "$icon" -button1 "$button" -defaultButton 0 -lockHUD

fi


exit 0

