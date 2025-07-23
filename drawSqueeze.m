function drawSqueeze(ex, screen, barColour, outlineColour, targetLineColour, squeezeLevel, mvc, maxHeightMult, goalMult, cueText)

    % this function gets called by squeeze.m

    % this functions draws and flips the squeezing screen
    % and should be called continuously with the varying levels of
    % height while they are collected from the dynamometer during a squeeze

    barHeight = ex.biopac.barHeightPixels; % height of the white outline bar

    % this scales the squeeze to their mvc and the height of the bar
    % it first restricts to 0 bc sometimes at rest the value is slightly negative
    squeezeLevel = max(0, min(1, squeezeLevel/(mvc*maxHeightMult))) * barHeight; 
  
    % draw the bar outline
    Screen('FrameRect', screen.window, outlineColour, [(screen.width/2)-25 (screen.height/2)-(barHeight/2) (screen.width/2)+25 (screen.height/2)+(barHeight/2)], 4);

    % draw the squeeze
    baseLine = (screen.height/2)+(barHeight/2); % y of bottom of bar outline
    Screen('FillRect', screen.window, barColour, [(screen.width/2)-25   baseLine-squeezeLevel   (screen.width/2)+25   baseLine]);  % left up right down
    
    % draw the target level (yellow line)
    if goalMult ~= 0
        x1 = (screen.width/2) -25-50/8 ;
        x2 = (screen.width/2) +25+50/8 ;
        y = baseLine - (goalMult/maxHeightMult)*barHeight;
        Screen('DrawLines', screen.window, [x1 x2 ; y y], 7, targetLineColour);
    end
    
    % draw some cue text above the bar (e.g. "GO!")
    DrawFormattedText(screen.window, cueText, 'center', (screen.height/2)-200, ex.colours.white);

    Screen('Flip',screen.window); 

end