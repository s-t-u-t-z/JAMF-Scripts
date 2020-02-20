<h1>Adobe Uninstall Policy Script</h1>

The purpose of this script was to create a way to notify the user that they have outdated apps installed and give them the option to Uninstall (or cancel).  This script specificially was used for Adobe Illustrator because the app name never changes (Adobe Illustrator.app) regardless of which version you are using.  So its makes it a little difficult to restrict a specific version without impacting all versions of the app.  Thus making a restriction policy a bit more challenging.  Regardless in my case I wanted to delete all the old apps because they are showing up as having vulnerabilities.  So this is a round about way to restrict an app using JAMF policies.

<b>SCRIPT DEMO VIDEO</b><br>
<a href ="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/Adobe_App_Uninstall_Script_demo.mp4">Click Here</a>

<br><b>Step (1) - CREATE A SMART GROUP</b><br>
This smart group will report on the app and verion #

<br><b>Step (2) - UPLOAD SCRIPT</b><br>
This smart group will report on the app and verion #


<br><b>Step (3) - CREATE JAMF POLICIES</b><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/workflow.png">
There are two policies that need created for each app.


<br>(Policy 1) - User Notify Policy (script)
Scope:
Trigger: Smart Group
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/policy_script_info.png">

<br>(Policy 2) - App Removal Policy (uninstall package)
Scope: All Computers
Trigger: None
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/uninstallerpackage.png">




<b>(1) RUM Log (/var/tmp):</b><br>
The RUM (Remote Update Manager) command is used to determine what updates are available.  The script will create a log
file and dump its contents to it.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/RUM_Log.png">

<b>(2) User is prompted informing of available updates:</b><br>
Using the JAMF Helper window the script will pick out the available updates in the RUM log and clean up the wording.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Window_available_updates.png">

<b>(3) Window will appear during the downloading/install of the update:</b><br>
While the update is downloading and installing the JAMF Helper window will stay open.  Once the update has completed it will
close.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Window_progress_update.png">

<b>(4.0) Confirmation window (Updates Completed):</b><br>
A confirmation window will appear once all updates are completed.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Window_updates_completed.png">

<b>(4.1) Confirmation window (No Updates):</b><br>
If there are no Adobe updates available the user will see this window.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Window_no_updates.png">

<h3>NOTES</h3>
--  To make the JAMF Helper window look more presentable to the user, package up all the Adobe icons and add them to the policy.  That way during the download/install process it displays the app icon of the update that is currently being installed.  See the script for more information.<br><br>
--  If using the Policy version of the script the user will only be prompted with windows if there are updates available.  The user will have to click "Install" in order to start the update process but they will not be given the option to "cancel".<br><br>
--  If using the Self Service version the user will be allowed to "cancel" the update process.
