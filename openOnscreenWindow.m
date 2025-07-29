function [screen] = openOnscreenWindow(ex)

    % this function expects these variables in ex:
    % ex.display.screenRect
    % ex.display.backgroundColour
    % ex.display.textSize 
    % ex.display.textFont
       
    % open a window, get the width and height
    screen.scrNum = max(Screen('Screens'));  % this makes it displays always on the primary monitor I think
    [screen.window, screen.windowRect] = PsychImaging('OpenWindow', screen.scrNum, ex.display.backgroundColour, ex.display.screenRect); % TODO do we even need to keep windowRect in screen?
    screen.width = screen.windowRect(3);
    screen.height = screen.windowRect(4);
    screen.ifi = Screen('GetFlipInterval', screen.window);  % get the frame duration. not sure this is used anywhere - print as a check, or remove it?
    screen.frameRate = Screen('NominalFrameRate', screen.window);  % "Datapixx frame rate -- decide how to not mix up with PC screen FR"

    % sync stuff
    Screen('Preference','SyncTestSettings', 0.01, 40, 0.2, 5); % sets more forgiving test parameters which removes the flashing warning triangle - see psychtoolbox.org/docs/SyncTrouble
    Screen('Preference', 'SkipSyncTests', ex.debug); % skip sync tests iff debug mode

    % set the default text size and font
    Screen('TextSize', screen.window, ex.display.textSize);
    Screen('TextFont', screen.window, ex.display.textFont);

    % set to the maximum possible priority level (??)
    topPriorityLevel = MaxPriority(screen.window);  
    Priority(topPriorityLevel);

    % Enable alpha blending for anti-aliasing (motion smoothing when drawn objects move around)
    Screen('BlendFunction', screen.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    % so that keypresses (e.g. ttttttttttt from the scanner) will not show in command window
    ListenChar(2);
    HideCursor(screen.window);

end