# IRAF cl script to conduct initial processing of
# PI Sophia CCD images. This script will:

# 1) Load, if needed, the ccdred package
# 2) Combine biases to produce a "master" Zero image
# 3) Subtract the Zero.fits (bias) from all the object
#    and flat images
# 4) Combine the bias-subtracted flats into flats to
#    produce flats in each filter.
# 5) Flat field all the object frames with the correct
#    flat using filter selection.
# 6) Output some hopefully useful informaiton to the user.

# At start tell the user the data and time. Report this again
# at the end so if interested a quick eyeball time estimate of the
# runtime is available. 
print "\n"
date

# Remind the user of the name of the script ;)
print "\n"
print"Running script process-sophia.cl\n"

# Check to see if the ccdred IRAF package is loaded.
# If not, load it now.

if (deftask ("ccdred"))
   print ("Package ccdred loaded, continuing.\n")
else
   print ("I need to load the ccdred package.\n")
   noao
   imred
   ccdred
print "\n"

zerocombine ("g*.*",
output="Zero", combine="median", reject="minmax", ccdtype="zero",
process=no, delete=no, clobber=no, scale="none", statsec="", nlow=0, nhigh=1,
nkeep=1, mclip=yes, lsigma=3., hsigma=3., rdnoise="", gain="",
snoise="0.", pclip=-0.5, blank=0.)

ccdproc ("g*.*",
output="", ccdtype="object", max_cache=0, noproc=no, fixpix=no, overscan=no,
trim=no, zerocor=yes, darkcor=no, flatcor=no, illumcor=no, fringecor=no,
readcor=no, scancor=no, readaxis="line", fixfile="", biassec="image",
trimsec="image", zero="Zero", dark="", flat="", illum="",
fringe="", minreplace=1., scantype="shortscan", nscan=1, interactive=no,
function="chebyshev", order=5, sample="*", naverage=1, niterate=1,
low_reject=3., high_reject=3., grow=0.)

ccdproc ("g*.*",
output="", ccdtype="flat", max_cache=0, noproc=no, fixpix=no, overscan=no,
trim=no, zerocor=yes, darkcor=no, flatcor=no, illumcor=no, fringecor=no,
readcor=no, scancor=no, readaxis="line", fixfile="", biassec="image",
trimsec="image", zero="Zero", dark="", flat="", illum="",
fringe="", minreplace=1., scantype="shortscan", nscan=1, interactive=no,
function="chebyshev", order=5, sample="*", naverage=1, niterate=1,
low_reject=3., high_reject=3., grow=0.)

flatcombine ("g*.*",
output="Flat", combine="median", reject="crreject", ccdtype="flat",
process=no, subsets=yes, delete=no, clobber=no, scale="mode",
statsec="[650:3650,650:3100]",
nlow=1, nhigh=1, nkeep=1, mclip=yes, lsigma=3., hsigma=3., rdnoise=4.026,
gain=1.024, snoise="0.", pclip=-0.5, blank=1.)

ccdproc ("g*.*",
output="", ccdtype="object", max_cache=0, noproc=no, fixpix=no, overscan=no,
trim=no, zerocor=no, darkcor=no, flatcor=yes, illumcor=no, fringecor=no,
readcor=no, scancor=no, readaxis="line", fixfile="", biassec="", trimsec="",
zero="", dark="", flat="Flat*", illum="", fringe="", minreplace=1.,
scantype="shortscan", nscan=1, interactive=no, function="chebyshev", order=5,
sample="*", naverage=1, niterate=1, low_reject=3., high_reject=3., grow=0.)

# Miller time. 
print "\n"
print "Script process-sophia.cl finished\n"
print "Images reduced for analysis\n"
print "\n"

# Again pass the system date and time so the eyeball runtime estimate may
# be made. If you really want a more precise estimate to be made, feel
# free to improve upon this flawless piece of code :) 
date

# End cleanly from the script
bye


