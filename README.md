# matlab-biopac-template
This is a minimal example experiment. Currently it includes just the calibration stage of an experiment.

## Requirements
Other working software combinations are available, but if you're downloading everything anyway, perhaps get the same versions that I am using to develop this:
- Matlab R2023b
- Psychtoolbox version 3.0.19.7
- gstreamer 1.22.5

## How to run
Run the experiment.m script in MATLAB.

## Using psychtoolbox
- When developing your task, use two monitors. Have the matlab editor window on the second monitor, and when you run the task it will show on your laptop/primary monitor. This way, the command window is always visible whilst the psychtoolbox screen is open, so you can see any errors or outputs, and also you can force close the script without the whole software crashing, by doing the following:
	1. Press alt+tab to switch back to matlab 
	2. Press ctrl+c a few times
	3. Type sca and press enter. Or, if it doesn't type into the command window yet, you need to press ctrl+c a few more times. sca means "screen close all" and it tells psychtoolbox to force-close its windows.
- If you install PTB and matlab and gstreamer on a new pc, make a note of the versions of all those things you use


## Things in this script
### 'ex' variable
This variable has lots of parts to it, organised into ex.display, ex.biopac, ex.calib, ex.task. These values are defined at the top of the experiment.m script.

## Using the dynamometer and biopac
The squeezy handle is called a dynamometer. The thing it is plugged into is called an MP150 or MP160 data acquisition device (we have some of both models) but for simplicity we just call them a "biopac" which is the name of the company that makes all this stuff.

### Biopac gain settings
The gain setting can be changed between 50, 200, 1000, and 5000 using the switch on the front of the biopac. You should use 50 or 200 gain for your experiment.

To see what changing the gain does, close matlab, open the biopac software (Acqknowledge), start recording, and try squeezing the handle at each of the different gain settings. It won't cause any damage to change the gain during recording. Notice that using 1000 or 5000 gain will clip off the top of hard squeezes, so don't use these.

### /biopac folder
In the biopac folder, there are 4 .m files which contain code that communicates with the mex files (also in this folder). Mex files are C code that can be run by matlab scripts, and these ones have been provided by Biopac to use when communicating between matlab and the devices.

The biopac scripts are called in experiment.m to reset, open, and close the connection to the biopac, and in squeeze.m to run a dynamometer squeeze. 

#### Calibration
The calibrateSqueezy.m file runs the calibration

### Using the scanner
When using the MRI scanner for your task, you will run the task on the stim PC in the control room. This PC received triggers from the scanner, which essentially means that a 't' on the keyboard is triggered with every TR. To sync up your task data with the scanner when analysing, your task will need to listen out for the first t keypress it receives from the scanner and make a note of when this happens, and then your main task can start running after this has been received.

You will hear a few volumes being collected before the scanner sends the first 't'.

## General advice
- When you start developing your task, make a note of the versions of matlab, psychtoolbox, and gstreamer you use to develop your task. If you ever have to run your task on a different setup (e.g. for MRI), you might have to make some slight adjustments to the layout of things.

### Programming style
If statements evaluate an expression to true (1) or false (0).
If you have a variable debug = 1, then doing "if debug == 1" is the same as "if debug" and
"if debug == 0" is the same as "if ~debug". The ~ means "not", so it checks whether debug is not 1.
