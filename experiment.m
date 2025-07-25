% Clear the workspace and the screen
sca;
clear all;
close all;
clearvars;

%% Folder setup
dataFolderName = 'data';          % data collected from the experiment will be stored in this folder
assetsFolderName = 'assets';      % the folder containing any images etc used in the experiment
if ~isfolder(dataFolderName), mkdir(dataFolderName); end

% add subfolders (containing matlab scripts) to path, so that they can be
% referenced more easily by the other scripts in this experiment
addpath(fullfile(pwd, 'biopac'));
addpath(fullfile(pwd, 'eyelink'));
addpath(fullfile(pwd, 'squeeze'));

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
ex.debug = 1;
ex.usingDynamometer = 1;
ex.usingEyelink = 0;
ex.usingScanner = 0;

% a prompt will be given asking you to check that it's set to this gain
biopacGain = 200;                 

%% Setup - ex

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
ex.display.screenRect = [0 0 800 600]; %screen.fullScrn = [(1920/2)+100 200 1920-200 1080-200]
ex.display.textSize = 35;
ex.display.textFont = 'Arial';

% variables about the biopac and squeezing
ex.biopac.barColourTrials = ex.colours.red;               
ex.biopac.trialDuration = 3;     
ex.biopac.squeezeTimeTotal = 3;
ex.biopac.squeezeTimeMin = 1;
ex.biopac.barHeightPixels = 300; % height of the bar in pixels

% keyboard
KbName('UnifyKeyNames');
ex.keys.escapeKey = KbName('ESCAPE');
ex.keys.scannerTriggerKey = KbName('t');
ex.keys.acceptedKeys = KbName('space');
ex.keys.progressKey = KbName('space'); % to continue after instructions
% TODO add something with datapixx2 for MRI (??)

% setup psychtoolbox
PsychDefaultSetup(2); 

%% Run checks and setup before the experiment

% move cursor to commandwindow so in case of crash you can type ctrl c there
commandwindow

% prompt manual checks
input(sprintf('> Press enter to confirm: \n  ID = %d  Code = %s  Session = %d', data.participant.id, data.participant.code, data.participant.session));
input(sprintf('> Press enter to confirm (1=on, 0=off): debug = %d, dynamometer = %d', ex.debug, ex.usingDynamometer));

% initialise dynamometer, if using
if ex.usingDynamometer
    fprintf("> Resetting the biopac connection...\n ");
    restingSqueezeValue = biopacResetConnection(ex);
    fprintf('> Resting squeeze value just measured from the handle = %0.3f\n', restingSqueezeValue);
    input(sprintf('> Set biopac gain to %d then press ENTER to continue...', biopacGain));
end

% initialise eyelink, if using
if ex.usingEyelink
    [success, ex.eyelinkSettings] = eyelinkInitialise(screen);
    if success, disp("> Eyelink initialised successfully"); end
    % TODO some other stuff in el_start - deal (here) with folder/files,
    % then look at el_defaults or somethn. when doing calib just call one
    % line
end

% initial datapixx projector, if using TODO not used yet
if ex.usingScanner
    PsychDataPixx('SetDummyMode', 0);
    PsychDataPixx('Open');
end

%% Start the experiment

% run squeeze calibration
if ~ex.debug && ex.usingDynamometer
    waitForY('> Are you ready to start calibration (y/n)? ');
    screen = openOnscreenWindow(ex);

    [ex.calib.mvc, calibSqueezeData] = squeezeCalibration(ex, screen);
    mvc = ex.calib.mvc; % as a shorter way of typing it in future

    data.calibSqueezeData = calibSqueezeData;
    save([dataFolderName, '/', filename], 'data', 'ex', 'screen');

    disp(ex.calib.mvc);
    ShowCursor(screen.window);
    sca; ListenChar(0);

else
    mvc = 0;
end

% run main task
waitForY('> Are you ready to start the main task (y/n)? ');
screen = openOnscreenWindow(ex, ); % open a PTB screen with pre-specified parameters
fixation(ex, screen);
WaitSecs(1);
GetSecs;

[forceData, success] = squeeze(ex, screen, mvc, 2, 0.5, 'Squeeze!', 3, 1);
fixation(ex, screen);
disp('Success =');
disp(success);
WaitSecs(1);

temp = GetSecs;
[forceData, success] = squeezeFake(ex, screen, mvc, 2, 0.5, 'Squeeze!', 3, 1, 0.6);
disp(GetSecs - temp);
fixation(ex, screen);
disp('Success =');
disp(success);
WaitSecs(1);

[forceData, success] = squeeze(ex, screen, mvc, 2, 0.5, 'Squeeze!', 3, 1);
fixation(ex, screen);
disp('Success =');
disp(success);
WaitSecs(1);

%% End of script
sca;

% save data
% TODO

% unload the dynamometer library TODO can we just leave it? so we don't
% have to load/unload on every run?
if libisloaded('mpdev'), unloadlibrary('mpdev'); end
