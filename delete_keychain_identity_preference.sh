#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#   This script will delete the identity preference item from the System keychain.  Add the script
#	  to your JAMF Pro server and set the script parameter (4) to the name of the identity preference
#	  to delete.
#
# SCRIPT TYPE
#
#   POLICY or SELF SERVICE - Can be used in either instance.
#
####################################################################################################
# CHANGE HISTORY
#
# - Created script - 3/11/19
#
####################################################################################################


##################################################################
## Script variables
##################################################################

system=/Library/Keychains/System.keychain


##################################################################
## Main script
##################################################################

security set-identity-preference -n -s "$4" $system

echo "$4 has been deleted"
  
exit 0
