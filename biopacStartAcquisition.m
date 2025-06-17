function startTime = biopacStartAcquisition(ex)

    % attempt to setup for acquisition start
    msg = calllib('mpdev', 'startMPAcqDaemon');
    if ~strcmp(msg, 'MPSUCCESS')
        sca;
        error('Failed to start dynamometer acquisition daemon: %s', msg);
    end

    % attempt to start acquisition
    msg = calllib('mpdev', 'startAcquisition');
    if ~strcmp(msg, 'MPSUCCESS')
        sca; 
        calllib(ex.biopac.mplib, 'disconnectMPDev');
        error('Failed to start dynamometer acquisition: %s', msg);
    end
    
    startTime = GetSecs; 

end