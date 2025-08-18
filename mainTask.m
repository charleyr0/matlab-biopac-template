function [data] = mainTask(ex, screen)

    % runs 3 squeezes - at 0.5x, 0.5x, and 0.7x mvc

    squeezeLevels = [0.5, 0.5, 0.7];
    fixation(screen, 1);

    % to test without the biopac, you can change the function call 'squeeze' to 'squeezeFake' and keep the rest of the line the same
    for tr = 1:3

        startTime = GetSecs;
        [forceData, success] = squeeze(ex, screen, ex.mvc, 1.1, squeezeLevels(tr), 'Squeeze!', 3, 1, 0.9);
        endTime = GetSecs;

        if success
            feedback = 'Well done!'; 
        else 
            feedback = 'Not quite! \n\nSqueeze the bar above the line for longer!'; 
        end

        DrawFormattedText(screen.window, feedback, 'center', 'center', ex.colours.white);
        Screen('Flip', screen.window);
        WaitSecs(2);

        fixation(screen, 1);

        data(tr) = struct('trialNum', tr, 'startTime', startTime, 'endTime', endTime, 'squeezeLevel', squeezeLevels(tr), 'squeezeData', forceData, 'success', success);

    end

end

