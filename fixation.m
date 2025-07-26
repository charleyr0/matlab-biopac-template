function fixation(ex, screen)

    % Define fixation cross properties
    colour = [1 1 1] % white
    width = 3;
    length = 20;

    % Draw horizontal line of fixation cross
    Screen('DrawLine', screen.window, colour, ...
        screen.width/2 - length/2, screen.height/2, ...
        screen.width/2 + length/2, screen.height/2, ...
        width);

    % Draw vertical line of fixation cross
    Screen('DrawLine', screen.window, ex.fixation.colour, ...
        screen.width/2, screen.height/2 - length/2, ...
        screen.width/2, screen.height/2 + length/2, ...
        width);

    % Flip the screen to show the fixation cross
    Screen('Flip', screen.window);

end