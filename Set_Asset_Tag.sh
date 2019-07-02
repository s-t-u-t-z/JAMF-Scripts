#!/bin/bash

####################################################################################################
#
# CREATED BY
#
# Brian Stutzman
#
# DESCRIPTION
#
# Type: SELF SERVICE or POLICY
#
# This script can be used in Self Service or applied as a standard Policy.  Script will prompt the
# user to type in the machine asset tag.  Before submitting information to JAMF Pro Server it will
# allow user to confirm information is correct.
#
# VERSION
#
# - 1.1
#
# CHANGE HISTORY
#
# - Created script - 4/22/19 (1.0)
# - Modified the script wording to make better sense - 7/2/19 (1.1)
#
####################################################################################################


##################################################################
## Script variables
##################################################################

# Get computer name
compName=`hostname`

# Dialog box to ask for asset tag
assetTag="$(osascript -e 'Tell application "System Events" to display dialog "Enter the Asset Tag:" default answer "" with text buttons {"OK"} default button 1' -e 'text returned of result')"


##################################################################
## Main script
##################################################################

# Dialog box to confirm asset tag
osascript >/dev/null 2>&1 <<-EOF
Tell application "System Events"
set Msg1 to "Does this information look correct?" & return & return & "Asset Tag: ${assetTag}" & return & "Computer: ${compName}"
set Res1 to display dialog Msg1 buttons {"Cancel", "YES"} default button 1
end tell
EOF

# If CANCEL button is clicked
if [ "$?" != "0" ] ; then
  
	echo "User canceled. Exiting..."
  
	exit 0
    
else

	# If OK button is clicked
	echo "Applying asset tag ${assetTag} to computer ${compName}"
	
  jamf recon -assetTag $assetTag
    
fi


exit 0

