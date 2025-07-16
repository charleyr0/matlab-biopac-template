function [triggerTimeAbs, triggerTimeRel, listeningStartTime] = waitForScannerTrigger()

% This function waits for 't' to be 'pressed' by the scanner, then
% returns the time at which this happened.

% You can actually just run this function standalone and notice that it 
% exits immediately when you press 't' on the keyboard.

% TODO in the old code, the triggerTimeRel is what gets saved. I can't see that
% the listeningStartTime also gets saved. And I don't understand how
% triggerTimeRel alone is of any use.

KbName('UnifyKeyNames');
triggerKey = KbName('t');

triggerRead = 0;

% start listening to keypresses
KbQueueCreate();
KbQueueStart();
listeningStartTime = GetSecs;

while ~triggerRead
    [pressed, firstPress, ~, ~, ~] = KbQueueCheck;      % look at all the keypresses that happened since we last checked
    if pressed                                          % if any key was pressed,
       if firstPress(triggerKey)                        % if the trigger key was pressed,
           triggerTimeRel = firstPress(triggerKey);     % save the time at which the trigger key was first pressed
           triggerRead = 1;                             % and exit the loop now
       end
    end
end

% release the keyboard queue i.e. stop listening to key presses
KbQueueRelease();

% lastPress() gives "the most recent time that each was pressed
% since the most recent call to KbQueueCheck of KbQueueStart". So we have to
% add that start time on to the lastPress() time to get the absolute time
% at which the trigger was pressed.
triggerTimeAbs = triggerTimeRel + listeningStartTime;

end

