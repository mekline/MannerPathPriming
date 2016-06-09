function [] = Show_Blank()
% PTB wrapper to show a blank screen.  Uses the parameter struct to find
% out your chosen 'background' color

global parameters

Screen('FillRect', parameters.scr.winPtr, parameters.scr.bgcolor);
vbl=Screen('Flip', parameters.scr.winPtr);


end

