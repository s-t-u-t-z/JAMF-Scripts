#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#	This script will change the Notification Center settings for apps based on the flags value.
#
#	The flags value will change depending on which settings is selected (or not selected).  To get 
#	the flags value of an app bundle view the "User > Library > Preferences > com.apple.ncprefs.plist"
#	file.  Once you have the flags value for the settings you want to apply, edit the following
#	varibles in this script:  
#
#	- AppsToConfigure
#		[x] The app bundles to configure (ex: jamf/NoMAD)
#		[x] Get the apps bundle list by running the following command:
#		[x] defaults read "/Users/USERNAME_HERE/Library/Preferences/com.apple.ncprefs.plist" | grep bundle-id | awk -F \" '{print $4}' | grep -v "_SYSTEM_CENTER_\|\_WEB_CENTER_:"
#		
#	- "if [ $flag != 8270 ]; then"
#		[x] Enter the flags value in (enableNotifcationsMojave and enableNotifcationsCatalina)
#		
#	- "flag=8270"
#		[x] Enter the flags value in (enableNotifcationsMojave and enableNotifcationsCatalina)
#		
# TEST SCRIPT (AS IS):
#	- Ensure Self Service and NoMAD are installed and represented in the Notification Center settings
#	- Disable (turn off all) notifications for Self Service and NoMAD in the Notification Center
#	- Run the script in Terminal
#	- The flags value will be applied as specified in this script and will turn ON and check every
#	 notification option boxes for both apps
#
# VERSION
#
#	- 1.0
#
# RESOURCES
#
#	- This script was modified to fit my needs.  Original version by bearzooka, found here:
#	- https://www.jamf.com/jamf-nation/discussions/13986/modify-notification-center-preferences-widgets-etc-from-the-command-line
#
# CHANGE HISTORY
#
# 	- Created script - 9/19/19 (1.0)
#
####################################################################################################


##################################################################
## Script variables
##################################################################

# Get the OS version
osvers_major=$(sw_vers -productVersion | awk -F. '{print $1}')
osvers_minor=$(sw_vers -productVersion | awk -F. '{print $2}')

# If OS is less than 10.14 exit script
if [[ ${osvers_major} -eq 10 ]] && [[ ${osvers_minor} -lt 14 ]]; then
	
	echo "OS not supported."
		
	exit 0
	
fi

# Get Logged in user
user=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Notification Center plist location
notificationsPLIST="/Users/$user/Library/Preferences/com.apple.ncprefs.plist"

# Get list notification center objects 
AppsToConfigure=`defaults read $notificationsPLIST | grep bundle-id | awk -F \" '{print $4}' | grep 'jamf\|\NoMAD'`

# Count of the app bundles existing in the plist
apps=`/usr/libexec/PlistBuddy -c "Print :apps" "$notificationsPLIST"`
count=$(echo "$apps" | grep "bundle-id"|wc -l)

# Substracting one to run in a for loop
count=$((count - 1))
change=0


##################################################################
## Script functions
##################################################################

enableNotifcationsMojave() 
{
# for loop
for index in $(seq 0 $count); do
	
	# Get the app bundle ID
	bundleID=$(/usr/libexec/PlistBuddy -c "Print apps:$index:bundle-id" "$notificationsPLIST");
	
	# Checks to see if the app bundle exists in the list of installed bundles
	if [[ "${AppsToConfigure[*]}" == *"$bundleID"* ]]; then
		
		# Get the flags value of the app bundles
		flag=`/usr/libexec/PlistBuddy -c "Print apps:$index:flags" "$notificationsPLIST"`
		
		echo Current value:  $index:$bundleID $flag
		
		# If statement to see if the flags value DOES NOT EQUAL (!=) "8270"
		if [ $flag != 8270 ]; then
			
			echo "  Flag value is not 8270.  Changing to the correct value to enable alerts."
			
			# Set the preferred flags value
			flag=8270
			
			# Set change varaible if the flags value was changed
			change=1
			
			# Run command as logged in user to set the new flags value to app bundle
			sudo -u $user /usr/libexec/PlistBuddy -c "Set :apps:${index}:flags ${flag}" "$notificationsPLIST"
			
			# Set the flag varaible to the new flags value 
			flag=`/usr/libexec/PlistBuddy -c "Print apps:$index:flags" "$notificationsPLIST"`
			
			echo New Value: $index:$bundleID $flag
			
		fi
		
	fi
	
done
}

enableNotifcationsCatalina()
{
# for loop
for index in $(seq 0 $count); do
	
	# Get the app bundle ID
	bundleID=$(/usr/libexec/PlistBuddy -c "Print apps:$index:bundle-id" "$notificationsPLIST");
	
	# Checks to see if the app bundle exists in the list of installed bundles
	if [[ "${AppsToConfigure[*]}" == *"$bundleID"* ]]; then
		
		# Get the flags value of the app bundles
		flag=`/usr/libexec/PlistBuddy -c "Print apps:$index:flags" "$notificationsPLIST"`
		
		echo Current value:  $index:$bundleID $flag
		
		# If statement to see if the flags value DOES NOT EQUAL (!=) "41951566"
		if [ $flag != 41951566 ]; then
			
			echo "  Flag value is not 41951566.  Changing to the correct value to enable alerts."
			
			# Set the preferred flags value
			flag=41951566
			
			# Set change varaible if the flags value was changed
			change=1
			
			# Run command as logged in user to set the new flags value to app bundle
			sudo -u $user /usr/libexec/PlistBuddy -c "Set :apps:${index}:flags ${flag}" "$notificationsPLIST"
			
			# Set the flag varaible to the new flags value 
			flag=`/usr/libexec/PlistBuddy -c "Print apps:$index:flags" "$notificationsPLIST"`
			
			echo New Value: $index:$bundleID $flag
			
		fi
		
	fi
	
done
}


##################################################################
## Main script
##################################################################

# 10.14 
if [[ ${osvers_major} -eq 10 ]] && [[ ${osvers_minor} -eq 14 ]]; then
	
	echo "${osvers_major}.${osvers_minor} (Mojave) was detected. Applying appropriate values."
	
	enableNotifcationsMojave
	
else
	# 10.15
	echo "${osvers_major}.${osvers_minor} (Catalina) was detected. Applying appropriate values."
		
	enableNotifcationsCatalina

fi


# Restart Notification Center
if [ $change == 1 ]; then 
	
	echo "Restarting Notification Center process to apply changes.";
	
	killall sighup usernoted;killall sighup NotificationCenter; 
	
fi

exit 0