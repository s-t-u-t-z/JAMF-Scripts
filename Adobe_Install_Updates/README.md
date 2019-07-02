<h1>Adobe - Install Updates</h1>

<h3>There are two version of this script one for a Policy that can run during normal patching window.  
The other is a Self Service policy that can be ran anytime.</h3>

<b>(1) RUM Log (/var/tmp):</b><br>
The RUM (Remote Update Manager) command is used to determine what updates are availabe.  The script will create a log
file and dump its contents to it.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/RUM_Log.png">

<b>(2) User is prompted informing of available updates:</b><br>
Using the JAMF Helper window the script will pick out the avaiable updates in the RUM log and clean up the wording.<br><br>
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Window_available_updates.png">

<b>(3) Window will appear duing the downloading/install of the update:</b><br>
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
- To make the JAMF Helper window look better to the user, package up all the Adobe Icons and add them to the policy.  That way during the download/install process it displays the icon of the update that is currently being installed.  See the actual script for more information.
