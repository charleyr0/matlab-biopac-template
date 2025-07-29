function [forceData, success] = squeezeFake(ex, screen, mvc, maxHeightMult, goalMult, cueText, trialDuration, ~, fakeSqueezeLevel)

    % this takes the same parameters as the squeeze function
    % and also fakeSqueezeLevel e.g. if 0.7 then it will make a fake
    % squeeze at 0.7x the mvc

    barColour = [28 4 244] / 255;          % blue
    outlineColour = [255 255 255] / 255;   % white
    targetLineColour = [255 255 0] / 255;  % yellow

    drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, fakeSqueezeLevel*mvc/maxHeightMult, mvc, 1, goalMult/maxHeightMult, cueText); 
    WaitSecs(trialDuration);

    forceData = [];
    success = (fakeSqueezeLevel >= goalMult);
    
end

