function [] = Show_Middlebar()
%Puts up the midline, and that's it!

global parameters

Screen('FillRect', parameters.win, parameters.black);
Screen('FillRect', parameters.win, parameters.white, parameters.middlebar);
vbl=Screen('Flip', parameters.win);


end

