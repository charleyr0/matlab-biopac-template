function squeezeFake(ex, screen, settings, fakeSqueezeLevel)

    startTime = GetSecs;
    
    while GetSecs - startTime < settings.trialDuration
        drawSqueeze(ex, screen, settings.barColour, settings.barOutlineColour, settings.targetColour, fakeSqueezeLevel/settings.barScaleFactor, settings.targetLevel, settings.cueText); 
        WaitSecs(0.1)
    end
    
end

