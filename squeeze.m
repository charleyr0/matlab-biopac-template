function [forceData, success] = squeeze(ex, screen, squeeze)
      
    % runs a squeeze - deals with the biopac (but 
    % the acquisition daemon must already be running)
    % and the displaying by calling drawSqueeze, then
    % returns a long list of numbers, which is the continuous
    % squeeze data throughout the trial

    % if it's the calibration / you don't want a target line, use 0 for the target height

    assert(squeezeBarHeightDivisor~=0, "The squeezeBarHeightDivisor cannot be 0. Perhaps you meant to set it to 1?");
    
    % Tell the biopac we want to start acquiring data now
    acquisitionStartTime = biopacStartAcquisition();

    % Run the squeeze
    fbfunc = @(f) drawSqueeze(ex, screen, squeeze.barColour, squeeze.barOutlineColour, squeeze.targetColour, f()/squeeze.barScaleFactor, squeeze.targetLevel, squeeze.cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, squeeze.trialDuration, [], fbfunc);

    biopacEndAcquisition();

    % decide whether they succeeded, i.e. got over the line for long enough
    if squeeze.targetLevel ~= 0 
        goalValue = squeeze.targetLevel * ex.calib.mvc; % get the actual value for the squeeze, from (the target % of their MVC) * (their MVC actual value)
        timeAboveGoal = sum(forceData > goalValue)/length(forceData) * squeeze.trialDuration;
        success = (timeAboveGoal >= squeeze.squeezeTimeForSuccess); % i.e. if RHS is true then success=1 else success=0
    end
    
end