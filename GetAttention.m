function [] = GetAttention()
% For a prompted start -play a laughing baby until you notice that
% the participant is looking at the screen.
% (Left as an exercise for the reader/future me - play until the
% EYETRACKER notices baby is looking at the screen.)

    Show_Blank;
    lookingScreen = 0;
    disp('Press any key to start the next trial');
    while ~lookingScreen
        PlayCenterMovie('babylaugh.mov', '', 1, 0) %start playing baby attention getter.  PCM stops whenever you get (any) keypress
        lookingScreen = 1;
        if( lookingScreen)
            break;
        end
    end


end

