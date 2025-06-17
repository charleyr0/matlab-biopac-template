% Clear the workspace and the screen
sca;
clear all;
close all;
clearvars;

%% Variables

% experiment variables
data.pptID = 101;                
data.session = 1; 
data.code = string(data.pptID) + '-' + string(datetime('now', 'Format', 'ddMMyy'));          % e.g. would be 101-010225 , if pptID = 101 on 01/02/25
data.filename = [num2str(data.code), '_', num2str(data.session), '_', '_data.mat'];      % e.g. would be 101-010225_1_data.mat , if session = 1 with the above

debug = 0;                        % if debug = 1, will run a minimal version of the experiment
biopacGain = 200;                 % a prompt will be given to check that it's set to this gain
scannerTriggerKey = KbName('t');  % waits for this trigger from the scanner before starting the main task   

% folder setup
dataFolderName = 'data';          % data collected from the experiment will be stored in this folder
biopacFolderName = 'files';       % the folder containing the mpdev (biopac) files, .dll, mex files - anything that's not a matlab script
imgsFolderName = 'assets';        % the folder containing images etc used in the experiment

%% Setup

% prompt manual checks
if debug
    input('Running in debug mode - PRESS ENTER to continue...'); 
end

% force to run from the experiment's own directory to avoid potential errors
[scriptDir,~,~] = fileparts(mfilename('fullpath'));
currentDir = pwd;
if ~strcmp(scriptDir, currentDir)
    cd(scriptDir);
    disp("Changed directory to the script's directory");
end

% check that the folders actually exist - we could just make them here if they don't exist already, but 
% more likely the user has mistyped the name so perhaps throwing an error is more appropriate
if ~exist(dataFolderName, 'dir'), disp("!! The '%s' folder you specified doesn't exist!", dataFolderName); end
if ~exist(biopacFolderName, 'dir'), disp("!! The '%s' folder you specified doesn't exist!", biopacFolderName); end
if ~exist(imgsFolderName, 'dir'), disp("!! The '%s' folder you specified doesn't exist!", imgsFolderName); end

% set path to experiment folder
% Added by Selma to avoid conflicting paths/functions
addpath(scriptDir, '-begin');

% Seed the random number generator
rng('shuffle');

% setup psychtoolbox
PsychDefaultSetup(2); 

%% Setup - ex
ex.biopac.mplib = 'mpdev';
ex.biopac.sample_rate = 500; 
ex.biopac.barColourCalibration = [0 0 255];    % set colour of force-meter (blue) titration and initial squeezes
ex.biopac.ForceColour_ef = [255 0 0];          % set colour of force-meter (red) effort decisions
ex.biopac.barHeight = 300;                     % set height of bar in pixels
ex.biopac.forceLevels = [.49 .56 .63 .70];     % effort levels
ex.biopac.forceLevels_x = [.61 .89 1.11 1.29]; % multiplication for visualization of target bar in drawResonseFlip
ex.biopac.forceLength = 1;                     % set length of time at which force should be above threshold
ex.biopac.forceLength_lh = 3;                  % set length of time at which force should be above threshold
ex.biopac.barmaxforce = 1;                     % set relative height of the force-bar (as %MVC)                  
ex.biopac.titrationResponseDuration = 3;       % how long are titration trials?
ex.biopac.effortTime = 3;                      % how long is the effort window for decisions

% define some colours, to use later without typing out the full colour code
ex.colours.white = 1;
ex.colours.black = 0;
ex.colours.yellow = [255 255 0];
ex.colours.red = [255, 0, 0] / 255;
ex.colours.green = [20, 244, 4] / 255;
ex.colours.blue = [28, 4, 244] / 255;

% some display settings - these are used by openOnScreenWindow for setting up the screen
ex.display.backgroundColour = ex.colours.black;
ex.display.screenRect = [0 0 1920 1080]; %screen.fullScrn = [(1920/2)+100 200 1920-200 1080-200]
ex.display.textSize = 35;
ex.display.textFont = 'Arial';

% variables used for the squeeze calibration
ex.calib.initialSqueezeBarHeightDivisor = 4;  % scales the bar down - depends on your gain - 4 is good for 200 gain; lower for 50 gain; you probably shouldn't use 1000 or 5000
ex.calib.goals = [0, 1.1, 1.05];              % the heights of the yellow bar (as a multiplier of their initial attempt's max value) on their 3 attempts. 1st one should be 0 (which will draw no bar)
ex.calib.textTime = 2;                        % how long (secs) to display each instruction text for
ex.calib.text = {                             % the prompts to show throughout the calibration procedure
  'You will now complete a short procedure to\n \n determine your maximum grip strength.',...
  'Get ready to squeeze as strongly as you can...',...
  'Now try to reach the yellow line!', ...
  'Try one last time!', ...
  'Well done! Please wait for the next instructions.'};

% how long to wait before closing the screen at the end of each part of the task
ex.screenEndWaitTime = 4;

% keyboard
KbName('UnifyKeyNames');
ex.escapeKey = KbName('ESCAPE');
ex.timingKey = KbName('t');
ex.acceptedKeys = KbName('space');
ex.progressKey = KbName('space'); % to continue after instructions
% add something with datapixx2 for MRI

%% Start the program

% initialise dynamometer
disp("Resetting the biopac connection...");
restingSqueezeValue = biopacResetConnection(biopacFolderName, ex);
fprintf('Resting squeeze value just measured from the handle = %0.3f\n', restingSqueezeValue);
input(sprintf('Set biopac gain to %d then press ENTER to continue...', biopacGain));

% move cursor to commandwindow so in case of crash you can type ctrl c there
commandwindow

% run squeeze calibration
if ~debug
    waitForY('\nAre you ready to start calibration (y/n)? ');
    screen = openOnscreenWindow(ex); % open a PTB screen with pre-specified parameters
    [~, calibSqueezeData] = squeezeCalibration(ex, screen);
    data.calibSqueezeData = calibSqueezeData;
    save([dataFolderName, '/', data.filename], 'data', 'ex', 'screen');

    ShowCursor(screen.window);
    sca; ListenChar(0);
end

% disconnect dynamometer
unloadlibrary('mpdev'); 



