<h1>Install Adobe Flash Player</h1>

This has two parts, the script and the package.  The script can be used in a policy for weekly updates or a Self Service policy.  The update process is silent, no user interruption.

<h3>Script</h3>
The script will do three things:<br>
1) Computers with an old version of Adobe Flash Player it will check to see if a new release is available and installs it.<br>
2) Computers with no Adobe Flash Player installed.  It will download and install the latest version.<br>
3) Computers with the latest version already installed, the script will just exit.<br>

<h3>Package</h3>
Since there is no way to script setting the "Never check for updates" option.  You have to edit the "mms.cfg" file in "/Library/Application Support/Macromedia".  The package will install the "mms.cfg" file into its proper location.  Make sure this package installs after the script runs.  If you do not want this option selected don't install the package.

<h3>JAMF Workflow</h3>
-Create a new policy.  
-Add the "Install_AdobeFlashPlayer.sh" script and set to run "BEFORE".<br>
-Add the "AdobeFlashPlayer-mmscfg.pkg" file.<br>
-Add an "Inventory Update" so the device info is updated as well as any groups after the policy completes.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/AdobeFlashPlayer_JAMF_Workflow.png">
