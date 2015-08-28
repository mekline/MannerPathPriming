function [] = Closeout_PTool()
%Just does the boilerpplate to close out of Ptool properly

global parameters

WaitSecs(0.1); %so we don't crash/close right away

%Exit TOBII connection cleanly
if(parameters.EYETRACKER)
    talk2tobii('STOP_RECORD');
    talk2tobii('STOP_TRACKING');
    talk2tobii('SAVE_DATA',parameters.trackFileName,parameters.eventFileName,'TRUNK');
    talk2tobii('DISCONNECT');    
end

% Close window, show mouse cursor, close result file, 
% switch Matlab/Octave back to priority 0 

PsychPortAudio('Close');
Screen('CloseAll');
ShowCursor;
fclose('all');
Priority(0);

end

