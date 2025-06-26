function [forceData, success] = squeeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeBarHeightDivisor, targetLineHeight, cueText, trialDuration, goal, timeAboveForSuccess)
   
    % TODO the squeezeBarHeightDivisor and the goal should come from the
    % same thing (only keep goal probably?)
    
    % runs a squeeze - deals with the biopac (but 
    % the acquisition daemon must already be running)
    % and the displaying by calling drawSqueeze, then
    % returns a long list of numbers, which is the continuous
    % squeeze data throughout the trial

    % for goal, pass e.g. 0.5 if you want this squeeze to be at 50% of MVC
    % or if it's calibration / you don't care about this, just pass goal=0 to skip

    assert(squeezeBarHeightDivisor~=0, "The squeezeBarHeightDivisor cannot be 0. Perhaps you meant to set it to 1?");
    
    % Tell the biopac we want to start acquiring data now
    acquisitionStartTime = biopacStartAcquisition();

    % Run the squeeze
    fbfunc = @(f) drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, f()/squeezeBarHeightDivisor, targetLineHeight, cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, trialDuration, [], fbfunc);

    biopacEndAcquisition();

    % decide whether they succeeded, i.e. got over the line for long enough
    if goal ~= 0 
        goalValue = goal * ex.calib.mvc;
        timeAboveGoal = sum(forceData > goalValue)/length(forceData) * trialDuration;
        success = (timeAboveGoal >= timeAboveForSuccess); % i.e. if RHS is true then success=1 else success=0
    end
    
end