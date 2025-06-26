function forceData = squeeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeBarHeightDivisor, targetLineHeight, cueText, trialDuration)
   
    % runs a squeeze - deals with the biopac (but 
    % the acquisition daemon must already be running)
    % and the displaying by calling drawSqueeze, then
    % returns a long list of numbers, which is the continuous
    % squeeze data throughout the trial

    assert(squeezeBarHeightDivisor~=0, "The squeezeBarHeightDivisor cannot be 0. Perhaps you meant to set it to 1?");
    
    % Tell the biopac we want to start acquiring data now
    acquisitionStartTime = biopacStartAcquisition();

    % Run the squeeze
    fbfunc = @(f) drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, f()/squeezeBarHeightDivisor, targetLineHeight, cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, trialDuration, [], fbfunc);

    biopacEndAcquisition();
    
end