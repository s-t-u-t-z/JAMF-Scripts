<h1>Get Computer Info</h1>

<img src="https://github.com/stuutz/JAMF-Scripts/blob/master/Get_Computer_Info/Get_Computer_Info_ex1.png">

Script Type: Self Service Policy<br>

Purpose of this script is to provide machine information to either the user or administrator.
The following information will be displayed in a JAMF Message window:<br>

- Logged in Username
- Computer Hostname
- Computer Model
- macOS Version (Build #)
- IP Address for en0, en1, en3, en5, en8 interfaces
- MAC Addresses for en0, en1, en3, en5, en8 interfaces
- VPN IP (adjust "vpnIP" variable for VPN subnet IP)
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
- Number of Admin Accounts (count)
- CPU Type
- Graphics Card (also reports on secondary card)
- NTP Server (Network Time Protocol)
- Sleep Status
- Time Zone
- Remote Login Status
- File System Type
- Startup Disk

<h3>NOTE:</h3>
The returned value of the varaibles will vary from machine to machine.  This will cause
your JAMF Message window to look a little messy.  Play with the spacing below (add or remove
spaces).
