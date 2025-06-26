function [mvc, allSqueezeData] = squeezeCalibration(ex, screen)
    
    % This function runs the squeeze calibrations and returns the MVC
    % as a decimal number and a 3 arrays containing all of the squeeze data
    % collected throughout their 3 squeeze attempts.
    
    % Fields in ex that are required by this function:
    %
    % ex.calib.text
    %  This should be 1D array of 5 text strings. They will be
    %  written on the screen at different points throughout the calibration.
    %
    % ex.calib.textTime
    %  how long (secs) to display each instruction text for
    %
    % ex.calib.goals
    %  the heights of the yellow bar (as a multiplier of their initial 
    %  attempt's max value) on their 2nd and 3rd attempts
    %
    % ex.calib.initialSqueezeBarHeightDivisor
    %  if gain is 200 then a value of 4 works well for this
    
    % variable setup
    allSqueezeData = cell(3,1);  
    mvc = 0;
    heightDivisor = ex.calib.initialSqueezeBarHeightDivisor;
    
    % flip the intro text
    DrawFormattedText(screen.window, ex.calib.text{1}, 'center', 'center', ex.colours.white);
    Screen('Flip', screen.window);
    WaitSecs(ex.calib.textTime);
    
    % do the squeezes
    for i=1:3
    
        DrawFormattedText(screen.window, ex.calib.text{i+1}, 'center', 'center', ex.colours.white);
        Screen('Flip', screen.window);
        WaitSecs(ex.calib.textTime);
        
        forceData = squeeze(ex, screen, ex.colours.blue, ex.colours.white, ex.colours.yellow, heightDivisor, ex.calib.goals(i), 'Squeeze!', ex.calib.trialDuration);
        allSqueezeData{i} = forceData;
        mvc = max(mvc, max(forceData));

        if i==1 % just done first attempt - will adjust the 2nd/3rd squeezes relative to this one
            firstAttempt = max(forceData); 
            heightDivisor = firstAttempt; 
        end 

    end

    % flip final text
    DrawFormattedText(screen.window, ex.calib.text{5}, 'center', 'center', ex.colours.white);
    Screen('Flip', screen.window);
    WaitSecs(ex.calib.textTime);


end

