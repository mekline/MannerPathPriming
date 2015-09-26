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
    
    
    
    
    %FOR THE SKELETON - rather than playing movies chosen from a list, play
    %just 3 example movies rather than uploading a big movie directory.
    
%     movietoplay_target = 'ExampleMovies/balloon.between.hills.mov';
%     movietoplay_distractor = 'ExampleMovies/balloon.front.sunflowers.mov';    
%     movietoplay_sign = 'ExampleMovies/balloon.into.tree.mov';

    
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
        PlayCenterMovie(movietoplay_sign);

 Text_Show('(((... did it ...)))');
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
     
    if strcmp(char(parameters.LeftMovie(trialNo)), 'T') %play Target Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_target,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_distractor,'caption_right','B');

    elseif strcmp(char(parameters.LeftMovie(trialNo)), 'D') %play Distractor Movie on left

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

Text_Show('(((... is going to ...)))');
Take_Response();
Show_Blank;

PlayCenterMovie(movietoplay_trainV1);
Show_Blank;
PlayCenterMovie(movietoplay_trainV1);

Text_Show('(((... did it ...)))');
Take_Response();
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
Text_Show('(((... is going to ...)))');
Take_Response();
Show_Blank;

PlayCenterMovie(movietoplay_trainV2);
PlayCenterMovie(movietoplay_trainV2);

Text_Show('(((... did it ...)))');
Take_Response();
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
Text_Show('(((... is going to ...)))');
Take_Response();
Show_Blank;

PlayCenterMovie(movietoplay_trainV3);
PlayCenterMovie(movietoplay_trainV3);

Text_Show('(((... did it ...)))');
Take_Response();

    
    %And prompt and record the response!
    %Text_Show('A or B?');
    %response = Take_Response();


    %NEW: PLAY THE TEST MOVIE

    
   % Text_Show('(((sound sentence for test)))');
   % response = Take_Response();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     if strcmp(char(parameters.LeftMovie(trialNo)), 'T') %play Target Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_mTest,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_pTest,'caption_right','B');

    elseif strcmp(char(parameters.LeftMovie(trialNo)), 'D') %play Distractor Movie on left

        Show_Blank;
        PlaySideMovies(movietoplay_pTest,'','caption_left','A');
        Show_Blank;
        PlaySideMovies('',movietoplay_mTest,'caption_right','B');

    end
    
    
%     Show_Blank;
%     PlayCenterMovie(movietoplay_mTest);
%     
%     Show_Blank;
%     PlayCenterMovie(movietoplay_pTest);
    
    
    
    
    
    Text_Show('Which one is ...');
    response = Take_Response();
    
    
end




