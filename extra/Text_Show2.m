function [] = Text_takeKey(message);
%This puts some text up on the screen in a default size, and waits until a
%button is pressed before moving on.

global parameters

% Clear screen to background color
Screen('FillRect', parameters.scr.winPtr, parameters.scr.black);
% ...and flip it up. Initial display and sync to timestamp:
vbl=Screen('Flip', parameters.scr.winPtr);

%Display the message
Screen('DrawText', parameters.scr.winPtr, message, 850, 20, parameters.scr.white);
vbl=Screen('Flip', parameters.scr.winPtr);
