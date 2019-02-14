#!/bin/bash

################################################################################################
## DESCRIPTION
## This script will add the logged in users account to the FileVault enabled users 
## list.  The script will pass the already enabled FileVault account credentials to
## enable the log in users account.
##
## The FileVault must be completed in order for this to work correctly.
##
## The script can run either by policy or Self Service item.
################################################################################################
## MODIFIED INFORMATION
## 1/19/16 - Added popup window prompts and echo to log process events throughout the script.
## 1/22/16 - Added a delete command to the .plist file if the password is entered incorrectly.
################################################################################################

## Pass the admin account credentials that is enabled for FileVault
adminName=$4
adminPass=$5

if [ "${adminName}" == "" ]; then
echo "Username undefined. Please pass the management account username in parameter 4"
exit 1
fi

if [ "${adminPass}" == "" ]; then
echo "Password undefined. Please pass the management account password in parameter 5"
exit 2
fi

## Get the login user account
userName=`ls -l /dev/console | awk '{print $3}'`

## Check to see if the logged in account is already enabled for FileVault
userCheck=`fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}'`
if [ "${userCheck}" == "${userName}" ]; then
osascript -e 'Tell application "System Events" to display dialog "The logged in user ('${userName}') has already been added to the FileVault enabled list.  No further action is needed." with text buttons {"OK"} default button 1'
echo "The logged in user (${userName}) is already added to the FileVault enabled list."
exit 3
fi

## Check to see if the encryption status is completed
encryptCheck=`fdesetup status`
statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
expectedStatus="FileVault is On."
if [ "${statusCheck}" != "${expectedStatus}" ]; then
osascript -e 'Tell application "System Events" to display dialog "An error occurred trying to add the logged in user ('${userName}') to the FileVault enabled list.  Please make sure FileVault has been turned on and completed first.  

Contact your Help Desk if you have any questions." with text buttons {"OK"} default button 1 with icon 0'
echo "FileVault is either not enabled or completed.  Cannot add user (${userName})."
exit 4
fi

## Ask the logged in user for their password via a prompt
echo "Prompting user (${userName}) for their login password."
userPass="$(osascript -e 'Tell application "System Events" to display dialog "Enter password for '${userName}' to enable account for FileVault:" default answer "" with text buttons {"OK"} default button 1 with hidden answer' -e 'text returned of result')"
echo "Adding user (${userName}) to the FileVault enabled list..."

## Add credintials for both admin and logged in user to a plist file:
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Username</key>
<string>'$4'</string>
<key>Password</key>
<string>'$5'</string>
<key>AdditionalUsers</key>
<array>
    <dict>
        <key>Username</key>
        <string>'$userName'</string>
        <key>Password</key>
        <string>'$userPass'</string>
    </dict>
</array>
</dict>
</plist>' > /tmp/fvenable.plist

## Use the contents within the plist file to add account to FileVault
fdesetup add -i < /tmp/fvenable.plist

## Check to see if the logged in account was added to the FileVault enabled list
userCheck=`fdesetup list | awk -v usrN="$userName" -F, 'index($0, usrN) {print $1}'`
if [ "${userCheck}" != "${userName}" ]; then
osascript -e 'Tell application "System Events" to display dialog "Failed to add the logged in user ('${userName}') to the FileVault enabled list.  The password may have been incorrectly typed." with text buttons {"OK"} default button 1 with icon 0'
echo "Failed adding user (${userName}) to the FileVault enabled list.  Password incorrect."
srm /tmp/fvenable.plist
exit 5
fi

osascript -e 'Tell application "System Events" to display dialog "Successfully added ('${userName}') to the FileVault enabled list." with text buttons {"OK"} default button 1'
echo "Successfully added user (${userName}) to the FileVault enabled list."

## Delete the plist file
if [[ -e /tmp/fvenable.plist ]]; then
    srm /tmp/fvenable.plist
fi
exit 0
