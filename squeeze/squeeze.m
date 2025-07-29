function [forceData, success] = squeeze(ex, screen, mvc, maxHeightMult, goalMult, cueText, trialDuration, timeAboveForSuccess, ~)
       
    % runs a squeeze - deals with the biopac (but 
    % the acquisition daemon must already be running)
    % and the displaying by calling drawSqueeze, then
    % returns a long list of numbers, which is the continuous
    % squeeze data throughout the trial

    % maxHeightMult                 e.g. if 1.5, then they would need to squeeze at 1.5x their MVC to fill the bar to maximum
    % goalMult                      e.g. use 0.5 if you want the goal to be 0.5x their MVC
    % cueText                       usually 'GO!' or blank
    % trialDuration                 in seconds
    % timeAboveForSuccess           how many seconds they need to hold above the line to count as a successful trial
    % ~                             this is the fakeSqueezeLevel but it's not used in this function

    barColour = [28 4 244] / 255;           % blue
    outlineColour = [255 255 255] / 255;    % white
    targetLineColour = [255 255 0] / 255;   % yellow

    % run the squeeze
    acquisitionStartTime = biopacStartAcquisition();
    fbfunc = @(f) drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, f(), mvc, maxHeightMult, goalMult, cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, trialDuration, [], fbfunc);
    biopacEndAcquisition();

    % decide whether they succeeded, i.e. got over the line for long enough
    goal = goalMult * mvc;                                                
    timeAboveGoal = sum(forceData > goal)/length(forceData) * trialDuration;        % (proportion of time above target line) * (total trial seconds)
    success = (timeAboveGoal >= timeAboveForSuccess);                               % i.e. if RHS is true then success=1 else success=0

end