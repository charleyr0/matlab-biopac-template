function forceData = squeeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeBarHeightDivisor, targetLineHeight, cueText)
   
    % runs a squeeze - deals with the biopac (but 
    % the acquisition daemon must already be running)
    % and the displaying by calling drawSqueeze, then
    % returns the mvc and list of all squeeze levels.

    assert(squeezeBarHeightDivisor~=0, "The squeezeBarHeightDivisor cannot be 0. Perhaps you meant to set it to 1?");
    
    % Tell the biopac we want to start acquiring data now
    acquisitionStartTime = biopacStartAcquisition(ex);

    % Run the squeeze
    fbfunc = @(f) drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, f()/squeezeBarHeightDivisor, targetLineHeight, cueText); 
    [forceData, ~] = biopacListen(ex, acquisitionStartTime, ex.biopac.titrationResponseDuration, [], fbfunc);

    biopacEndAcquisition();
    
end