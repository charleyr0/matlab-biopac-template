function drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeLevel, targetLineLevel, cueText)

    % this function should only be called by squeeze.m

    % this functions draws and flips the squeezing screen
    % and should be called continuously with the varying levels of
    % height while they are collected from the dynamometer during a squeeze
    
    % if you don't want a target line to appear (e.g., for their very first
    % calibration attempt), pass 0 as the targetLineHeight.

    barHeight = ex.biopac.barHeightPixels; % height of the white outline bar not the squeeze bar TODO store barHeight/2 instead

    % this line restricts the minimum height between 0 and 1.5 
    %   0 because sometimes at rest it is very slightly negative
    %   1.5 because higher than that overshoots the bar
    %   then scale it to the absolute bar height
    squeezeLevel = max(0, min(1.5, squeezeLevel)) * barHeight; 
    % squeezeLevel used o then by multiplied by a barMaxForce which was set to 0.9

    % draw the bar outline
    Screen('FrameRect', screen.window, outlineColour, [(screen.width/2)-25 (screen.height/2)-(barHeight/2) (screen.width/2)+25 (screen.height/2)+(barHeight/2)], 4);

    % draw the bar
    baseLine = (screen.height/2)+(barHeight/2); % y of bottom of bar outline
    Screen('FillRect', screen.window, barColour, [(screen.width/2)-25   baseLine-squeezeLevel   (screen.width/2)+25   baseLine]);  % left up right down
    
    % draw the target level (yellow line)
    if targetLineLevel ~= 0
        x1 = (screen.width/2) -25-50/8 ;
        x2 = (screen.width/2) +25+50/8 ;
        y = baseLine - targetLineLevel*barHeight;
        Screen('DrawLines', screen.window, [x1 x2 ; y y], 7, targetLineColour);
    end
    
    % draw some cue text above the bar (e.g. "GO!")
    DrawFormattedText(screen.window, cueText, 'center', (screen.height/2)-200, ex.colours.white);

    Screen('Flip',screen.window); 

end