# matlab-biopac-template
This is a minimal example experiment. Currently it includes just the calibration stage of an experiment.

## Requirements
Other working software combinations are available, but if you're downloading everything anyway, perhaps get the same versions that I am using to develop this:
- Matlab R2023b
- Psychtoolbox version 3.0.19.7
	- https://github.com/Psychtoolbox-3/Psychtoolbox-3/releases
- gstreamer 1.22.5 (MSVC, not MinGW)
	- https://gstreamer.freedesktop.org/releases/ or https://gstreamer.freedesktop.org/data/pkg/windows/

## How to run
Run the experiment.m script in MATLAB.

## Using psychtoolbox
- When developing your task, it's easiest to use two screens. Have the matlab editor window on the second monitor, and when you run the task it will show on your laptop/primary monitor. This way, the command window is always visible whilst the psychtoolbox screen is open, so you can see any errors or outputs, and also you can force close the script without the whole software crashing, by doing the following:
	1. Press alt+tab to switch back to matlab 
	2. Press ctrl+c a few times
	3. Type sca and press enter. Or, if it doesn't type into the command window yet, you need to press ctrl+c a few more times. sca means "screen close all" and it tells psychtoolbox to force-close its windows.
- If you install PTB and matlab and gstreamer on a new pc, make a note of the versions of all those things you use
- If you don't have two screens, set the psychtoolbox window size to just a section of the screen, e.g. [0 0 800 600] instead of [0 0 1920 1080].

## Using the dynamometer and biopac
The squeezy handle is called a dynamometer. The thing it is plugged into is called an MP150 or MP160 data acquisition device (we have some of both models) but for simplicity we just call them a "biopac" which is the name of the company that makes all this stuff.

### Biopac gain settings
The gain setting can be changed between 50, 200, 1000, and 5000 using the switch on the front of the biopac.

To see what changing the gain does, close matlab, open the biopac software (Acqknowledge), start recording, and try squeezing the handle at each of the different gain settings. It won't cause any damage to change the gain during recording. 

With some setups, using 1000 or 5000 gain will clip off the top of hard squeezes, so it's best to avoid using these for your experiment. Other than that, people seem to have no particular reason for choosing between 50 or 200 gain - just make sure your choice is consistent across all participants otherwise it will be more difficult to compare/analyse.
