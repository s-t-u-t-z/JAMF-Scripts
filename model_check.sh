#!/bin/bash
####################################################################################################
# ABOUT THIS SCRIPT
#
# CREATED BY
#   Brian Stutzman
#
# CREATED DATE
#   2/5/2018
#
# DESCRIPTION
#   This script can be used to run policies on laptops or desktops.  This is an alternative to
#   using a smart group to scope the policy to.  It will determine if the computer is a laptop
#   or desktop and the option to run a policy based on the result.
#
#   A use case for this script would be if your environement only enables FileVault on laptops
#   and not desktops.
#
####################################################################################################


##################################################################
## Script variables
##################################################################
modelMB=`sysctl hw.model | cut -c 11-17`
modelMBP=`sysctl hw.model | cut -c 11-20`
modelMBA=`sysctl hw.model | cut -c 11-20`
modelMacMini=`sysctl hw.model | cut -c 11-17`
modeliMac=`sysctl hw.model | cut -c 11-14`
modeliMacPro=`sysctl hw.model | cut -c 11-17`
modelMacPro=`sysctl hw.model | cut -c 11-16`


##################################################################
## Script compatiblity check for Laptops
##################################################################
if [[ "$modelMB" = "MacBook" || "$modelMBP" = "MacBookPro" || "$modelMBA" = "MacBookAir" ]]; then
	# Run JAMF policy on laptops
	#jamf policy -id 12
fi


##################################################################
## Script compatiblity check for Desktops
##################################################################
if [[ "$modelMacMini" = "Macmini" || "$modeliMac" = "iMac" || "$modeliMacPro" = "iMacPro" || "$modelMacPro" = "MacPro" ]]; then
	# Run JAMF policy on desktops
	#jamf policy -id 13
fi


exit 0
