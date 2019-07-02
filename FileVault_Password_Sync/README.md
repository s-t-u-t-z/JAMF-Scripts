<h1>FileVault Password Sync</h1>

Script Type: <b>Self Service Policy</b><br>

<h3>Description:</h3>
This script will fix the issue where the user's Active Directory password is out of sync with the FileVault login screen.
Usually this happens when the user changes their password outside System Preferences (ex: Active Directory, a PC, or some other
password reset system).  To fix the issue the user needs to be removed from FileVault enabled users list and add their account
back.  This script will do all the heavy lifting for you.<br>

<h1>Do The Following:</h1>
(1) Add the "FileVault_Password_Sync.sh" script to your JPS (JAMF Pro Server)<br><br>
(2) There are four variables that need to be edited in the script.  Find the "Script variables (EDIT)" section:<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/FileVault_Password_Sync/Images/edit_script_variables1.png">
------> <b>adminUser="MANAGEMENT_ACCOUNT"</b>     -- Replace "MANAGEMENT_ACCOUNT" with the management account on your Macs in your environment<br><br>
------> <b>tempADMuser="TEMP_ADMIN_ACCOUNT"</b>   -- Replace "TEMP_ADMIN_ACCOUNT" with the name of a temp admin account (note: this account will be deleted at the end of the script)<br><br>
------> <b>tempADMpass="TEMP_ADMIN_PASSWORD"</b>  -- Replace "TEMP_ADMIN_PASSWORD" with a password you want to use for the temp account<br><br>
------> <b>plistFolder=".HiddenTempFolder"</b>  -- Replace ".HiddenTempFolder" with a folder name not too recongizeable (ex: Fs0v3sSL002)<br><br>
(3) Create a policy.  Add the following payloads to the policy:<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/FileVault_Password_Sync/Images/policy_payloads.png">
------> <b>Scripts</b> <br><br>
------------> Add the "FileVault_Password_Sync.sh" <br><br>
------------> Set priority to run "After"<br><br>
------> <b>Local Accounts</b>  <br><br>
------------> Create New Account<br><br>
------------> <b>Username</b> = Same name that was entered into the script for the TEMP_ADMIN_ACCOUNT variable<br><br>
------------> <b>Fullname</b> = Same name that was entered into the script for the TEMP_ADMIN_ACCOUNT variable<br><br>
------------> <b>Password</b> = Same password that was entered into the script for the TEMP_ADMIN_PASSWORD variable<br><br>
------------> <b>Home Directory Location</b> = <b>/Users/TEMP_ADMIN_ACCOUNT</b> (use the same name as the TEMP_ADMIN_ACCOUNT variable in the script)<br><br>
------------> <b>Check box to "Allow user to administer computer"</b><br><br>

<h1>Script Breakdown:</h1>
This is a brief explaination of the script process:<br><br>

<b>(function checkFVStatus)</b> - The script will check the status of FileVault (if its enabled or disabled).<br><br>
<b>(function removeLoggedInUserFromFV)</b> - It will determine if the logged in user is already a FileVault enabled user or not.  If so, it will remove the account.<br><br>
<b>(function addLoggedInUserToFV)</b> - The administrator will need to type in the password for the "MANAGEMENT_ACCOUNT".  Afterwards the user will be prompted to type in their password.  A Secure Token will be created for both the "TEMP_ADMIN_ACCOUNT" and "Logged in User's Account".  The "TEMP_ADMIN_ACCOUNT" will be used to add the "Logged in user's account" to FileVault.<br><br>
<b>(function cleanUpFiles)</b> - Cleanup the xml file used to add the user to FileVault.  Deletion of the "TEMP_ADMIN_ACCOUNT" and its Home folder.<br><br>
<b>(function updateFVPrebootScreen)</b> - Update the FileVault Preboot screen.<br><br>
<b>(function confirmUserFVEnabled)</b> - Verify the "Logged in user's account" has been added to FileVault.<br>

<h1>Notes:</h1>
The "TEMP_ADMIN_ACCOUNT", "TEMP_ADMIN_PASSWORD" and the logged in user's username and password will be exported in PLAIN TEXT to the plist (XML) file.  Once the plist file has been used to add the user to FileVault its file contents are overwritten, renamed, permissions changed, and then deleted (the folder which contains the plist is also hidden).   All this happens very quick which makes it difficult to read/copy the contents of the plist file but just know there is a possiblity.  By default the hidden folder is stored in the "/tmp" folder.  Change the location if you want to bury it somewhere else.<br><br>
If you want to add more security to the script look at: https://github.com/jamf/Encrypted-Script-Parameters or make smart groups to report on the "TEMP_ADMIN_ACCOUNT" or the .plist file.  Create a policy that deletes these if found.

<h1>TEST YOUR STUFF!</h1>
