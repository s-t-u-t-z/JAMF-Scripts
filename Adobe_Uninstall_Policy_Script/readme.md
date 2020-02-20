<h1>Adobe Uninstall Policy Script</h1>

The purpose of this script was to create a way to notify the user that they have outdated apps installed and give them the option to Uninstall (or cancel).  This script specificially was used for Adobe Illustrator because the app name never changes (Adobe Illustrator.app) regardless of which version you are using.  So its makes it a little difficult to restrict a specific version without impacting all versions of the app.  In my case I wanted to delete all the old apps because they are showing up as having vulnerabilities.  So this is a round about way to restrict an app using JAMF policies.

Script Highlights:
- If the app process is currently running it will inform the user with a jamfHelper window.  The user will be given the option to uninstall or cancel<br>
- Gives the user the ability to save their work before the app quits<br>
- If the application is not active it will silently uninstall the app<br>

<h3>SCRIPT DEMO VIDEO</h3>
<a href ="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Uninstall_Policy_Script/Files/Adobe_Uninstall_Policy_Script_demo.mp4">Click Here</a>

<h3>Step (1) - CREATE A SMART GROUP</h3>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Uninstall_Policy_Script/Files/smartgroup2.png">

<h3>Step (2) - UPLOAD SCRIPT</h3>
Upload the <i>JAMF_Message_PID_Kill_ADOBE_Uninstall.sh</i> script to JAMF Pro

<h3>Step (3) - CREATE JAMF POLICIES</h3>
(Policy 1) - User Notify Policy (script)<br>
<b>Scope: Smart Group (from step 1)<br>
Trigger: Check-in<br>
Frequency: Ongoing<br></b>
<i>Add only the script from step 2.  Fill in each section (EXCEPT for description).  The Policy ID refers to the uninstall package policy (explained below).  To find the ID of a policy, click the policy link in JAMF Pro, look at the browser URL bar and find the "id=#".  The number is what you need.  Set the script priority to "Before".</i>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Uninstall_Policy_Script/Files/policy_script_info1.png">

<br>(Policy 2) - App Removal Policy (uninstall package)<br>
<b>Scope: All Computers<br>
Trigger: None<br>
Frequency: None<br></b>
<i>Upload the uninstall package to JAMF Pro (not supplied).  Add the package to the policy.</i>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Uninstall_Policy_Script/Files/uninstallerpackage1.png">

When completed it should look like this in JAMF Pro:<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Uninstall_Policy_Script/Files/workflow3.png">

View the video to see what the user experiences.
