function [screen] = openOnscreenWindow(ex)

    % this function expects some variables in ex -
    %
    % ex.display.screenRect
    %  e.g. [0 0 1920 1080] for fullscreen
    %
    % ex.display.backgroundColour
    %  e.g. screen.colours.grey
    %
    % ex.display.textSize 
    % ex.display.textFont
    %  for setting the default text settings for new the window this opens
    
    % setup the display
    screen.scrNum = max(Screen('Screens'));  % displays always on the primary monitor I think

    % sync stuff
    Screen('Preference','SyncTestSettings', 0.01, 40, 0.2, 5); % sets more forgiving test parameters which removes the flashing warning triangle - see psychtoolbox.org/docs/SyncTrouble
    Screen('Preference', 'SkipSyncTests', ex.debug); % skip sync tests iff debug mode
    
    % open a window, get the width and height
    [screen.window, screen.windowRect] = PsychImaging('OpenWindow', screen.scrNum, ex.display.backgroundColour, ex.display.screenRect); % TODO do we even need to keep windowRect in screen?
    screen.width = screen.windowRect(3);
    screen.height = screen.windowRect(4);
    
    % Enable alpha blending for anti-aliasing (motion smoothing when drawn objects move around)
    Screen('BlendFunction', screen.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    % get the frame duration. not sure this is used anywhere - print as a check, or remove it?
    screen.ifi = Screen('GetFlipInterval', screen.window);  

    % "Datapixx frame rate -- decide how to not mix up with PC screen FR"
    screen.frameRate = Screen('NominalFrameRate', screen.window);  
    
    % set to the maximum possible priority level (??)
    topPriorityLevel = MaxPriority(screen.window);  
    Priority(topPriorityLevel);
    
    % set the default text size and font
    Screen('TextSize', screen.window, ex.display.textSize);
    Screen('TextFont', screen.window, ex.display.textFont);
    
    % so that keypresses (e.g. ttttttttttt from the scanner) will not show in command window
    ListenChar(2);
    HideCursor(screen.window);

end