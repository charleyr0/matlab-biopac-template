function [success, eyetrackerSettings] = eyelinkInitialise(screen)
    
    eyetrackerSettings = EyelinkInitDefaults(screen.window);

    % EyelinkInit is a function that attempts to initialise the 
    % eyelink and return 1/0 for sucess/failure
    success = EyelinkInit; 

end

