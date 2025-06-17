function acquisitionEndTime = biopacEndAcquisition()
    calllib('mpdev', 'stopAcquisition');
    acquisitionEndTime = GetSecs; 
end

    