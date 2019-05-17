<h1>FileVault Password Sync</h1>

Script Type: <b>Self Service Policy</b><br>

<h3>Script Description</h3>
This script will fix the issue where the user's Active Directory password is out of sync with the FileVault login screen.
Usually this happens when the user changes their password outside System Preferences (ex: Active Directory, a PC, or some other
password reset system).  To fix the issue the user needs to be removed from FileVault enabled users list and add their account
back.  This script will do all the heavy lifting for you.<br>

<h3>Do The Following:</h3>
- Add the "FileVault_Password_Sync.sh" script to your JPS (JAMF Pro Server)
- There are only three variables that need to be edited in the script.  Find the "Script variables (EDIT)" section:
  - adminUser="MANAGEMENT_ACCOUNT"     -- Replace "MANAGEMENT_ACCOUNT" with the management account on your Macs in your environment
  - tempADMuser="TEMP_ADMIN_ACCOUNT"   -- Replace "TEMP_ADMIN_ACCOUNT" with the name of a temp admin account (note: this account will be deleted at the end of the script)
  - tempADMpass="TEMP_ADMIN_PASSWORD"  -- Replace "TEMP_ADMIN_PASSWORD" with a password you want to use for the temp account
- Create a policy.  Add the following payloads to the policy:
  - (1) Scripts 
      - Add the "FileVault_Password_Sync.sh" 
      - Set priority to run "After"
  - (2) Local Accounts  
      - Create New Account
      - <b>Username</b> = Same name that was entered into the script for the TEMP_ADMIN_ACCOUNT variable
      - <b>Fullname</b> = Same name that was entered into the script for the TEMP_ADMIN_ACCOUNT variable
      - <b>Password</b> = Same password that was entered into the script for the TEMP_ADMIN_PASSWORD variable
      - <b>Home Directory Location</b> = <b>/Users/TEMP_ADMIN_ACCOUNT</b> (use the same name as the TEMP_ADMIN_ACCOUNT variable in the script)
      - <b>Check box to "Allow user to administer computer"</b>

<b>Thats all!</b>

<h3>Script Breakdown:</h3>
This is a brief explaination of the script process:

1 (function checkFVStatus) - The script will check the status of FileVault (if its enabled or disabled).
2 (function removeLoggedInUserFromFV) - It will determine if the logged in user is already a FileVault enabled user or not.  If so, it will remove the account.
3 (function addLoggedInUserToFV) - The administrator will need to type in the password for the "MANAGEMENT_ACCOUNT".  Afterwards the user will be prompted to type in their password.  A Secure Token will be created for both the "TEMP_ADMIN_ACCOUNT" and "Logged in User's Account".  The "TEMP_ADMIN_ACCOUNT" will be used to add the "Logged in user's account" to FileVault.
4 (function cleanUpFiles) - Cleanup the xml file used to add the user to FileVault.  Deletion of the "TEMP_ADMIN_ACCOUNT" and its Home folder.
5 (function updateFVPrebootScreen) - Update the FileVault Preboot screen.
6 (function confirmUserFVEnabled) - Verify the "Logged in user's account" has been added to FileVault.

<h3>Notes:</h3>
- The "TEMP_ADMIN_ACCOUNT", "TEMP_ADMIN_PASSWORD" and the logged in user's username and password will be exported in PLAIN TEXT to the plist (XML) file.  Once the plist file has been used to add the user to FileVault its file contents are overwritten, renamed, permissions changed, and then deleted.   This process happens pretty quick but there is a slight chance it can be copied if the user knows where its saved.  By default its saved to the "/tmp" folder.  Change the location if you want to bury it deeper.  If you want to add more security to the script look at: https://github.com/jamf/Encrypted-Script-Parameters

