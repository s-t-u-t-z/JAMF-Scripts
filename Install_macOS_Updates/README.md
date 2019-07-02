<h1>Install macOS Updates (two different script options)</h1>

<b>Policy Script:</b><br>
This script has the following features:<br>
- Installs all available software updates.<br>
- If there ARE software updates it will inform the user which updates will be installed.<br>
- If there are NO updates available, the script will just exit without notifying the user. <br> 
- The user will be informed IF there are updates that will require a reboot.<br>
- To initiate the install of updates the user has to click the "Install" button.<br>
- This script is designed to handle reboots for T2 chips machines by way of the shutdown command so updates (ex: security updates) install correctly.<br><br>

<b>Self Service Script:</b><br>
This script has the following features:
- If there ARE software updates the user will be informed which updates are available.
- If there are NO updates available, the user will be informed.
- The user will be informed IF any updates require a reboot.
- To initiate the install of updates the user has to click the "Install" button.
- This script is designed to handle reboots for T2 chips machines by way of the shutdown
command so updates (ex: security updates) install correctly.<br><br>

<h3>Setup</h3>
1) Add the "PATCHING - macOS Updates.sh" script to your JPS server<br>
2) Policy settings should be set to "Recurring Check-in" and set to "Once per computer"<br>
3) Set script to run "After"<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/PolicyGeneralSettings.png">
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/ScriptPolicy.png">

<h3>What the user will see</h3>
Window will appear showing the updates that will install:<br><br>
Reboot Required:<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/ShowUpdates-reboot.png">
Reboot NOT Required:<br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/ShowUpdates-noreboot.png">

Window will be present while updates download/install:<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/UpdateStatus.png">

Window will change to count down if updates require a reboot:<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/RebootCountDown.png">

Window will appear if NO reboot is required:<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Install_macOS_Updates/UpdatesCompleted-noreboot.png">

<h3>Note</h3>
The policy will show as "Pending" after the policy has ran on the machine.  This will only happen if there is an update that requires a reboot.  Meaning the policy will run a second time on the computer.  This is "ok" because if there are additional updates to run it will run through the policy again. If there are no updates, the policy will show as "Completed.  If there are updates that DO NOT require a reboot the policy will show as "Completed".
