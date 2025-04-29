# MATLAB-Flywheel-Gears
This repository houses Flywheel gears witten in MATLAB written by Jeffrey Luci.

There is also a primer for others who wish to develop Flywheel gears using MATLAB.
After spending weeks and months trying to start from, adapt, and use the Flywheel
[`cow-says`](https://gitlab.com/flywheel-io/scientific-solutions/gears/templates/matlab-mcr-cow-says) example MATLAB gear, I realized that very little of those mechaniations - particularly 
the Python and poetry-related wrappers - are necessary. My primer strips out all the 
extraneous complications and added potential breaking points. It is designed for 
developers who primarily use MATLAB and are not entirely comfortable with Python's
countless interdependencies that invariably lead to code maintenance nightmares and
all the associated effort and money it requires to ensure robust and trustworthy applications.
I sincerely hope the primer will help others who found themselves cast into the same boat
I was.

I recommend to any MATLAB developer my `fwhelloworld` gear. One of the biggest problems I
had in developing my first gear was trying to correctly figure out how the configuration,
input, and metadata were passed. The exact content and data structure of the config.json 
file employed by the Flywheel engine is murky at best, and I found the easiest way to 
obtain contextual data is to simply write a gear that parses the planned manifest and 
config JSON files. By customizing the manifest to present the web GUI in the desired way,
running this gear with that manifest will yield the config.json file that MATLAB parses
as well as the entire MATLAB workspace as a .mat file. Having those tools in hand greatly
simplifies the development process and reduces time spent searching for information and
debugging. Or, at least, it did for me. In any event, I strongly recommend starting with
the fwhelloworld gear using your manifest to get the exact set of inputs you will be
using in your code. Look in the `Primer` folder for explanations of choices I made that
are very different from what the official Flywheel `cow-says` example uses, and tips I 
have learned along the way that I wish I knew before I got started.
