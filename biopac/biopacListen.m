function [squeezeData, timeOfLastAcquisition] = biopacListen(ex, timeOfLastAcquisition, trialTime, ISI, drawingFunction)

    %  Function to stream data from squeezy device
    %  Requires the MP Acquisition daemon to be running
    %  Assumes that data is being collected from only 1 channel
    %  (i.e. just the squeezy, nothing plugged into the ethernet ports)
    %
    % 'squeezeData':
    %  1D array of all the force measurements recorded
    %
    % 'stopRecordingAtThreshold':
    %  The function will stop/return if/when the force exceed this level.
    %  Or, pass 0 to not use this condition.
    %
    % 'trialTime':
    %  How many seconds to listen for squeeze data for
    %
    % 'timeOfLastAcquisition':
    %  Needs to know the time of the last acquisition in order to calculate 
    %  how many samples to dequeue before starting this acquisition.
    %  The first time you call this in a trial, you should send the time that
    %  the acquisition started - i.e. acquisitionStartTime in squeezeCalibration.m
    %  Subsequent calls in the same trial should pass the value returned from
    %  this function 'timeOfLastAcquisition', to know how much data to de-queue, 
    %  but right now we use an anon function instead of constantly calling this 
    %  function throughout a trial. Finally, we also return "timeOfLastAcquisition" 
    %  which is the time that we last checked the MP150 stream. This is needed for further calls, 
    %
    %  'drawingFunction(currentForce)':
    %  A function that will be called repeatedly each time new samples
    %  are acquired. You can do the drawing in here. Pass [] to ignore.
    %
    % 'ISI'
    %  The calibration code just passes [] i.e. empty array. Maybe just
    %  remove this variable and replace with [] ?
    %
    % TODO it takes around 0.03s to start startBiopacAcquisition and 
    % 0.02s to endBiopacAcquisition - should we just do that in this script
    % to simplify code elsewhere? If not, how to catch and notify if this 
    % script is called while acquisition is not listening? ATM it just does
    % nothing and returns immediately.

    % calculate how many samples need to be read from the Biopac
    queueLen = @(lastread) 2 * floor((GetSecs-lastread) * ex.biopac.sampleRate);
    
    % set up recording buffer of 3 seconds, and buffer
    record = nan * zeros(ex.biopac.sampleRate * ISI, 1);
    lq = queueLen(timeOfLastAcquisition);
    buffer = nan * zeros(lq,1);

    % read data from the biopac
    [~, buffer, nread] = calllib('mpdev', 'receiveMPData', buffer, lq, 0);
    lastread = GetSecs;
    record(1:nread,1) = buffer(1:nread); % store both channels
    nTotalRead = nread; 

    %fprintf('err=%g',GetSecs-lastread);
    
    exitFlag = 0;
    startRecordingTime = GetSecs;
    while(GetSecs < startRecordingTime + trialTime && ~exitFlag)

        %%%% CHECK KEYPRESSES
        % % prints the keycode of any keys pressed (up to 4 simultaneously)
        % [keyisdown,~,keycode] = KbCheck; % check for real key
        % if keyisdown
        %     keys=find(keycode);
        %     disp(keys);
        % end
        
        %%%% POLL squeezes from MP150
        lq = queueLen(lastread); % required length of queue
    
        if(lq > 0) % if there is data in the queue?

            % extend buffer if needed
            if(lq > length(buffer)) 
                buffer=nan*zeros(lq,1); 
            end

            % read data from the biopac
            [~, buffer, nread] = calllib('mpdev', 'receiveMPData', buffer,lq,0);
            lastread = GetSecs;
            record((nTotalRead+1):(nTotalRead+nread),1) = buffer(1:nread);
            nTotalRead = nTotalRead + nread; % keep track of how many bytes read

            % if at least 20 bytes of force data have come through, this calculates the mean force from the last 20 force reads
            if nTotalRead > 20
                mu = mean(record((nTotalRead-20):nTotalRead)); % 20ms mean force

                % % if you like, you can make a int forceCutoff and if they
                % ever squeeze above this then the the function will return
                % immediately without waiting until the end of the trialTime
                % if any(mu > forceCutoff)
                %     exitFlag=1;
                % end

            end

        end

        %%%% display the bar
        if exist('mu','var') && ~isempty(drawingFunction) % i think the very first time, mu won't exist?
            %disp(mu); % uncomment if you want to have a look at every squeeze value
            drawingFunction(mu);
        end
    
    end
    
    squeezeData = record; % send back the actual data recorded
    timeOfLastAcquisition = lastread; % send back the time we last read the device

end