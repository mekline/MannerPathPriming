function [response] = Take_Response()
%Wraps up some standard-ish Psychtoolbox code that waits for ANY
% keypress to arrive and tells you what it was.

%Wait until previous keys are released!
while KbCheck; end 

%Wait for a given keypress press and continue
while 1
    [keyIsDown, secs, keyCode]= KbCheck();
    %if (keyIsDown==1 & (keyCode(z_press)|keyCode(c_press)))
    if (keyIsDown==1)
        break;
    end;
    WaitSecs(0.004); %avoid system overload
end

%Record it!
response = KbName(keyCode);


end

