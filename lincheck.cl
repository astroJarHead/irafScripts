# CL script lincheck.cl 
# Bob Zavala me fecit

# An IRAF CL (command language) script for processing a night
# of CCD Photon Transfer Curve (PTC) linearity data taken at
# the ?????? telescope. Illumination provided by flat-field lamps
# on the dome and these flats and biases are present in the directory.

# REQUIRES:
#   1) Script calls a Bash shell columnSep.sh and expects this script
#   to be in the same directory as lincheck.cl
#     a) These scripts are in the solarSytemEphem/images/ directory
#     and calling 
#             "cl> cl < ../lincheck.cl" 
#     from within the individual /g??d??? directories will get the 
#     process to work. 
#
#   2) The CCD Database in IRAF is setup. Do you need help?
#   Bob Zavala can help with this, or check the IRAF Community
#   online documentation. Once setup CCD, CMOS and IR reducitions
#   are streamlined. 

# RUNS ON:
#   Runs on Community IRAF V2.17.1 with a run time on a NOFS
#   VM of 10 minutes for ~260 Princeton Sophia 4096 x 4096
#   CCD images.

# INPUT
#   1) The images in a single directory in the usual ????? naming
#   convention g??.???.??? are the only input. No argument is passed
#   as the script looks for filenames with this pattern. 

# OUTPUT
#   A file called 'raw.signal.txt' containing 10 columns useful for
#   subsequent PTC analysis. The columns are:
#
#	1)  Image filename
#	2)  Image section used for statistics
#	3)  Mean pixel value in that section (DN)
#	4)  Median pixel value in that section (DN)
#	5)  Std. deviation in that section (DN)
#	6)  Minimum pixel value in that section (DN)
#	7)  Maximum pixel value in that section (DN)
#	8)  Exposure time in seconds
#	9)  UTC time hh:mm:ss.sss of the esposure start
#	10) OBSTYPE header keyword (e.g. BIAS, Dome_Flat) 

# At start tell the user the date and time. Start time reported again
# with the endtime so if interested a quick eyeball time estimate of the
# runtime is available. 
print "\n"
date
date >> startDateTime.txt

# Remind the user of the name of the script ;)
print "\n"
print"Running script lincheck.cl\n"

# Check to see if the ccdred IRAF package is loaded.
# If not, load it now.

if (deftask ("ccdred"))
   print ("Package ccdred loaded, continuing.\n")
else
   print ("I need to load the ccdred package.\n")
   noao
   imred
   ccdred

# Run the ccdlsit task as this is useful to have around
# even if not needed. This part requires the CCD Database
# mentioned above in "preliminaries".
ccdlist ("g??d???.???.fits", ccdtype = "", names=no,
long=no,ccdproc="", > "ccdlist.txt")

print "File ccdlist.list created.\n"

# The object type e.g. Bias, Dark or Flat is required
# for the subsequent analysis.
hedit ("g??d???.???.fits",
"OBJECT", ".", add=no, addonly=no, delete=no, verify=no,
show=yes, update=no, > "object.list")

print "File object.list created.\n"

# This copies a one-line file in the parent directory
# so a "column header" is added. I could add this with an
# editing command, but I like this method. 
cp -v /mnt/aaaa/projects/solarSystemEphem/images/obstype.txt .

# Becuase of compatibility issues with header keywords
# as the NOFS headers evolved the OBSTYPE keyword is needed. 
hselect ("g??d???.???.fits",
"OBSTYPE", "yes", missing="INDEF", >> "obstype.txt")

print "File obstype.list created.\n"

# Make a list of all the g??.d???.???.fits filenames to use 
# as an input @file list as needed

!ls g??d???.???.fits > allImages.list

print "List of all fits filenames allImages.list created.\n"

# Use ZEROCOMBINE to create a master bias image for this date

print "Using zerocombine to create the master bias image."
print "This may take a few minutes for > 125 bias images.\n"

zerocombine ("g??d???.???.fits",
output="Zero.fits", combine="median", reject="minmax", ccdtype="zero",
process=no, delete=no, clobber=no, scale="none", statsec="", nlow=0, nhigh=1,
nkeep=1, mclip=yes, lsigma=3., hsigma=3., rdnoise="0.", gain="1.",
snoise="0.", pclip=-0.5, blank=0.)

# Use IMARITH to subtract the Zero.fits image from all images to remove 
# the overscan offset level and the bias structure

print "\n"
print "Subtracting the master bias Zero.fits from all images"
print "using imarith.\n"

imarith ("@allImages.list",
"-", "Zero.fits", "@allImages.list", title="", divzero=0., hparams="",
pixtype="", calctype="", verbose=no, noact=no)

# Get the image statistics required for the PTC analysis.
# The region is chosen for the Sophia CCD. A different
# camera is likely to have a different region.
### In future I should change this so the region is an argument.
### or maybe a camera and a lookup table is provided for
### different cameras. 

print "Calling imstat. This will take about 30-ish seconds"
print "depending on the number of images.\n"

imstat ("g??d???.???.fits[900:3200,1200:3300]",
fields="image,npix,mean,midpt,stddev,min,max", lower=INDEF, upper=INDEF,
nclip=0, lsigma=3., usigma=3., binwidth=0.1, format=yes, cache=no,
> "raw.signal.imstat.txt")

print "File raw.signal.imstat.txt created.\n"

# Another column header line copy.
cp -v /mnt/aaaa/projects/solarSystemEphem/images/exptimes.txt .

# As you might imagine, exposure times are also needed
# for the PTC analysis. 
hselect ("g??d???.???.fits",
"EXPTIME", "yes", missing="INDEF", >> "exptimes.txt")

print "File exptimes.txt created.\n"

# The UTC time of observation is a useful parameter
# to extract for the PTC analysis. Date is already
# coded in the filename. 
cp -v /mnt/aaaa/projects/solarSystemEphem/images/utcobs.txt .

hselect ("g??d???.???.fits",
"UTC-OBS", "yes", missing="INDEF", >> "utcobs.txt")

print "File utcobs.txt created.\n"

# Use the existing Unix 'paste' command to stitch everything
# together into a file that will be used for the PTC analysis.
!paste raw.signal.imstat.txt exptimes.txt utcobs.txt obstype.txt > raw.signal.txt

# Call the Shell script that uses the tried and true ed editor
# to add one needed whitespace so we get the columns we want
# that will be read in for the subsequent analysis.
# Note that the cl needs the '!' to escape the call to the shell.
!../columnSep.sh

# Miller time. 
print "\n"
print "File raw.signal.txt ready for PTC analysis\n"

# Print the start date and time to the screen:
print "This script started at: "
!more startDateTime.txt

# Print the end time so the eyeball runtime estimate may
# be made. If you really want a more precise estimate to be made, feel
# free to improve upon this flawless piece of code :) 
print "This script ended at: "
date
print "\n"
print "Script lincheck.cl finished. \n"

# End cleanly from the script
bye

