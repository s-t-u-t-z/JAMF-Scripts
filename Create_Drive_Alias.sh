#!/bin/bash

####################################################################################################
#
# CREATED BY
#
#	Brian Stutzman
#
# DESCRIPTION
#
#	This script will create an alias file to a network share on the user's desktop.
#
#	NOTE: The user will have to approve the PPPC for "/usr/bin/osascript" for the script to run.
#	Unless its already been approved in a configuration profile.
#
# VERSION
#
#	- 1.0
#
# CHANGE HISTORY
#
#	- Created script - 5/8/19 (1.0)
#
####################################################################################################


##################################################################
## Script variables (EDIT BELOW)
##################################################################

osascript -e '
# Set Protocol (EDIT)
set serverProtocol to "smb://"

# Set the full server path (EDIT)
set serverPath to "storage.google.com/Testing_Data"

# Set Volume Name (EDIT)
# This should be the last part of the serverPath variable (ex: smb://storage.google.com/Testing_Data)
set volumeName to "Testing_Data"

# Set Volume Name Alias (EDIT)
# Leave this the same name as the volumeName variable (but it can be different)
set volumeAliasFinal to "Testing_Data"


##################################################################
## Script variables...continued (DO NOT EDIT BELOW)
##################################################################

# Combine both variables into one string (DO NOT EDIT)
set sharePath to serverProtocol & serverPath

# When the alias file is created on the desktop it will append " alias" to the name (DO NOT EDIT)
set tempAlias to " alias"

# Combine both variables into one string (DO NOT EDIT)
set volumePreRename to volumeName & tempAlias


##################################################################
## Main script (DO NOT EDIT BELOW)
##################################################################

# Mount the network share
tell application "Finder" to open location sharePath

# Sleep timer to allow enough time for network share to mount
delay 15.0

# Create the alias file on the desktop
tell application "Finder"
	set theFile to "/Volumes/" & volumeName
	set theFile to theFile as POSIX file
	set aliasFile to make new alias file at desktop to theFile
end tell

# Another sleep timer to allow the previous command to finish up
delay 2.0

# Rename the alias file
tell application "Finder"
	set name of file volumePreRename of desktop to volumeAliasFinal
end tell
'


exit 0
