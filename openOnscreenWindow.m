function [screen] = openOnscreenWindow(ex)

    % this function expects some variables in ex -
    % ex.display.textSize and ex.display.textFont
    % for setting the default text settings for new the window this opens
    
    % setup the display
    screen.scrNum = max(Screen('Screens'));  % displays always on the primary monitor I think

    % sync stuff
    Screen('Preference','SyncTestSettings', 0.01, 40, 0.2, 5); % sets more forgiving test parameters which removes the flashing warning triangle - see psychtoolbox.org/docs/SyncTrouble
    Screen('Preference', 'SkipSyncTests', 0);
    
    % open a window
    [screen.window, screen.windowRect] = PsychImaging('OpenWindow', screen.scrNum, ex.display.backgroundColour, ex.display.screenRect);
    
    % Get the centre coordinate of the window in pixels
    [screen.x0, screen.y0] = RectCenter(screen.windowRect);
    
    % Enable alpha blending for anti-aliasing
    Screen('BlendFunction', screen.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    screen.ifi = Screen('GetFlipInterval', screen.window);  % query the frame duration
    screen.refRate = 1 / screen.ifi; % query the frame refresh rate (Hz)
    screen.FRDatapixx = Screen('NominalFrameRate', screen.window);  % Datapixx frame rate -- decide how to not mix up with PC screen FR
    [screen.WinXpix, screen.WinYpix] = Screen('WindowSize', screen.window);  % size of the on screen window 
    topPriorityLevel = MaxPriority(screen.window);  % retreive the maximum priority for this program 
    Priority(topPriorityLevel);
    
    % set the default text size and font
    Screen('TextSize', screen.window, ex.display.textSize);
    Screen('TextFont', screen.window, ex.display.textFont);
    
    % so that keypresses (e.g. ttttttttttt from the scanner) will not show in command window
    ListenChar(2);
    HideCursor(screen.window);

end