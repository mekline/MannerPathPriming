function [response] = Extension(trialNo)

% Play extension part of the MannerPath experiment.
% Trial structure: 
% Bias test - show M1P1 ambigious video
% Final test - take a forced choice response between M1P2 and M2P1

global parameters
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Noun training
    movietoplay_noun1a = 'Movies/1_noun_1a.mov';
    movietoplay_noun1b = 'Movies/1_noun_1b.mov';
    movietoplay_noun1_distractor = 'Movies/1_noun_1_distractor';
    movietoplay_noun2a = 'Movies/2_noun_2a.mov';
    movietoplay_noun2b = 'Movies/2_noun_2b.mov';
    movietoplay_noun2_distractor = 'Movies/2_noun_2_distractor';

    %Trial movies
    movietoplay_path = strcat('Movies/', char(parameters.pBiasV(trialNo)));
    movietoplay_manner = strcat('Movies/', char(parameters.mBiasV(trialNo)));
    movietoplay_ambigVid = strcat('Movies/', char(parameters.ambigV(trialNo)));
    movietoplay_trainV1 = strcat('Movies/', char(parameters.trainV1(trialNo)));
    movietoplay_trainV2 = strcat('Movies/', char(parameters.trainV2(trialNo)));
    movietoplay_trainV3 = strcat('Movies/', char(parameters.trainV3(trialNo)));
    movietoplay_mTest = strcat('Movies/', char(parameters.mTestV(trialNo)));
    movietoplay_pTest = strcat('Movies/', char(parameters.pTestV(trialNo)));

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUDIO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    soundtoplay_ambigAudioFuture = strcat('Audio_stimuli_creation/Finished/', char(parameters.ambigAudioFuture(trialNo)));
    soundtoplay_ambigAudioPast = strcat('Audio_stimuli_creation/Finished/', char(parameters.ambigAudioPast(trialNo)));
    soundtoplay_trainAudioFuture1 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioFuture1(trialNo)));
    soundtoplay_trainAudioPast1 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioPast1(trialNo)));
    soundtoplay_trainAudioFuture2 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioFuture2(trialNo)));
    soundtoplay_trainAudioPast2 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioPast2(trialNo)));
    soundtoplay_trainAudioFuture3 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioFuture3(trialNo)));
    soundtoplay_trainAudioPast3 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioPast3(trialNo)));
    soundtoplay_whichOne = strcat('Audio_stimuli_creation/Finished/', char(parameters.whichOneAudio(trialNo)));
    soundtoplay_letsFind = strcat('Audio_stimuli_creation/Finished/aa_lets_find/', char(parameters.letsFindAudio(trialNo)));
    soundtoplay_letsWatchMore = 'Audio_stimuli_creation/Finished/aa_motivation/letswatchmore.wav';
    soundtoplay_getReady = 'Audio_stimuli_creation/Finished/aa_motivation/getready.wav';
    soundtoplay_goodJob = 'Audio_stimuli_creation/Finished/aa_motivation/goodjob.wav';
    soundtoplay_nowLetsSee = 'Audio_stimuli_creation/Finished/aa_motivation/nowletssee.wav';
    soundtoplay_wow = 'Audio_stimuli_creation/Finished/aa_motivation/wow.wav';
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STAR IMAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    starImageStart = 'stars/stars.001.jpg';
    starImageTrials = strcat('stars/', char(parameters.starImage(trialNo)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY BIAS TEST VIDEO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioFuture, 'toBlock');
    
        PlayCenterMovie(movietoplay_ambigVid);
        PlayCenterMovie(movietoplay_ambigVid);
        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioPast, 'toBlock');
        
        Show_Blank; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BIAS TEST EXTENSION
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Play_Sound(soundtoplay_letsFind, 'toBlock');
    Show_Blank;      

    if parameters.mannerSideBias(trialNo) == 'L'
        PlaySideMovies(movietoplay_manner,'');
        PlaySideMovies('',movietoplay_path);
    elseif parameters.mannerSideBias(trialNo) == 'R'
        PlaySideMovies(movietoplay_path,'');
        PlaySideMovies('',movietoplay_manner);
    end
        
     
    %....and take a response
    Play_Sound(soundtoplay_whichOne, 'toBlock');
    parameters.finalTestAns{trialNo} = Take_Response();
    parameters.finalTestEnd(trialNo) = GetSecs;
    Show_Blank();
    
%%%%%%%%%%%%%%%%%%%%%%
% SHOW A NICE REWARD PICTURE
%%%%%%%%%%%%%%%%%%%%%%

    imageArray = imread(char(parameters.starImage(trialNo)));
    rect = parameters.scr.rect;
    winPtr = parameters.scr.winPtr;   
    Screen('PutImage', winPtr , imageArray, rect );    
    Screen('flip',winPtr)
    resp1 = Take_Response(); %just moving on...
    Show_Blank;
    
end




