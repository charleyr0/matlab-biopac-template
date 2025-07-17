function drawSqueeze(ex, screen, squeezeLevel, barColour, outlineColour, targetLineColour, barScaleFactor, targetLevel, cueText)

    % this function should only be called by squeeze.m

    % this functions draws and flips the squeezing screen
    % and should be called continuously with the varying levels of
    % height while they are collected from the dynamometer during a squeeze
    
    % if you don't want a target line to appear (e.g., for their very first
    % calibration attempt), pass 0 as the targetLineHeight.

    barHeight = ex.biopac.barHeightPixels; % height of the white outline bar not the squeeze bar TODO store barHeight/2 instead

    % this line adjusts their squeeze level to fit into the bar -
    % first it restricts the minimum height between 0 and 1.5 
    %   0 because sometimes at rest it is very slightly negative
    %   1.5 because higher than that overshoots the bar
    % then scales it to the absolute bar height and the scale factor

    % squeezeLevel adjustments
    squeezeLevel = squeezeLevel * barHeight * barScaleFactor; % scale the raw value to fit the onscreen bar
    squeezeLevel = max(0, squeezeLevel); % if it's negative, set it to 0
    squeezeLevel = min(squeezeLevel, barHeight); % if it would overshoot the outline, cap it at the outline's height

    % draw the bar outline
    Screen('FrameRect', screen.window, outlineColour, [(screen.width/2)-25 (screen.height/2)-(barHeight/2) (screen.width/2)+25 (screen.height/2)+(barHeight/2)], 4);

    % draw the squeeze bar
    baseLine = (screen.height/2)+(barHeight/2); % y of bottom of bar outline
    Screen('FillRect', screen.window, barColour, [(screen.width/2)-25 baseLine-squeezeLevel (screen.width/2)+25 baseLine]);  % These are the coordinates for the Force Feedback Bar; Original height*S
    
    % draw the target level (yellow line)
    % targetLineLevel is e.g. 0.5 for 50% of their MVC
    if targetLevel ~= 0
        x1 = (screen.width/2) -25-50/8 ;
        x2 = (screen.width/2) +25+50/8 ;
        y = baseLine - targetLevel * barHeight * barScaleFactor;
        Screen('DrawLines', screen.window, [x1 x2 ; y y], 7, targetLineColour);
    end
    
    % draw some cue text above the bar (e.g. "GO!")
    DrawFormattedText(screen.window, cueText, 'center', (screen.height/2)-200, ex.colours.white);

    Screen('Flip',screen.window); 

end