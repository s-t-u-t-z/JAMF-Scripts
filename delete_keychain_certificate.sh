#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#   This script will delete certificates from the System or Login keychain.  Specify which 
#	keychain(s) and certificate(s) to delete from the script policy settings in JAMF.
#
# SCRIPT TYPE
#
#   POLICY - This script will be assigned to computer(s) to run as a policy.
#
####################################################################################################
# CHANGE HISTORY
#
# - Created script - 12/21/18
#
####################################################################################################



##################################################################
## Script variables
##################################################################

user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
login=/Users/$user/Library/Keychains/login.keychain-db
system=/Library/Keychains/System.keychain


##################################################################
## Main script
##################################################################


########	PARAMETERS 4-5	 	########
if [[ "$4" == "System" ]]; then

security delete-certificate -c "$5" $system
echo "$5 has been deleted"

else

security delete-certificate -c "$5" $login
echo "$5 has been deleted"
  
fi


########	PARAMETERS 6-7	 	########
if [[ "$6" == "System" ]]; then

security delete-certificate -c "$7" $system
echo "$7 has been deleted"

else

security delete-certificate -c "$7" $login
echo "$7 has been deleted"
  
fi


########	PARAMETERS 8-9	 	########
if [[ "$8" == "System" ]]; then

security delete-certificate -c "$9" $system
echo "$9 has been deleted"

else

security delete-certificate -c "$9" $login
echo "$9 has been deleted"
  
fi


########	PARAMETERS 10-11	 ########
if [[ "${10}" == "System" ]]; then

security delete-certificate -c "${11}" $system
echo "${11} has been deleted"

else

security delete-certificate -c "${11}" $login
echo "${11} has been deleted"
  
fi


exit 0
