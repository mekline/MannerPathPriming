function [] = PlaySideMovies(leftMovie, rightMovie, soundclip, ownsound, shouldloop)
% This is the function (PTB code wrapper!) that plays two
% movies, one on either side of the screen.  It plays them until they
% are done and exits.  It will also quit/skip if you hit any key on the
% keyboard, but response recording should be handled elsewhere.
%
% This assumes that you have a voiceover to go with the movie, but it
% shouldn't freak out if none materializes. It has a bit to turn the
% movie's own sound off, if needed.
%
% Similarly, if it should ever HAPPEN to happen that there's only
% one movie (left or right) to play, it should be cool about that too.
% (just enter a 0 for any movie or sound you're not providing.)

global parameters;

gotLeft = 1;
gotRight = 1;
gotSound = 1;

if leftMovie==0
    gotLeft = 0;
end
if rightMovie==0
    gotRight = 0;
end
if soundclip==0
    gotSound = 0;
end

%Make absolute filepaths!
currDir = pwd;
if not(leftMovie==0)
    leftMovie = strcat(currDir, '/', leftMovie);
end
if not(rightMovie==0)
    rightMovie = strcat(currDir, '/', rightMovie);
end



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
if gotLeft
    [movie_L movieduration_L fps imgw imgh] = Screen('OpenMovie', parameters.scr.winPtr, leftMovie);
    Screen('PlayMovie', movie_L, 1, shouldloop, ownsound);
end
if gotRight
    [movie_R movieduration_R fps imgw imgh] = Screen('OpenMovie', parameters.scr.winPtr, rightMovie);
    Screen('PlayMovie', movie_R, 1, shouldloop, ownsound);
end



while ~KbCheck %1 %loops until we finish the movie or get a keypress to escape
    tex_L=0;
    tex_R=0;
    
    if gotLeft
        tex_L = Screen('GetMovieImage', parameters.scr.winPtr, movie_L, 1);
    end
    if gotRight
        tex_R = Screen('GetMovieImage', parameters.scr.winPtr, movie_R, 1);
    end

    if (tex_L<=0 & tex_R<=0) %Movies are over, break!
        break;
    end
    
    if tex_L>0
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', parameters.scr.winPtr, tex_L, [],parameters.leftbox);
        % Release texture:
        Screen('Close', tex_L);
    end;

    % Valid 2nd texture returned?
    if tex_R>0
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', parameters.scr.winPtr, tex_R, [], parameters.rightbox);
        % Release texture:
        Screen('Close', tex_R);
    end;

    % Update display if there is anything to update:
    if (tex_L>0 | tex_R>0)
        vbl=Screen('Flip', parameters.scr.winPtr,0,1); %clearmode | so we keep the final still up
    else
        continue
    end;

    WaitSecs(0.004); %avoid overloads
end;

%Close the MOVIES
if gotLeft
    Screen('PlayMovie', movie_L, 0);
    Screen('CloseMovie', movie_L);
end
if gotRight
    Screen('PlayMovie', movie_R, 0);
    Screen('CloseMovie', movie_R);
end

% Close the SOUND
if gotSound
    PsychPortAudio('Stop', pahandle);
    PsychPortAudio('Close', pahandle);
end


end

