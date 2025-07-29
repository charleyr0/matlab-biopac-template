% Clear the workspace and the screen
sca;
clear all;
close all;
clearvars;

%% Variables

% participant info
data.participant.id = 101;                
data.participant.session = 1; 
data.participant.code = string(data.participant.id) + '_' + string(datetime('now', 'Format', 'yyyy-MM-dd'));
filename = [num2str(data.participant.code), '-', num2str(data.participant.session), '.mat'];

% set these to 0 or 1 and use them to decide whether to run particular things
ex.debug = 1;
ex.usingDynamometer = 1;
ex.usingEyelink = 0;
ex.usingScanner = 0;

% a prompt will be given asking you to check that it's set to this gain
biopacGain = 200;      

% create data folder if it doesn't exist
dataFolderName = 'data';
if ~isfolder(dataFolderName), mkdir(dataFolderName); end

% add subfolders containing matlab scripts to path so they can be found by other functions
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
ex.display.screenRect = [0 0 800 600]; % [0 0 800 600] is a small window - [0 0 1920 1080] is usually full screen
ex.display.textSize = 35;
ex.display.textFont = 'Arial';

% variables about the biopac and squeezing           
ex.biopac.barHeightPixels = 300; % height of the bar in pixels

% keyboard
KbName('UnifyKeyNames');
ex.keys.escapeKey = KbName('ESCAPE');
ex.keys.scannerTriggerKey = KbName('t');
ex.keys.acceptedKeys = KbName('space');
ex.keys.progressKey = KbName('space'); % to continue after instructions

% save the ex variable - it shouldn't change now throughout the experiment
save([dataFolderName, '/', filename], 'data', 'ex');


%% Run checks and setup before the experiment

% setup psychtoolbox
PsychDefaultSetup(2); 
% TODO add something with datapixx2 for MRI (??)

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

%% Run squeeze calibration
if ~ex.debug && ex.usingDynamometer
    waitForY('> Are you ready to start calibration (y/n)? ');
    screen = openOnscreenWindow(ex);

    [ex.mvc, calibSqueezeData] = squeezeCalibration(ex, screen);
    mvc = ex.mvc; % as a shorter way of typing it in future

    data.calibSqueezeData = calibSqueezeData;
    save([dataFolderName, '/', filename], 'data', 'ex', 'screen');

    disp(ex.mvc);
    ShowCursor(screen.window);
    sca; ListenChar(0);

else
    ex.mvc = 1;
end

%% Run main task
waitForY('> Are you ready to start the main task (y/n)? ');
screen = openOnscreenWindow(ex);    % open a PTB screen with pre-specified parameters
fixation(screen, 1);                % 1s fixation cross
data = mainTask(ex, screen);        % run main task
sca;                                % close PTB screen
save([dataFolderName, '/', filename], 'data');

%% End of script
sca;
