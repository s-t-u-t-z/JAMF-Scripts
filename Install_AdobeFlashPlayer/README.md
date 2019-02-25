<h1>Install Adobe Flash Player</h1>

This has two parts, the script and the package.

<h3>Script</h3>
The script will do three things:<br>
1) Computers with an older version of Adobe Flash it will check to see if a new release is available and installs it.<br>
2) Computers with no Adobe Flash Player installed.  It will download and install the latest version.<br>
3) Computers with the latest already version installed it will not reinstall.  The script will exit.<br>

<h3>Package</h3>
Since there is no way to script the "Never check for updates" option.  You have to edit the "mms.cfg" file in "/Library/Application Support/Macromedia".

<h3>JAMF Workflow</h3>
-Create a new policy.  Add the Install_AdobeFlashPlayer.sh script and set to run "BEFORE".<br>
-Add the AdobeFlashPlayer-mmscfg.pkg.<br>
-Make sure to update JAMF afterwards so your inventory is updated for the assets running this policy.
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/JAMF_Workflow_AdobeFlashPlayer.png">
