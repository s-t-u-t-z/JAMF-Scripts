#!/bin/bash

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#   This script will delete certificates from the System or Login keychain.  Specify which 
#   keychain(s) and certificate(s) to delete from the script policy settings in JAMF.
#
# SCRIPT TYPE
#
#   POLICY - This script will be assigned to computer(s) to run as a policy.
#
####################################################################################################
# CHANGE HISTORY
#
# - Created script - 12/20/18
#
####################################################################################################


##################################################################
## Script variables
##################################################################

## Get UUID of profile name passed from the JAMF script parameter
UUID=`profiles -Lv | grep "name: $4" -4 | awk -F": " '/attribute: profileIdentifier/{print $NF}'`


##################################################################
## Main script
##################################################################

## Remove said profile, identified by UUID
if [[ $UUID ]]; then
    
    echo "Remove Profile: $4"
    
    echo "Profile UUID: $UUID"
    
    profiles -R -p $UUID
    
    jamf manage
    
    echo "$4 profile has been removed."
    
else
    echo "No Profile Found"
fi

sleep 5

exit 0
