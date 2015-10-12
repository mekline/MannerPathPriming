function [] = Noun_Training()

global parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        % 2 TRIALS OF NOUN TRAINING                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%
        %FIRST NOUN TRAINING     
        %%%%%%%%%%%%%%%%%%%%%%
        Play_Sound('Audio_stimuli_creation/Finished/aa_nouns/bone1.wav', 'toBlock');
        Show_Blank;

        movietoplay_noun_2a = 'Movies/2_noun_2a.mov';
        movietoplay_noun_2b = 'Movies/2_noun_2b.mov';    
        movietoplay_noun_2_distr = 'Movies/2_noun_2_distractor.mov';
        Show_Blank;

        PlayCenterMovie(movietoplay_noun_2a);

        Show_Blank;
        
        Play_Sound('Audio_stimuli_creation/Finished/aa_nouns/bone2.wav', 'toBlock');
        Show_Blank;
        
        PlaySideMovies(movietoplay_noun_2_distr,'','caption_left','Z');
        PlaySideMovies('',movietoplay_noun_2b,'caption_right','C'); 
        
        Play_Sound('Audio_stimuli_creation/Finished/aa_nouns/bone3.wav', 'toBlock'); 
        
        parameters.noun1TestAns = Take_Response();
       
        Show_Blank;
        %Play_Sound('Audio_stimuli_creation/Finished/aa_motivation/goodjob.wav', 'toBlock');
        %Show_Blank; 

        starimagenoun1 = 'stars/stars.002.jpg'

        imageArray = imread(starimagenoun1);

        rect = parameters.scr.rect

        winPtr = parameters.scr.winPtr;

        Screen('PutImage', winPtr , imageArray, rect );

        Screen('flip',winPtr)
        Take_Response();
        Show_Blank; 
        
        %%%%%%%%%%%%%%%%%%%%%%
        %SECOND NOUN TRAINING     
        %%%%%%%%%%%%%%%%%%%%%%  
        
        Play_Sound('Audio_stimuli_creation/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;

        movietoplay_target = 'Movies/1_noun_1_distractor.mov';
        movietoplay_distractor = 'Movies/1_noun_1b.mov';    
        movietoplay_sign = 'Movies/1_noun_1a.mov';

        PlayCenterMovie(movietoplay_sign);
        Show_Blank;
        
          
        Play_Sound('Audio_stimuli_creation/Finished/aa_nouns/glorfin2.wav', 'toBlock');
        Show_Blank;

        PlaySideMovies(movietoplay_target,'','caption_left','Z');
        PlaySideMovies('',movietoplay_distractor,'caption_right','C'); 

        Play_Sound('Audio_stimuli_creation/Finished/aa_nouns/glorfin3.wav', 'toBlock');    
        
       parameters.noun2TestAns = Take_Response();
        Show_Blank;
        
        %Play_Sound('Audio_stimuli_creation/Finished/aa_motivation/goodjob.wav', 'toBlock');
        %Show_Blank; 
       

        starimagenoun2 = 'stars/stars.003.jpg'

        imageArray = imread(starimagenoun2);

        rect = parameters.scr.rect

        winPtr = parameters.scr.winPtr;

        Screen('PutImage', winPtr , imageArray, rect );

        Screen('flip',winPtr)
        Take_Response();
        Show_Blank;  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % END NOUN TRAINING                             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    