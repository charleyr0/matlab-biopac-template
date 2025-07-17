function [forceData, success] = squeeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeBarHeightDivisor, goal, cueText, trialDuration, timeAboveForSuccess)
       
    % runs a squeeze - deals with the biopac (but 
    % the acquisition daemon must already be running)
    % and the displaying by calling drawSqueeze, then
    % returns a long list of numbers, which is the continuous
    % squeeze data throughout the trial

    % PARAMETERS:
    % barColour                     the squeeze bar, usually blue or red
    % outlineColour                 the bar outline, usually white
    % targetLineColour              the goal line, usually yellow
    % squeezeBarHeightDivisor       e.g. if this is 0.5, then they would need to squeeze at 50% of the mvc to fill the bar to maximum
    % goal                          e.g. use 0.5 if you want this squeeze to be at 50% of MVC
    % cueText                       usually 'GO!' or blank
    % trialDuration                 in seconds
    % timeAboveForSuccess           how many seconds they need to hold above the line to count as a successful trial

    % Run the squeeze
    acquisitionStartTime = biopacStartAcquisition();
    fbfunc = @(f) drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, f()/squeezeBarHeightDivisor, goal/squeezeBarHeightDivisor, cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, trialDuration, [], fbfunc);
    biopacEndAcquisition();

    % decide whether they succeeded, i.e. got over the line for long enough
    goalValue = goal * ex.calib.mvc;                                                % bc goal is a multiplier of their mvc
    timeAboveGoal = sum(forceData > goalValue)/length(forceData) * trialDuration;   % (proportion of time above target line) * (total trial seconds)
    success = (timeAboveGoal >= timeAboveForSuccess);                               % i.e. if RHS is true then success=1 else success=0

    
end