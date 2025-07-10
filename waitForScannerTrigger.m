function [triggerTimeAbs, triggerTimeRel, listeningStartTime] = waitForScannerTrigger()

% TODO this function waits for 't' to be 'pressed' by the scanner, then
% returns the time at which this happened. Note that the scanner will 
% continue to send a 't' at every TR.

KbName('UnifyKeyNames');
triggerKey = KbName('t');

triggerRead = 0;

% start listening to keypresses
% this listening just runs in the background, and we call KbQueueCheck to
% get an array of all the keypresses that have happened since the last call
% to KbQueueCheck (or since KbQueueStart, if it's our first time to call
% KbQueueCheck)
KbQueueCreate();
KbQueueStart();
listeningStartTime = GetSecs;

while ~triggerRead
    [pressed, ~, ~, lastPress, ~] = KbQueueCheck;
    if pressed
       if lastPress(triggerKey)
           triggerTimeRel = lastPress(triggerKey);
           triggerRead = 1; % the loop will not continue
       end
    end
end

% lastPress() gives "the most recent time that each was pressed
% since the most recent call to KbQueueCheck of KbQueueStart". So we have to
% add that start time on to the lastPress() time to get the absolute time
% at which the trigger was pressed.
triggerTimeAbs = triggerTimeRel + listeningStartTime;

% TODO In the old code, the triggerTimeRel is what gets saved. I can't see that
% the listeningStartTime also gets saved. And I don't understand how
% triggerTimeRel alone is of any use.

end

