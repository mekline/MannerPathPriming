function [response] = Sample_Trial(trialNo)

%Plays a single trial of the memory test!

    global parameters
    
    %Set up movies to play  
    
    %Noun training
    movietoplay_noun1a = 'Movies/1_noun_1a.mov';
    movietoplay_noun1b = 'Movies/1_noun_1b.mov';
    movietoplay_noun1_distractor = 'Movies/1_noun_1_distractor';

    %Trial movies
    movietoplay_target = strcat('Movies/', char(parameters.pbiasV(trialNo)));
    movietoplay_distractor = strcat('Movies/', char(parameters.mbiasV(trialNo)));
    movietoplay_sign = strcat('Movies/', char(parameters.ambigV(trialNo)));
    movietoplay_trainV1 = strcat('Movies/', char(parameters.trainV1(trialNo)));
    movietoplay_trainV2 = strcat('Movies/', char(parameters.trainV2(trialNo)));
    movietoplay_trainV3 = strcat('Movies/', char(parameters.trainV3(trialNo)));
    movietoplay_mTest = strcat('Movies/', char(parameters.mtestV(trialNo)));
    movietoplay_pTest = strcat('Movies/', char(parameters.ptestV(trialNo)));
    
    
    %Audio
    soundtoplay_ambigAudioFuture = strcat('Audio_stimuli_creation/Finished/', char(parameters.ambigAudioFuture(trialNo)));
    soundtoplay_ambigAudioPast = strcat('Audio_stimuli_creation/Finished/', char(parameters.ambigAudioPast(trialNo)));
    soundtoplay_trainAudioFuture1 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioFuture1(trialNo)));
    soundtoplay_trainAudioPast1 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioPast1(trialNo)));
    soundtoplay_trainAudioFuture2 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioFuture2(trialNo)));
    soundtoplay_trainAudioPast2 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioPast2(trialNo)));
    soundtoplay_trainAudioFuture3 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioFuture3(trialNo)));
    soundtoplay_trainAudioPast3 = strcat('Audio_stimuli_creation/Finished/', char(parameters.trainAudioPast3(trialNo)));
    soundtoplay_whichOne = strcat('Audio_stimuli_creation/Finished/', char(parameters.whichOne(trialNo)));
    
    %Start the trial!
    
    
    %Clear screen
    Show_Blank;
    
    %%%%%
    %Show start screen
   
    %%%%
    %Play the sign movie, in a 'repeat' block
    
    finishedSignMovie = 0;
    
    while not(finishedSignMovie)
        
Show_Blank;


Play_Sound(soundtoplay_ambigAudioFuture, 'toBlock');
Take_Response();
Show_Blank;
        
PlayCenterMovie(movietoplay_sign);

Play_Sound(soundtoplay_ambigAudioPast, 'toBlock');
Take_Response();
Show_Blank;


        %Decide if we should we watch again?
        Text_Show('Want to watch again? Press r. If not, press space');
        response_sign = Take_Response();
        
        if response_sign == 'r'
            finishedSignMovie = 0;
        else
            finishedSignMovie = 1;
        end
    end
    
    %%%%
    %Play the two event movies; movie always plays L then R, with movies
    %assigned to random sides in main script.
    %%%%
    
Play_Sound(soundtoplay_trainAudioFuture1, 'toBlock');
Take_Response();
Show_Blank;

     
    if parameters.LorR_bias == 0 %play Target Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_target,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_distractor,'caption_right','B');

    else %play Distractor Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_distractor,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_target,'caption_right','B');

    end
    
    %%%%
    %Play the sign movie again
    %%%%
    %Show_Blank;
    %PlayCenterMovie(movietoplay_sign);
    
    %And prompt and record the response!
    Text_Show('Which one is ...');
    response = Take_Response();
    
    
    
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % NEW Play the 3 train movies
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Text_Show('(((training phase)))');
Take_Response();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 111111111111111111111111111111111111111111111111111111111111111111111111
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Play_Sound(soundtoplay_trainAudioFuture1, 'toBlock');
Take_Response();
Show_Blank;


PlayCenterMovie(movietoplay_trainV1);
Show_Blank;
PlayCenterMovie(movietoplay_trainV1);
Show_Blank;

Play_Sound(soundtoplay_trainAudioPast1, 'toBlock');
Take_Response();
Show_Blank;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2222222222222222222222222222222222222222222222222222222222222222222222222
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Play_Sound(soundtoplay_trainAudioFuture2, 'toBlock');
Take_Response();
Show_Blank;

PlayCenterMovie(movietoplay_trainV2);
PlayCenterMovie(movietoplay_trainV2);
Show_Blank;

Play_Sound(soundtoplay_trainAudioPast2, 'toBlock');
Take_Response();
Show_Blank;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 333333333333333333333333333333333333333333333333333333333333333333333333%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Play_Sound(soundtoplay_trainAudioFuture3, 'toBlock');
Take_Response();
Show_Blank;

PlayCenterMovie(movietoplay_trainV3);
PlayCenterMovie(movietoplay_trainV3);
Show_Blank;

Play_Sound(soundtoplay_trainAudioPast3, 'toBlock');
Take_Response();
Show_Blank;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %And prompt and record the response!
    %Text_Show('A or B?');
    %response = Take_Response();


    %NEW: PLAY THE TEST MOVIE

Text_Show('(((which one is ....)))');
Take_Response();
Show_Blank;

Play_Sound(soundtoplay_whichOne, 'toBlock');
Take_Response();
Show_Blank;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     if parameters.LorR_final == 0 %play Target Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_mTest,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_pTest,'caption_right','B');

    else %play Distractor Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_pTest,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_mTest,'caption_right','B');

     end
    
Play_Sound(soundtoplay_whichOne, 'toBlock');
Take_Response();
Show_Blank;
    
    
end




