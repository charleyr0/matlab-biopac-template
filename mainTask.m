function [mainTaskData] = mainTask()

    mainTaskData = table('Size', [0 5], ...
        'VariableNames', {'trialNum', 'startTime', 'EndTime', 'squeezeData', 'success'}, ...
        'VariableTypes', {'double', 'double', 'double', 'double', 'double'});
    
    squeezeLevels = [0.3, 0.5, 0.7];

    for tr = 1:10 
        startTime = GetSecs;
        [forceData, success] = fakeSqueeze(ex, screen, mvc, 2, squeezeLevels{tr}, 'Squeeze!', 3, 1);
        fixation(ex, screen);
        disp('Success =');
        disp(success);
        WaitSecs(1);
        endTime = GetSecs;
        mainTaskData(end+1, :) = {1, startTime, endTime, forceData, success};
    end

end

