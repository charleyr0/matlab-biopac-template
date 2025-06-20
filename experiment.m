% Clear the workspace and the screen
sca;
clear all;
close all;
clearvars;

%% Folder setup
dataFolderName = 'data';          % data collected from the experiment will be stored in this folder
assetsFolderName = 'assets';      % the folder containing any images etc used in the experiment

% create a folder for the data to be saved in, if it doesn't exist yet
if ~isfolder(dataFolderName), mkdir(dataFolderName); end

% add subfolders (containing matlab scripts) to path, so that they can be
% referenced more easily by the other scripts in this experiment
addpath(fullfile(pwd, 'biopac'));

% force to run from the experiment's own directory to avoid potential errors
[scriptDir,~,~] = fileparts(mfilename('fullpath'));
currentDir = pwd;
if ~strcmp(scriptDir, currentDir)
    cd(scriptDir);
    disp("Changed directory to the script's directory");
end

%% Data variables

% experiment variables
data.participant.id = 101;                
data.participant.session = 1; 
data.participant.code = string(data.participant.id) + '-' + string(datetime('now', 'Format', 'ddMMyy'));    % e.g. would be 101-010225 , if pptID = 101 on 01/02/25
filename = [num2str(data.participant.code), '-', num2str(data.participant.session), '-data.mat'];      % e.g. would be 101-010225-1-data.mat , if session = 1 with the above

% set these to 0 or 1 and use them to decide whether to run particular things
ex.debug = 0;
ex.usingDynamometer = 1;
ex.usingEyetracker = 0;

% a prompt will be given asking you to check that it's set to this gain
biopacGain = 200;                 

%% Setup - ex
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
ex.colours.white =  [255 255 255] / 255;
ex.colours.black =  [0 0 0] / 255;
ex.colours.grey =   [130 130 130] / 255;
ex.colours.yellow = [255 255 0] / 255;
ex.colours.red =    [255 0 0] / 255;
ex.colours.green =  [20 244 4] / 255;
ex.colours.blue =   [28 4 244] / 255;

% some display settings - these are used by openOnScreenWindow for setting up the screen
ex.display.backgroundColour = ex.colours.grey;
ex.display.screenRect = [0 0 1920 1080]; %screen.fullScrn = [(1920/2)+100 200 1920-200 1080-200]
ex.display.textSize = 35;
ex.display.textFont = 'Arial';

% variables used for the squeeze calibration
ex.calib.initialSqueezeBarHeightDivisor = 2;  % scales the bar down - depends on your gain - 4 is good for 200 gain; 2 for 50 gain; do not use 1000 or 5000 gain with the dynamometer (too high)
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
ex.scannerTriggerKey = KbName('t');
ex.acceptedKeys = KbName('space');
ex.progressKey = KbName('space'); % to continue after instructions
% TODO add something with datapixx2 for MRI (??)

% setup psychtoolbox
PsychDefaultSetup(2); 

%% Run checks and setup before the experiment

% move cursor to commandwindow so in case of crash you can type ctrl c there
commandwindow

% prompt manual checks
input(sprintf('> Press enter to confirm: \n  ID = %d  Code = %s  Session = %d', data.participant.id, data.participant.code, data.participant.session));
input(sprintf('> Press enter to confirm (1=on, 0=off): debug = %d, dynamometer = %d', ex.debug, ex.usingDynamometer));

% initialise dynamometer
if ex.usingDynamometer
    fprintf("> Resetting the biopac connection... ");
    restingSqueezeValue = biopacResetConnection(ex);
    fprintf('> Resting squeeze value just measured from the handle = %0.3f\n', restingSqueezeValue);
    input(sprintf('> Set biopac gain to %d then press ENTER to continue...', biopacGain));
end

%% Start the experiment

% run squeeze calibration
if ~ex.debug && ex.usingDynamometer
    waitForY('> Are you ready to start calibration (y/n)? ');
    screen = openOnscreenWindow(ex); % open a PTB screen with pre-specified parameters
    [~, calibSqueezeData] = squeezeCalibration(ex, screen);
    data.calibSqueezeData = calibSqueezeData;
    save([dataFolderName, '/', filename], 'data', 'ex', 'screen');

    ShowCursor(screen.window);
    sca; ListenChar(0);
end

% run main task
waitForY('> Are you ready to start the main task (y/n)? ');
screen = openOnscreenWindow(ex); % open a PTB screen with pre-specified parameters

%% End of script

% save data
% TODO

% unload the dynamometer library
if libisloaded('mpdev'), unloadlibrary('mpdev'); end
