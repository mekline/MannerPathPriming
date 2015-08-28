function [] = Text_takeKey(message, keyToPress);
%This puts some text up on the screen in a default size, and waits until a
%button is pressed before moving on.

global parameters

% Clear screen to background color
Screen('FillRect', parameters.win, parameters.black);
% ...and flip it up. Initial display and sync to timestamp:
vbl=Screen('Flip', parameters.win);

%Display the message
Screen('DrawText', parameters.win, message, 200, 20, parameters.white);
vbl=Screen('Flip', parameters.win);

%Wait for a given keypress press and continue
while 1
  [keyIsDown, secs, keyCode]= KbCheck;
  WaitSecs(0.004); %avoid system overload
  if keyIsDown
      if keyCode(keyToPress)
         break;
      end
  end
end



