function triggerTime = waitForScannerTrigger()

% TODO this function waits for 't' to be 'pressed' by the scanner, then
% returns the time at which this happened. Note that the scanner will 
% continue to send a 't' at every TR.

triggerTime = GetSecs;

end

