function [response] = Trial(trialNo)
%Play 1 trial of the MannerPath experiment.
%Trial structure is sort of complex; it has 3 phases:
% Bias test - show M1P1 movie; take a forced choice response between M1P2
% and M2P1
% Training - Depending on the condition, show either MnP1 or M1Pn movies
% Final test - take a forced choice response between M1P2 and M2P1 again
% (CHECK WITH ANNELOT)

global parameters
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STAR IMAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    starImageStart = 'stars/longstars.001.jpeg';
    starImage = strcat('stars/', char(parameters.starImage(trialNo)));
    greySquare = 'stars/grey.jpg'

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
    % BIAS TEST
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Play_Sound(soundtoplay_letsFind, 'toBlock');
    Show_Blank;      
      
    %Using the human-interpretable side variables instead...
    if parameters.mannerSideBias(trialNo) == 'L'
        PlaySideMovies(movietoplay_manner,'');
        PlaySideMovies('',movietoplay_path);
    elseif parameters.mannerSideBias(trialNo) == 'R'
        PlaySideMovies(movietoplay_path,'');
        PlaySideMovies('',movietoplay_manner);
    end
        
    %And take a response
    Play_Sound(soundtoplay_whichOne, 'toBlock');
    parameters.biasTestAns{trialNo} = Take_Response();
    Show_Blank();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3 TRAINING VIDEOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Play_Sound(soundtoplay_letsWatchMore, 'toBlock');
    Text_Show('Ready to learn some verbs? Press space.');
    Take_Response();
    Show_Blank;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 111111111111111111111111111111111111111111111111111111111111111111111111
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    parameters.trainStart(trialNo) = GetSecs;

    Play_Sound(soundtoplay_trainAudioFuture1, 'toBlock');

    PlayCenterMovie(movietoplay_trainV1);  
    PlayCenterMovie(movietoplay_trainV1);
    Show_Blank;

    Play_Sound(soundtoplay_trainAudioPast1, 'toBlock');

    WaitSecs(1.500);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 2222222222222222222222222222222222222222222222222222222222222222222222222
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Play_Sound(soundtoplay_trainAudioFuture2, 'toBlock');
    
    PlayCenterMovie(movietoplay_trainV2);
    PlayCenterMovie(movietoplay_trainV2);
    Show_Blank;

    Play_Sound(soundtoplay_trainAudioPast2, 'toBlock');

    WaitSecs(1.500);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 333333333333333333333333333333333333333333333333333333333333333333333333%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Play_Sound(soundtoplay_trainAudioFuture3, 'toBlock');

    PlayCenterMovie(movietoplay_trainV3);
    PlayCenterMovie(movietoplay_trainV3);
    Show_Blank;

    Play_Sound(soundtoplay_trainAudioPast3, 'toBlock');

    parameters.trainEnd(trialNo) = GetSecs;
   
    WaitSecs(1.500);
    Show_Blank;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % READY FOR THE TEST?
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Text_Show('Ready for the test? Press space.');
    Take_Response();
    Show_Blank;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY THE TEST MOVIE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    parameters.finalTestStart(trialNo) = GetSecs;

    Play_Sound(soundtoplay_letsFind, 'toBlock');
    Show_Blank;      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

    %Using the human-interpretable side variables instead...
    if parameters.mannerSideFinal(trialNo) == 'L'
        PlaySideMovies(movietoplay_mTest,'');
        PlaySideMovies('',movietoplay_pTest);
    elseif parameters.mannerSideFinal(trialNo) == 'R'
        PlaySideMovies(movietoplay_pTest,'');
        PlaySideMovies('',movietoplay_mTest);
    end

     
    %....and take a response
    Play_Sound(soundtoplay_whichOne, 'toBlock');
    parameters.finalTestAns{trialNo} = Take_Response();
    parameters.finalTestEnd(trialNo) = GetSecs;
    
    
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




