#!/bin/bash
####################################################################################################
# DESCRIPTION
#	Printer mapping script.  For use with JAMF.
####################################################################################################


name="$4"		# This is the name of the printer, e.g. MyGreatPrinter
url="$5"		# This is the URL of the printer, e.g. ipp://fp01.ac.uk/printers/printer1
ppd="$6"		# This is the path to the ppd file, e.g. /Library/Printers/PPDs/Contents/Resources/HP LaserJet 4000 Series.gz

# Map the printer
lpadmin -p "${name}" -E -v "${url}" -P "${ppd}" -o printer-is-shared=false -o PageSize=A4 -o auth-info-required=negotiate

exit 0
