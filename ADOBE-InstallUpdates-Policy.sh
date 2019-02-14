#!/bin/sh

####################################################################################################
#
# CREATED BY
#
#   Brian Stutzman
#
# DESCRIPTION
#
#	Type: POLICY - This can be ran against all computers. If there are no updates it will
#             not inform the user, the script will just exit.
#
#	Features:
#   	- Inform the user which updates are available
#   	- User will have to click the "Install" button to start the update process
#	- All Adobe apps will quit
#	- Download and install Adobe updates based on the updates available
#	- User will be shown which app is being downloaded/updated during the process
#	- When finished the prompts will go away
#	- If there are no updates available it will not prompt the user
#
#	Notes:
#	- Package all Adobe app icons (.icns) files into a folder called "AdobeIcons" and install
#	  into the /var/tmp folder if you want the jamfHelper window to display the icon for each
#	  app that is getting updated. 
#
# VERSION
#
#	- 1.2
#
# RESOURCES
#
# 	- https://helpx.adobe.com/enterprise/package/help/apps-deployed-without-their-base-versions.html
#
# CHANGE HISTORY
#
# 	- Created script - 12/12/18 (1.0)
# 	- Seperated each app function in its own section - 1/29/19 (1.1)
#	- Added requirement so the script only completes when a user is logged in - (2/6/19) (1.2)
#
####################################################################################################


##################################################################
## Script variables
##################################################################
rumlog=/var/tmp/RUMupdate.log
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
rum=/usr/local/bin/RemoteUpdateManager

# Download individual Adobe apps based on channel ID

installAEFT="/usr/local/bin/RemoteUpdateManager --productVersions=AEFT"		# After Effects
installFLPR="/usr/local/bin/RemoteUpdateManager --productVersions=FLPR"		# Animate
installAUDT="/usr/local/bin/RemoteUpdateManager --productVersions=AUDT"		# Audition
installKBRG="/usr/local/bin/RemoteUpdateManager --productVersions=KBRG"		# Bridge
installCHAR="/usr/local/bin/RemoteUpdateManager --productVersions=CHAR"		# Character Animator
installESHR="/usr/local/bin/RemoteUpdateManager --productVersions=ESHR"		# Dimension
installDRWV="/usr/local/bin/RemoteUpdateManager --productVersions=DRWV"		# Dreamweaver
installFUSE="/usr/local/bin/RemoteUpdateManager --productVersions=FUSE"		# Fuse
installILST="/usr/local/bin/RemoteUpdateManager --productVersions=ILST"		# Illustrator
installAICY="/usr/local/bin/RemoteUpdateManager --productVersions=AICY"		# InCopy
installIDSN="/usr/local/bin/RemoteUpdateManager --productVersions=IDSN"		# InDesign
installLRCC="/usr/local/bin/RemoteUpdateManager --productVersions=LRCC"		# Lightroom CC
installLTRM="/usr/local/bin/RemoteUpdateManager --productVersions=LTRM"		# Lightroom Classic
installAME="/usr/local/bin/RemoteUpdateManager --productVersions=AME"		# Media Encoder
installPHSP="/usr/local/bin/RemoteUpdateManager --productVersions=PHSP"		# Photoshop
installPRLD="/usr/local/bin/RemoteUpdateManager --productVersions=PRLD"		# Prelude
installPPRO="/usr/local/bin/RemoteUpdateManager --productVersions=PPRO"		# Premiere Pro
installRUSH="/usr/local/bin/RemoteUpdateManager --productVersions=RUSH"		# Premiere Rush
installSPRK="/usr/local/bin/RemoteUpdateManager --productVersions=SPRK"		# XD

# App icons (package gets deployed before script runs)

ACROicon="/var/tmp/AdobeIcons/Acrobat.icns"			# Acrobat
ACCDicon="/var/tmp/AdobeIcons/CreativeCloud.icns"		# Adobe Creative Cloud
AEFTicon="/var/tmp/AdobeIcons/AfterEffects.icns"		# After Effects
FLPRicon="/var/tmp/AdobeIcons/Animate.icns"			# Animate
AUDTicon="/var/tmp/AdobeIcons/Audition.icns"			# Audition
KBRGicon="/var/tmp/AdobeIcons/Bridge.icns"			# Bridge
CHARicon="/var/tmp/AdobeIcons/CharacterAnimator.icns"		# Character Animator
ESHRicon="/var/tmp/AdobeIcons/Dimension.icns"			# Dimension
DRWVicon="/var/tmp/AdobeIcons/Dreamweaver.icns"			# Dreamweaver
FUSEicon="/var/tmp/AdobeIcons/Fuse.icns"			# Fuse
ILSTicon="/var/tmp/AdobeIcons/Illustrator.icns"			# Illustrator
AICYicon="/var/tmp/AdobeIcons/InCopy.icns"			# InCopy
IDSNicon="/var/tmp/AdobeIcons/InDesign.icns"			# InDesign
LRCCicon="/var/tmp/AdobeIcons/LightroomCC.icns"			# Lightroom CC
LTRMicon="/var/tmp/AdobeIcons/LightroomClassic.icns"		# Lightroom Classic
AMEicon="/var/tmp/AdobeIcons/MediaEncoder.icns"			# Media Encoder
PHSPicon="/var/tmp/AdobeIcons/Photoshop.icns"			# Photoshop
PRLDicon="/var/tmp/AdobeIcons/Prelude.icns"			# Prelude
PPROicon="/var/tmp/AdobeIcons/PremierePro.icns"			# Premiere Pro
RUSHicon="/var/tmp/AdobeIcons/PremiereRush.icns"		# Premiere Rush
SPRKicon="/var/tmp/AdobeIcons/XD.icns"				# XD


##################################################################
## User login verification (fail script if no user is signed in)
##################################################################
function GetLoginUser ()
{
	UserCheck=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
	if [ "$UserCheck" == "" ]; then
    	
        echo "No user logged in"
        
        # Delete Adobe Icons folder
		rm -rf /var/tmp/AdobeIcons
        
        echo "Removed Adobe icons folder."
        
        # This will cause the policy to fail
        exit 1
        
	else
    
    	echo "User $UserCheck is logged in"
        
	fi
}


##################################################################
## Close apps function
##################################################################
function CloseApps ()
{
    pkill -9 "Acrobat"
    pkill -9 "After Effects"
    pkill -9 "Animate CC"
    pkill -9 "Audition CC"
    pkill -9 "Bridge CC"
    pkill -9 "Character Animator"
    pkill -9 "Adobe Dimension CC"
    pkill -9 "Dreamweaver"
    pkill -9 "Fuse"
    pkill -9 "Adobe Illustrator"
    pkill -9 "InCopy CC"
    pkill -9 "InDesign CC"
    pkill -9 "Lightroom CC"
    pkill -9 "Lightroom Classic"
    pkill -9 "Media Encoder CC"
    pkill -9 "Photoshop CC"
    pkill -9 "Prelude CC"
    pkill -9 "Premiere Pro CC"
	pkill -9 "Premiere Rush CC"
    pkill -9 "XD"
}


##################################################################
## After Effects
##################################################################
function AEFTUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "AEFT" $rumlog)" ] ; then

   	# Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing After Effects update, this may take some time..." \
    -icon "$AEFTicon" -lockHUD > /dev/null 2>&1 &

	  # Download and install update
    $installAEFT

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No After Effects Update"

  fi
}


##################################################################
## Animate
##################################################################
function FLPRUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "FLPR" $rumlog)" ] ; then

   	# Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Animate update, this may take some time..." \
    -icon "$FLPRicon" -lockHUD > /dev/null 2>&1 &

	  # Download and install update
    $installFLPR

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Animate Update"

  fi
}


##################################################################
## Audition
##################################################################
function AUDTUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "AUDT" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Audition update, this may take some time..." \
    -icon "$AUDTicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installAUDT

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Audition Update"

  fi
}


##################################################################
## Bridge
##################################################################
function KBRGUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "KBRG" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Bridge update, this may take some time..." \
    -icon "$KBRGicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installKBRG

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Bridge Update"

  fi
}


##################################################################
## Character Animator
##################################################################
function CHARUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "CHAR" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Character Animator update, this may take some time..." \
    -icon "$CHARicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installCHAR

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Character Animator Update"

  fi
}


##################################################################
## Dimension
##################################################################
function ESHRUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "ESHR" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Dimension update, this may take some time..." \
    -icon "$ESHRicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installESHR

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Dimension Update"

  fi
}


##################################################################
## Dreamweaver
##################################################################
function DRWVUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "DRWV" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Dreamweaver update, this may take some time..." \
    -icon "$DRWVicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installDRWV

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Dreamweaver Update"

  fi
}


##################################################################
## Fuse
##################################################################
function FUSEUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "FUSE" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Fuse update, this may take some time..." \
    -icon "$FUSEicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installFUSE

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Fuse Update"

  fi
}


##################################################################
## Illustrator
##################################################################
function ILSTUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "ILST" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Illustrator update, this may take some time..." \
    -icon "$ILSTicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installILST

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Illustrator Update"

  fi
}


##################################################################
## InCopy
##################################################################
function AICYUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "AICY" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing InCopy update, this may take some time..." \
    -icon "$AICYicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installAICY

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No InCopy Update"

  fi
}


##################################################################
## InDesign
##################################################################
function IDSNUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "IDSN" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing InDesign update, this may take some time..." \
    -icon "$IDSNicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installIDSN

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No InDesign Update"

  fi
}


##################################################################
## Lightroom CC
##################################################################
function LRCCUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "LRCC" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Lightroom CC update, this may take some time..." \
    -icon "$LRCCicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installLRCC

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Lightroom CC Update"

  fi
}


##################################################################
## Lightroom Classic
##################################################################
function LTRMUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "LTRM" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Lightroom update, this may take some time..." \
    -icon "$LTRMicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installLTRM

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Lightroom Update"

  fi
}


##################################################################
## Media Encoder
##################################################################
function AMEUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "AME" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Media Encoder update, this may take some time..." \
    -icon "$AMEicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installAME

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Media Encoder Update"

  fi
}


##################################################################
## Photoshop
##################################################################
function PHSPUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "PHSP" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Photoshop update, this may take some time..." \
    -icon "$PHSPicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installPHSP

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Photoshop Update"

  fi
}


##################################################################
## Prelude
##################################################################
function PRLDUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "PRLD" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Prelude update, this may take some time..." \
    -icon "$PRLDicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installPRLD

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Prelude Update"

  fi
}


##################################################################
## Premiere Pro
##################################################################
function PPROUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "PPRO" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Premiere Pro update, this may take some time..." \
    -icon "$PPROicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installPPRO

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Premiere Pro Update"

  fi
}


##################################################################
## Premiere Rush
##################################################################
function RUSHUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "RUSH" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing Premiere Rush update, this may take some time..." \
    -icon "$RUSHicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installRUSH

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No Premiere Rush Update"

  fi
}


##################################################################
## XD
##################################################################
function SPRKUpdate ()
{
  # Determine if there is an update by looking at the MSupdate.log file
  if [ "$(grep "SPRK" $rumlog)" ] ; then

    # Caffinate the update process
    caffeinate -d -i -m -u &
    caffeinatepid=$!

    # Display jamfHelper message
    "$jamfHelper" -windowType hud -description "Downloading and installing XD update, this may take some time..." \
    -icon "$SPRKicon" -lockHUD > /dev/null 2>&1 &

    # Download and install update
    $installSPRK

    # Kill jamfhelper
    killall jamfHelper > /dev/null 2>&1

    # Kill the caffinate process
    kill "$caffeinatepid"

  else

    echo "No XD Update"

  fi
}



##################################################################
## Clean up files
##################################################################
function CleanUp ()
{
	# Delete RUM log
	rm -rf $rumlog
    
  	# Delete Adobe Icons folder
	rm -rf /var/tmp/AdobeIcons
    
    # Exit script
    exit 0
}


##################################################################
## Main script
##################################################################
# Script will 'exit 1' (fail) if user not logged in
GetLoginUser

# Create RUMupdate.log and output update contents
touch $rumlog

$rum --action=list > $rumlog

# Get the number of updates available from RUMupdate.log
updateCount=`grep -c "osx" $rumlog`

# Clean up the jamfHelper window to show what updates are available
secho=`sed 's/Following Updates are applicable on the system :/Mandatory updates are ready to install:/g' $rumlog \
    | sed '/RemoteUpdateManager exiting with Return Code (0)/d' \
    | sed '1d' \
	| sed '2d' \
    | sed '/RemoteUpdateManager version is/d' \
    | sed '/No new updates are available for Acrobat/d' \
    | sed '/Reader/d' \
    | sed '/Starting the RemoteUpdateManager.../d' \
    | sed '/*/d' \
    | sed 's/ACR/• Acrobat -/g' \
    | sed 's/AEFT/• After Effects -/g' \
    | sed 's/AME/• Media Encoder -/g' \
    | sed 's/AUDT/• Audition -/g' \
    | sed 's/FLPR/• Animate -/g' \
    | sed 's/ILST/• Illustrator -/g' \
    | sed 's/MUSE/• Muse -/g' \
    | sed 's/PHSP/• Photoshop -/g' \
    | sed 's/PRLD/• Prelude -/g' \
    | sed 's/SPRK/• XD -/g' \
    | sed 's/KBRG/• Bridge -/g' \
    | sed 's/AICY/• InCopy -/g' \
    | sed 's/ANMLBETA/• Character Animator Beta -/g' \
    | sed 's/DRWV/• Dreamweaver -/g' \
    | sed 's/IDSN/• InDesign -/g' \
    | sed 's/PPRO/• Premiere Pro -/g' \
    | sed 's/LTRM/• Lightroom Classic -/g' \
    | sed 's/CHAR/• Character Animator -/g' \
    | sed 's/ESHR/• Dimension -/g' \
    | sed 's/LRCC/• Lightroom CC -/g' \
    | sed 's/RUSH/• Premiere Rush -/g' \
    | sed 's/FUSE/• Fuse -/g' \
    | sed 's/\//(/g' \
    | sed 's/(/\ /g' \
    | sed 's/)/\ /g' \
    | sed 's/osx10-64//g' `

if [ "$(grep "Following Updates are applicable" $rumlog)" ] ; then
  userChoice=$("$jamfHelper" -windowType hud -lockHUD -title "AUM Found ($updateCount) Updates" -heading "Adobe Update Manager" \
  -icon "$ACCDicon" -description "$secho

Adobe apps will be closed during the update process. Please SAVE your work before clicking install." \
  -button1 "INSTALL" -defaultButton 0 -lockHUD)
        echo "Installing $secho"
        
        CloseApps
        
		AEFTUpdate		#After Effects

		FLPRUpdate		#Animate

		AUDTUpdate		#Audition

		KBRGUpdate		#Bridge

		CHARUpdate		#Character Animator

		ESHRUpdate		#Dimension

		DRWVUpdate		#Dreamweaver

		FUSEUpdate		#Fuse

		ILSTUpdate		#Illustrator

		AICYUpdate		#InCopy

		IDSNUpdate		#InDesign

		LRCCUpdate		#Lightroom CC

		LTRMUpdate		#Lightroom Classic

		AMEUpdate		#Media Encoder

		PHSPUpdate		#Photoshop

		PRLDUpdate		#Prelude

		PPROUpdate		#Premiere Pro

		RUSHUpdate		#Premiere Rush

		SPRKUpdate		#XD
        
        CleanUp
        
else
    
   	# Delete RUM log
	rm -rf $rumlog
    
    # Delete Adobe Icons folder
	rm -rf /var/tmp/AdobeIcons
    
    echo "There are no Adobe Updates available."
    
    exit 0
fi
