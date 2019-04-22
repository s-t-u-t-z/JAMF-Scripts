#!/bin/bash

####################################################################################################
#
# CREATED BY
#
# Brian Stutzman
#
# DESCRIPTION
#
#	Type: SELF SERVICE or POLICY
#
# This script can be used in Self Service or applied as a standard Policy.  Script will prompt the
# user to type in the machine asset tag.  Before submitting information to JAMF Pro Server it will
# allow user to confirm information is correct.
#
# VERSION
#
#	- 1.0
#
# CHANGE HISTORY
#
# - Created script - 4/22/19 (1.0)
#
####################################################################################################


# Get computer name
compNAME=`hostname`

# Dialog box to ask for asset tag
assetTAG="$(osascript -e 'Tell application "System Events" to display dialog "Enter the Asset Tag Number:" default answer "" with text buttons {"OK"} default button 1' -e 'text returned of result')"

# Dialog box to confirm asset tag
osascript >/dev/null 2>&1 <<-EOF
Tell application "System Events"
set Msg1 to "Does this information look correct?" & return & return & "Asset Tag: ${assetTAG}" & return & "Computer: ${compNAME}"
set Res1 to display dialog Msg1 buttons {"Cancel", "OK"} default button 1
end tell
EOF

# If CANCEL button is clicked
if [ "$?" != "0" ] ; then
  echo "User canceled. Exiting..."
  exit 0
else
  # If OK button is clicked
  echo "Applying asset tag ${assetTAG} to computer ${compNAME}"
  jamf recon -assetTag $assetTAG
fi


exit 0
