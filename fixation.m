function fixation(screen)

% Define fixation cross properties
fixationSize = 20; % Length of cross arms in pixels
fixationWidth = 3; % Thickness of cross lines

% Draw horizontal line of fixation cross
Screen('DrawLine', screen.window, screen.white, ...
    screen.x0 - fixationSize/2, screen.y0, ...
    screen.x0 + fixationSize/2, screen.y0, ...
    fixationWidth);

% Draw vertical line of fixation cross
Screen('DrawLine', screen.window, screen.white, ...
    screen.x0, screen.y0 - fixationSize/2, ...
    screen.x0, screen.y0 + fixationSize/2, ...
    fixationWidth);

% Flip the screen to show the fixation cross
Screen('Flip', screen.window);