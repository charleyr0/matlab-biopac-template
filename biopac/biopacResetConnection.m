function restingSqueezeValue = biopacResetConnection(dir, ex)

    % generally there is no need to unload the library, but if you
    % want to, just enter this in the command window:
    % unloadlibrary('mpdev');

    % load the .dll and C file that contain the commands for communicating
    % with the biopac. These will be used here and in later communications
    % with the biopac.
    if ~libisloaded('mpdev')
        loadlibrary([dir '/mpdev.dll'],[dir '/mpdev.h']);
    end

    % disconnect then reconnect
    calllib('mpdev', 'disconnectMPDev');              
    [msg, ~] = calllib('mpdev','connectMPDev', 103, 11,'auto');
 
    % if the returned msg is not MPSUCCESS, then it's an error - print it (and stop running)
    if ~strcmp(msg,'MPSUCCESS') 
        error('Failed to initialise biopac: %s', msg);
    end

    disp("Biopac connection was successful!");
    calllib('mpdev', 'setSampleRate', 1000/ex.biopac.sample_rate); % ms between samples
    calllib('mpdev', 'setAcqChannels', int32([1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]));  % which of 16 channels?

    % poll 1s of squeeze data to return
    acquisitionStartTime = biopacStartAcquisition(ex);
    [squeezeData, ~] = biopacListen(ex, acquisitionStartTime, 1, [], []);
    biopacEndAcquisition();
    restingSqueezeValue = mean(squeezeData);
    
end