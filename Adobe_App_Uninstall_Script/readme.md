<h1>Adobe Uninstall Policy Script</h1>

The purpose of this script was to create a way to notify the user that they have outdated apps installed and give them the option to Uninstall (or cancel).  This script specificially was used for Adobe Illustrator because the app name never changes (Adobe Illustrator.app) regardless of which version you are using.  So its makes it a little difficult to restrict a specific version without impacting all versions of the app.  Thus making a restriction policy a bit more challenging.  Regardless in my case I wanted to delete all the old apps because they are showing up as having vulnerabilities.  So this is a round about way to restrict an app using JAMF policies.

<b><h3>SCRIPT DEMO VIDEO</h3></b><br>
<a href ="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/Adobe_App_Uninstall_Script_demo.mp4">Click Here</a>

<br><b><h3>Step (1) - CREATE A SMART GROUP</h3></b><br>
This smart group will report on the app and verion #
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/smartgroup.png">

<br><b><h3>Step (2) - UPLOAD SCRIPT</h3></b><br>
Upload the <i>JAMF_Message_PID_Kill_ADOBE_Uninstall.sh</i> script to JAMF Pro


<br><b><h3>Step (3) - CREATE JAMF POLICIES</h3></b><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/workflow.png">


<br>(Policy 1) - User Notify Policy (script)<br>
<b>Scope: Smart Group (from step 1)<br>
Trigger: Check-in<br>
Frequency: Ongoing<br></b>
<i>Add only the script from step 2.  Fill in each section (EXCEPT for description).  The Policy ID refers to the uninstall package policy (explained below).  To find the ID of a policy, click the link in JAMF Pro for the uninstall policy and in the URL bar it will show "ID=#".  The number is what you need.  Set the script priority to "Before".</i>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/policy_script_info.png">

<br>(Policy 2) - App Removal Policy (uninstall package)<br>
<b>Scope: All Computers<br>
Trigger: None<br>
Frequency: None<br></b>
<i>Upload the uninstall package to JAMF Pro (not supplied).  Add the package to the policy.</i>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_App_Uninstall_Script/uninstallerpackage.png">
