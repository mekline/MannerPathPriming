function [] = PlaySideMovies(leftMovie, rightMovie, varargin)
% This is the function (PTB code wrapper!) that plays two
% movies, one on either side of the screen.  It plays them until they
% are done and exits.  It will also quit/skip if you hit any key on the
% keyboard, but response recording should be handled elsewhere.
%
% You must pass PlaySideMovies two strings.  If you want just 1 movie to
% play, give it an empty string for the other side.
%
% A number of parameters are possible.  To use them, you need to specify
% their names, like this: 
%
% PlaySideMovie('myLeftMovieName.mov', '','shouloop', 1, 'soundclip', 'mysoundfile.mpg')
%
% Possible arguments to pass in are:
%
% soundclip: A sound file to play while the movie plays
% caption_Left, caption_Right: Caption to show at the bottom of the movie
% ownsound: Set to 1 to turn on the sounds in the movie file - often we want these silent!
% shouldloop: Set to 1 to make the movie loop (until you press a key to stop it)

p = inputParser;
p.addRequired('leftMovie', @isstr);
p.addRequired('rightMovie', @isstr);
p.addParamValue('soundclip', 0, @(x) true);
p.addParamValue('caption_left', '', @isstr);
p.addParamValue('caption_right', '', @isstr);
p.addParamValue('ownsound', 0, @(x) true);
p.addParamValue('shouldloop', 0, @(x) true);

p.parse(leftMovie, rightMovie, varargin{:});
inputs = p.Results;

global parameters;

gotLeft = 1;
gotRight = 1;
gotSound = 1;

if strcmp(inputs.leftMovie,'')
    gotLeft = 0;
end
if strcmp(inputs.rightMovie,'')
    gotRight = 0;
end
if inputs.soundclip==0
    gotSound = 0;
end

%Make absolute filepaths!
currDir = pwd;
if gotLeft
    inputs.leftMovie = strcat(currDir, '/', inputs.leftMovie);
end
if gotRight
    inputs.rightMovie = strcat(currDir, '/', inputs.rightMovie);
end

%Ensure no keys are being pressed - solves the 'trigger finger problem'
while KbCheck; end % Wait until all keys are released.


%Prepare the SOUND 
if gotSound
    [y, freq, nbits] = wavread(inputs.soundclip);
    wavedata = y';
    nrchannels = size(wavedata,1);
    pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels); % Open & buffer the default audio device
    PsychPortAudio('FillBuffer', pahandle, wavedata);

    %Start the SOUND
    t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);
end

%Prepare & start the MOVIES
if gotLeft
    [movie_L movieduration_L fps imgw imgh] = Screen('OpenMovie', parameters.scr.winPtr, inputs.leftMovie);
    Screen('PlayMovie', movie_L, 1, inputs.shouldloop, inputs.ownsound);
end
if gotRight
    [movie_R movieduration_R fps imgw imgh] = Screen('OpenMovie', parameters.scr.winPtr, inputs.rightMovie);
    Screen('PlayMovie', movie_R, 1, inputs.shouldloop, inputs.ownsound);
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
    
    %And add the captions!
    DrawFormattedText(parameters.scr.winPtr, inputs.caption_left, parameters.leftbox(1), parameters.leftbox(4));
    DrawFormattedText(parameters.scr.winPtr, inputs.caption_right, parameters.rightbox(1), parameters.rightbox(4));

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

