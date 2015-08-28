function [] = PlayCenterMovie(centerMovie, soundclip, ownsound, shouldloop)
%Just like PlaySideMovies, but just plays one movie in the middle! Yay.
%
% This assumes that you have a voiceover to go with the movie, but it
% shouldn't freak out if none materializes. It has a bit to turn the
% movie's own sound off, if needed.
%

global parameters;

gotSound = 1;

if soundclip==0
    gotSound = 0;
end


%Make absolute filepaths!
currDir = pwd;
centerMovie = strcat(currDir, '/', centerMovie);

%Ensure no keys are being pressed - solves the 'trigger finger problem'
while KbCheck; end % Wait until all keys are released.

%Prepare the SOUND 
if gotSound
    [y, freq, nbits] = wavread(soundclip);
    wavedata = y';
    nrchannels = size(wavedata,1);
    pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels); % Open & buffer the default audio device
    PsychPortAudio('FillBuffer', pahandle, wavedata);

    %Start the SOUND
    t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
end

%Prepare & start the MOVIES

[movie movieduration fps imgw imgh] = Screen('OpenMovie', parameters.scr.winPtr, centerMovie);
Screen('PlayMovie', movie, 1, shouldloop, ownsound);

while ~KbCheck %1 %loops until we finish the movie or get a keypress to escape
    tex=0;
    tex = Screen('GetMovieImage', parameters.scr.winPtr, movie, 1);

    if (tex<=0) %Movies are over, break!
        break;
    end
    
    if tex>0
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', parameters.scr.winPtr, tex, [],parameters.centerbox);
        % Release texture:
        Screen('Close', tex);
    end;

    % Update display if there is anything to update:
    if (tex>0)
        vbl=Screen('Flip', parameters.scr.winPtr,0,1); %clearmode | so we keep the final still up
    else
        continue
    end;

    WaitSecs(0.004); %avoid overloads
end;

%Close the MOVIES
Screen('PlayMovie', movie, 0);
Screen('CloseMovie', movie);

% Close the SOUND
if gotSound
    PsychPortAudio('Stop', pahandle);
    PsychPortAudio('Close', pahandle);
end

end


