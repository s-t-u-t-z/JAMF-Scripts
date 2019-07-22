<h1>Get Computer Info</h1>

<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Get_Computer_Info/Images/Get_Computer_Info_ex1.png">

Script Type: <b>Self Service Policy</b><br>

Purpose of this script is to provide machine information to either the user or administrator.
The following information will be displayed in a JAMF Message (jamfHelper) window:<br>

- Logged in Username
- Computer Hostname
- Computer Model
- macOS Version (Build #)
- IP Address for en0, en1, en3, en5, en8 interfaces
- MAC Addresses for en0, en1, en3, en5, en8 interfaces
- VPN IP (edit "vpnIPSubnet" variable)
- Installed Memory
- Free Disk Space
- Computer Up Time
- JSS Status
- Active Directory Domain (if bound)
- FileVault Status
- Kernal Panics (kernal panic log counts the past 7 days)
- SIP Status
- xProtect Version
- Firmware Password Status
- Apple Chip Type
- Last Reboot (last time the computer has rebooted or turned on)
- Up Time (how long the computer has been turned on)
- Root User Status
- Bootcamp Detected
- WiFi SSID (interface ID)
- Device Certificate Expiration Date
- Avaiable Software Updates
- Serial Number
- Firewall Status
- CPU Type
- Graphics Card (also reports on secondary card)
- NTP Server (Network Time Protocol)
- Sleep Status
- Time Zone
- Remote Login Status
- File System Type (edit "fileSystemName" varaible)
- Gatekeeper Status
- MRT Version
- CrowdStrke Status
- Qualys Status
- Hard Drive Type
- HD SMART Status
- Full Computer Model Name
- Administrator Accounts

<h3>NOTE:</h3>
The returned value of the varaibles will vary from machine to machine.  This will cause
your JAMF Message window to look a little messy.  Play with the spacing below (add or remove
spaces).
