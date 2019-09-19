#!/bin/sh


####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#	SCRIPT IS FOR 10.15 (Catalina)
#
#	This script will change the Notification Center settings for apps based on the flags value.
#
#	The flags value will change depending on which settings is selected (or not selected) and the
#	OS version.  First dertermine which settings you want to apply in the Notification Center settings
#	and then view the "User > Library > Preferences > com.apple.ncprefs.plist" file to find the app 
#	bundle and "flags" value.  Once you have the flags value for the settings you want to apply to go
#	the case statement of this script, add the app bundle name (ex: com.apple.reminders) and enter the
#	"flags" value.
#	
#	TESTING:
#	- Go into the Notification Center settings and disable all the apps you are about to change
#	- Open Terminal and run the script
#	- Open Notification Center and see if the settings have changed
#
# VERSION
#
#	- 1.0
#
# RESOURCES
#
#	- This script was modified to fit my needs.  Original version by roybrian, found here:
#	- https://www.jamf.com/jamf-nation/discussions/13986/modify-notification-center-preferences-widgets-etc-from-the-command-line
#
# CHANGE HISTORY
#
# 	- Created script - 9/19/19 (1.0)
#
####################################################################################################


# Get Logged in user
user=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Location of the notification center preferences plist for the current user
notification_plist="/Users/$user/Library/Preferences/com.apple.ncprefs.plist"

# Count of the bundles existing in the plist
count=$(/usr/libexec/PlistBuddy -c "Print :apps" "${notification_plist}" | grep -c "bundle-id")

	for ((index=1; index<"${count}"; index++)); do
		
		# Getting each bundle id with PlistBuddy
		bundle_id=$(/usr/libexec/PlistBuddy -c "Print apps:${index}:bundle-id" "${notification_plist}");

		case "${bundle_id}" in
			
			# leave as is
			"com.apple.iChat"|"com.apple.mail"|*"_SYSTEM_CENTER_"*|*"_WEB_CENTER_"*|"com.apple.appstore"|"com.apple.TelephonyUtilities") ;;

			"com.trusourcelabs.NoMAD"|"com.jamfsoftware.selfservice.mac"|"com.jamfsoftware.Management-Action")
			/usr/libexec/PlistBuddy -c "Set :apps:${index}:flags 41951566" "${notification_plist}";;

			"com.adobe.acc.AdobeCreativeCloud"|"com.citrix.XenAppViewer"|"com.microsoft.Outlook"|"com.microsoft.SkypeForBusiness"|"com.microsoft.OneDrive")
			/usr/libexec/PlistBuddy -c "Set :apps:${index}:flags 41951246" "${notification_plist}" ;;
			
			"com.microsoft.autoupdate.fba")
			/usr/libexec/PlistBuddy -c "Set :apps:${index}:flags 41951318" "${notification_plist}" ;;
			
			"com.microsoft.Word"|"com.microsoft.Excel")
			/usr/libexec/PlistBuddy -c "Set :apps:${index}:flags 268443662" "${notification_plist}" ;;
			
			"com.microsoft.Powerpoint"|"com.microsoft.onenote.mac")
			/usr/libexec/PlistBuddy -c "Set :apps:${index}:flags 301998094" "${notification_plist}" ;;

			*)
		
		esac
	
	done

	# Restart notification center to make changes take effect.
	killall sighup usernoted
	killall sighup NotificationCenter
