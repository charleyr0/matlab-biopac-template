function [mainTaskData] = mainTask(ex, screen)

    mainTaskData = table('Size', [0 5], ...
        'VariableNames', {'trialNum', 'startTime', 'EndTime', 'squeezeData', 'success'}, ...
        'VariableTypes', {'double', 'double', 'double', 'cell', 'double'});
    
    squeezeLevels = [0.3, 0.5, 0.7, 0.3, 0.5, 0.7, 0.3, 0.5, 0.7];
    
    fixation(screen);
    WaitSecs(1);

    for tr = 1:9
        startTime = GetSecs;
        [forceData, success] = squeezeFake(ex, screen, ex.mvc, 1.1, squeezeLevels(tr), 'Squeeze!', 3, 1, 0.9);
        fixation(screen);
        WaitSecs(1);
        disp('Success =');
        disp(success);
        endTime = GetSecs;
        mainTaskData(end+1, :) = {tr, startTime, endTime, forceData, success};
    end

end

