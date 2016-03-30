function [] = Play_Sound(soundclip, toBlock);
%This plays a sound clip without any accompanying video or pix.
%toBlock tells you if you will force the script to block (wait) until
%the soundfile is finished, or if it should go ahead with whatever comes
%next while the noise is playing in the background.

global parameters

try
    % Read WAV file from filesystem:
    [y, freq] = audioread(soundclip);
    wavedata = y';
    nrchannels = size(wavedata,1); % Number of rows == number of channels.

    % Open the default audio device
    pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
    parameters.pahandle = pahandle;

    % Fill the audio playback buffer with the audio data 'wavedata':
    PsychPortAudio('FillBuffer', pahandle, wavedata);

    % Start audio playback
    t1 = PsychPortAudio('Start', pahandle, 1, 0, 1);

    %Wait until the end!  How dumb!  
    %WaitSecs(length) %What a hack!

   
    if toBlock
        PsychPortAudio('Stop', pahandle, 1);  % Stop playback, but wait until the sound has finished playing!!
        % Close the audio device:
        PsychPortAudio('Close', pahandle);
    else
    end


catch
    rethrow(psychlasterror);
    error('Cannot read sound file %s', soundclip);
    
end

end

