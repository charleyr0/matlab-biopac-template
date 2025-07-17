function [forceData, success] = squeeze(ex, screen, barColour, outlineColour, targetLineColour, barScaleFactor, targetLevel, cueText, trialDuration, timeAboveForSuccess)
      
    % runs a squeeze - handles the biopac (but the connection must 
    % already be open - which is done in biopacResetConnection)
    % and handles the display by calling drawSqueeze, then
    % returns a long list of numbers, which is the continuous
    % squeeze data throughout the trial

    % if it's the calibration, so you don't want a target line, then use 0
    % for the target height and it won't draw a target line

    assert(barScaleFactor~=0, "The squeezeBarHeightDivisor cannot be 0. Perhaps you meant to set it to 1?");
    
    % Tell the biopac we want to start acquiring data now
    acquisitionStartTime = biopacStartAcquisition();

    % Run the squeeze
    fbfunc = @(f) drawSqueeze(ex, screen, f()/barScaleFactor, barColour, outlineColour, targetLineColour, barScaleFactor, targetLevel, cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, trialDuration, [], fbfunc);

    biopacEndAcquisition();

    % decide whether they succeeded, i.e. got over the line for long enough
    if targetLevel ~= 0 
        goalValue = targetLevel * ex.calib.mvc; % get the actual value for the squeeze, from (the target % of their MVC) * (their MVC actual value)
        timeAboveGoal = sum(forceData > goalValue)/length(forceData) * trialDuration;
        success = (timeAboveGoal >= timeAboveForSuccess); % i.e. if RHS is true then success=1 else success=0
    end
    
end