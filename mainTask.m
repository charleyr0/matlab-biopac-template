function [data] = mainTask(ex, screen)

    squeezeLevels = [0.5, 0.5, 0.7];
    
    fixation(screen);
    WaitSecs(1);

    for tr = 1:3
        startTime = GetSecs;
        [forceData, success] = squeeze(ex, screen, ex.mvc, 1.1, squeezeLevels(tr), 'Squeeze!', 3, 1, 0.9);
        fixation(screen);
        WaitSecs(1);
        disp('Success =');
        disp(success);
        endTime = GetSecs;
        
        data(tr) = struct('trialNum', tr, 'startTime', startTime, 'endTime', endTime, 'squeezeLevel', squeezeLevels(tr), 'squeezeData', forceData, 'success', success);

    end

end

