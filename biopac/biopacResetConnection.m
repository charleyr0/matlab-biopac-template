function restingSqueezeValue = biopacResetConnection(ex)

    % generally there is no need to unload the library, but if you
    % want to, just enter this in the command window:
    % unloadlibrary('mpdev');

    % the xerces-c_3_1.dll is required to also be in the biopac folder,
    % otherwise matlab can't find the mpdev.dll for some reason.

    % load the .dll and C file that contain the commands for communicating
    % with the biopac. These will be used here and in later communications
    % with the biopac.
    if ~libisloaded('mpdev')
        loadlibrary('mpdev.dll','mpdev.h');
    end

    % disconnect then reconnect
    calllib('mpdev', 'disconnectMPDev');   
    [msg, ~] = calllib('mpdev','connectMPDev', 103, 11,'auto');
 
    % if the returned msg is not MPSUCCESS, then it's an error - print it (and stop running)
    if ~strcmp(msg,'MPSUCCESS') 
        error('Failed to initialise biopac: %s', msg);
    end

    disp("Biopac connection was successful!");
    calllib('mpdev', 'setSampleRate', 0.5); % ms between samples
    calllib('mpdev', 'setAcqChannels', int32([1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));  % just want the first channel

    % poll 1s of squeeze data to return, for checking the resting value
    acquisitionStartTime = biopacStartAcquisition();
    [squeezeData, ~] = biopacListen(ex, acquisitionStartTime, 1, [], []);
    biopacEndAcquisition();
    restingSqueezeValue = mean(squeezeData);
    
end