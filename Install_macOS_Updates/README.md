<h1>Install macOS Updates</h1>

This script will do the following:<br>
- This script has the following features:  <br>
- Installs all available software updates.<br>
- If there ARE software updates it will inform the user which updates will be installed.<br>
- If there are NO updates available, the script will just exit without notifying the user. <br> 
- The user will be informed IF there are updates that will require a reboot.<br>
- To initiate the install of updates the user has to click the "Install" button.<br>
- This script is designed to handle reboots for T2 chips machines by way of the shutdown command so updates (ex: security updates) install correctly.<br><br>


<h3>Setup</h3>
1) Add script to your JPS server<br>
2) Policy settings should be set to "Recurring Check-in" and set to "Once per computer"<br>
3) Set script to run "After"<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/PolicyGeneralSettings.png">
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/ScriptPolicy.png">

<h3>What the user will see</h3>
Window will appear showing the updates that will install:<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/ShowUpdates.png">

Window will be present while updates download/install:<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/UpdateStatus.png">

Window will change to count down if updates require a reboot:<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_AdobeFlashPlayer/RebootCountDown.png">

<h3>Notes</h3>
- The policy will still show as "Pending" after the policy has ran on the machine.  This is "ok" because if there are more updates available it will run again on that computer.  If there are no more updates, then the policy will show as "Completed".
