function drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeBarHeight, targetLineHeight, cueText)

    % this function should only be called by squeeze.m

    % this functions draws and flips the squeezing screen
    % and should be called continuously with the varying levels of
    % height while they are collected from the dynamometer during a squeeze
    
    % if you don't want a target line to appear (e.g., for their very first
    % calibration attempt), pass 0 as the targetLineHeight.

    
    % this line restricts the minimum height between 0 and 1.5 
    %   0 because sometimes at rest it is very slightly negative
    %   1.5 because higher than that overshoots the bar
    squeezeBarHeight = max(0, min(1.5, squeezeBarHeight)); 

    % draw the bar outline
    Screen('FrameRect', screen.window, outlineColour, [screen.x0-25 screen.y0-150 screen.x0+25 screen.y0+150], 4);

    % draw the bar
    Screen('FillRect', screen.window, barColour, [screen.x0-25 screen.y0+150-squeezeBarHeight*200 screen.x0+25 screen.y0+150]);  % These are the coordinates for the Force Feedback Bar; Original height*S
    
    % draw the target level (yellow line)
    if targetLineHeight ~= 0
        Screen('DrawLines', screen.window,[ -25-50/8 +25+50/8 ; 150-targetLineHeight*200 150-targetLineHeight*200], 7, targetLineColour, [screen.x0 screen.y0], 0);
    end
    
    % draw some cue text above the bar (e.g. "GO!")
    DrawFormattedText(screen.window, cueText, 'center', screen.y0-200, ex.colours.white);

    Screen('Flip',screen.window); 

end