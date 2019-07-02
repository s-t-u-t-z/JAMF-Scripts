<h1>Adobe - Install Updates</h1>

<h3>There are two version of this script one for a Policy that can run during normal patching window.  
The other is a Self Service policy that can be ran anytime.

<b>(1) RUM Log (/var/tmp):</b>
The RUM (Remote Update Manager) command is used to determine what updates are availabe.  It will then
create a log file and dump its contents to.
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Asset_Tag_Prompt.png">

<b>(2) User is prompted informing of available updates:</b><br><br>
Using the JAMF Helper window the script will pick out the avaiable updates in the RUM log and clean up the wording. 
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Asset_Tag_Prompt.png">

<b>(3) Window will appear doing the downloading/install of the update:</b><br><br>
While the update is downloading and installing the JAMF Helper window will stay open.  Once the update has completed it will
close.
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Asset_Tag_Prompt.png">

<b>(4.0) Confirmation window (Updates Completed):</b><br><br>
A confirmation window will appear once all updates are completed.
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Asset_Tag_Prompt.png">

<b>(4.1) Confirmation window (No Updates):</b><br><br>
A confirmation window will appear once all updates are completed.
<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Adobe_Install_Updates/Images/Asset_Tag_Prompt.png">
