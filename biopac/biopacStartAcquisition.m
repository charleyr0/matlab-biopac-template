function startTime = biopacStartAcquisition()

    % attempt to setup for acquisition start
    msg = calllib('mpdev', 'startMPAcqDaemon');
    if ~strcmp(msg, 'MPSUCCESS')
        error('Failed to start dynamometer acquisition daemon: %s', msg);
    end

    % attempt to start acquisition
    msg = calllib('mpdev', 'startAcquisition');
    if ~strcmp(msg, 'MPSUCCESS')
        calllib('mpdev', 'disconnectMPDev');
        error('Failed to start dynamometer acquisition: %s', msg);
    end
    
    startTime = GetSecs; 

end