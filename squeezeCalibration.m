function [mvc, allSqueezeData] = squeezeCalibration(ex, screen)
    
    % This function runs the squeeze calibrations and returns the MVC
    % as a decimal number and a 3 arrays containing all of the squeeze data
    % collected throughout their 3 squeeze attempts.

    % variable setup
    allSqueezeData = cell(3,1);  
    mvc = 0;
    
    % possibly might like to change these
    heightDivisor = 4; % how much to scale the bar down for their first squeeze attempt - depends on your gain - 4 is good for 200 gain; 2 for 50 gain; you probably shouldn't use 1000 or 5000 gain with the dynamometer
    goals = [0, 1.1, 1.05];
    textTime = 2;                        % how long (secs) to display each instruction text for
    trialDuration = 3;                   % how long (secs) should each squeeze last for          
    text = {                             % the prompts to show throughout the calibration procedure
      'You will now complete a short procedure to\n \n determine your maximum grip strength.',...
      'Get ready to squeeze as strongly as you can...',...
      'Now try to reach the yellow line!', ...
      'Try one last time!', ...
      'Well done! Please wait for the next instructions.'};
    
    % flip the intro text
    DrawFormattedText(screen.window, text{1}, 'center', 'center', ex.colours.white);
    Screen('Flip', screen.window);
    WaitSecs(textTime);
    
    % do the squeezes
    for i=1:3
    
        DrawFormattedText(screen.window, text{i+1}, 'center', 'center', ex.colours.white);
        Screen('Flip', screen.window);
        WaitSecs(textTime);
        
        forceData = squeeze(ex, screen, ex.colours.blue, ex.colours.white, ex.colours.yellow, heightDivisor, goals(i), 'Squeeze!',trialDuration, 0);
        allSqueezeData{i} = forceData;
        mvc = max(mvc, max(forceData));

        if i==1 % scale the bar for the 2nd/3rd squeezes relative to their first attempt
            heightDivisor = mvc*1.2; % so, squeezing at 1.2 times the MVC will fully fill the bar 
        end
        
    end

    % flip final text
    DrawFormattedText(screen.window, text{5}, 'center', 'center', ex.colours.white);
    Screen('Flip', screen.window);
    WaitSecs(textTime);

end

