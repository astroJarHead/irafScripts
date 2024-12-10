zerocombine ("g*.*",
output="Zero", combine="median", reject="minmax", ccdtype="zero",
process=no, delete=no, clobber=no, scale="none", statsec="", nlow=0, nhigh=1,
nkeep=1, mclip=yes, lsigma=3., hsigma=3., rdnoise="", gain="",
snoise="0.", pclip=-0.5, blank=0.)

ccdproc ("g*.*",
output="", ccdtype="object", max_cache=0, noproc=no, fixpix=no, overscan=yes,
trim=yes, zerocor=yes, darkcor=no, flatcor=no, illumcor=no, fringecor=no,
readcor=no, scancor=no, readaxis="line", fixfile="", biassec="image",
trimsec="image", zero="Zero", dark="", flat="", illum="",
fringe="", minreplace=1., scantype="shortscan", nscan=1, interactive=no,
function="chebyshev", order=5, sample="*", naverage=1, niterate=1,
low_reject=3., high_reject=3., grow=0.)

ccdproc ("g*.*",
output="", ccdtype="flat", max_cache=0, noproc=no, fixpix=no, overscan=yes,
trim=yes, zerocor=yes, darkcor=no, flatcor=no, illumcor=no, fringecor=no,
readcor=no, scancor=no, readaxis="line", fixfile="", biassec="image",
trimsec="image", zero="Zero", dark="", flat="", illum="",
fringe="", minreplace=1., scantype="shortscan", nscan=1, interactive=no,
function="chebyshev", order=5, sample="*", naverage=1, niterate=1,
low_reject=3., high_reject=3., grow=0.)

flatcombine ("g*.*",
output="Flat", combine="median", reject="crreject", ccdtype="flat",
process=no, subsets=yes, delete=no, clobber=no, scale="mode", statsec="",
nlow=1, nhigh=1, nkeep=1, mclip=yes, lsigma=3., hsigma=3., rdnoise="RDNOISE",
gain="GAIN", snoise="0.", pclip=-0.5, blank=1.)

ccdproc ("g*.*",
output="", ccdtype="object", max_cache=0, noproc=no, fixpix=no, overscan=no,
trim=no, zerocor=no, darkcor=no, flatcor=yes, illumcor=no, fringecor=no,
readcor=no, scancor=no, readaxis="line", fixfile="", biassec="", trimsec="",
zero="", dark="", flat="Flat*", illum="", fringe="", minreplace=1.,
scantype="shortscan", nscan=1, interactive=no, function="chebyshev", order=5,
sample="*", naverage=1, niterate=1, low_reject=3., high_reject=3., grow=0.)

