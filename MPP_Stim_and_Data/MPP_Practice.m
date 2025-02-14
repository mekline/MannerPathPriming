function [response] = MPP_Practice()

global parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        % 4 TRIALS OF NOUN PRACTICE                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%
    %FIRST PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
    
        %%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO     
        %%%%%%%%%%%%%%%%%%%%%%%%
        %%Input new recording
       
        Play_Sound('Audio/Finished/aa_nouns/bone1.wav', 'toBlock');
        Show_Blank;
        
        soundtoplay_letsWatchMore = 'Audio/Finished/aa_motivation/letswatchmore.wav';
        movietoplay_practice_1a = 'Movies_Practice/practice_1a.mp4';
        movietoplay_practice_1b = 'Movies_Practice/practice_1b.mp4';
        movietoplay_practice_1c = 'Movies_Practice/practice_1c.mp4';
        movietoplay_practice_1d = 'Movies_Practice/practice_1d.mp4';
        movietoplay_practice_1e = 'Movies_Practice/practice_1e.mp4';
        movietoplay_practice_1_distr = 'Movies_Practice/practice_1_distr.mp4';
        Show_Blank;

        PlayCenterMovie(movietoplay_practice_1a);

        Show_Blank;
   
        Play_Sound(soundtoplay_letsWatchMore, 'toBlock');
        Text_Show('Ready to learn some verbs? Press space.');
        Take_Response();
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Play_Sound('Audio/Finished/aa_nouns/bone1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_1b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/bone1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_1c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/bone1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_1d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Text_Show('Ready for the test? Press space.');
        Take_Response();
        Show_Blank;
        
        Play_Sound('Audio/Finished/aa_nouns/bone2.wav', 'toBlock');
        
        PlaySideMovies(movietoplay_practice_1_distr,'','caption_left','');
        PlaySideMovies('',movietoplay_practice_1e,'caption_right',''); 
        
        Play_Sound('Audio/Finished/aa_nouns/bone3.wav', 'toBlock'); 
        
        parameters.practice1TestAns = Take_Response();
       
        Show_Blank;

        starimagenoun1 = parameters.practiceStars{1};

        imageArray = imread(starimagenoun1);
        rect = parameters.scr.rect;
        winPtr = parameters.scr.winPtr;
        Screen('PutImage', winPtr , imageArray, rect );
        Screen('flip',winPtr)
        Take_Response();
        Show_Blank; 
        
    %%%%%%%%%%%%%%%%%%%%%
    %SECOND PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;

        movietoplay_practice_2a = 'Movies_Practice/practice_2a.mp4';
        movietoplay_practice_2b = 'Movies_Practice/practice_2b.mp4';
        movietoplay_practice_2c = 'Movies_Practice/practice_2c.mp4';
        movietoplay_practice_2d = 'Movies_Practice/practice_2d.mp4';
        movietoplay_practice_2e = 'Movies_Practice/practice_2e.mp4';
        movietoplay_practice_2_distr = 'Movies_Practice/practice_2_distr.mp4';
        Show_Blank;

        PlayCenterMovie(movietoplay_practice_2a);
        Show_Blank;
        
        Play_Sound(soundtoplay_letsWatchMore, 'toBlock');
        Text_Show('Ready to learn some verbs? Press space.');
        Take_Response();
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_2b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_2c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_2d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Text_Show('Ready for the test? Press space.');
        Take_Response();
        Show_Blank;
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin2.wav', 'toBlock');
        Show_Blank;
        
        PlaySideMovies(movietoplay_practice_2e,'','caption_left','');
        PlaySideMovies('',movietoplay_practice_2_distr,'caption_right',''); 

        Play_Sound('Audio/Finished/aa_nouns/glorfin3.wav', 'toBlock');    
        
        parameters.practice2TestAns = Take_Response();
        Show_Blank;

        starimagenoun2 = parameters.practiceStars{2};
        imageArray = imread(starimagenoun2);
        rect = parameters.scr.rect;
        winPtr = parameters.scr.winPtr;
        Screen('PutImage', winPtr , imageArray, rect );
        Screen('flip',winPtr)
        Take_Response();
        Show_Blank;  

    %%%%%%%%%%%%%%%%%%%%%
    %THIRD PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;

        movietoplay_practice_3a = 'Movies_Practice/practice_3a.mp4';
        movietoplay_practice_3b = 'Movies_Practice/practice_3b.mp4';
        movietoplay_practice_3c = 'Movies_Practice/practice_3c.mp4';
        movietoplay_practice_3d = 'Movies_Practice/practice_3d.mp4';
        movietoplay_practice_3e = 'Movies_Practice/practice_3e.mp4';
        movietoplay_practice_3_distr = 'Movies_Practice/practice_3_distr.mp4';
        Show_Blank;

        PlayCenterMovie(movietoplay_practice_3a);
        Show_Blank;
        
        Play_Sound(soundtoplay_letsWatchMore, 'toBlock');
        Text_Show('Ready to learn some verbs? Press space.');
        Take_Response();
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_3b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_3c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_3d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Text_Show('Ready for the test? Press space.');
        Take_Response();
        Show_Blank;
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin2.wav', 'toBlock');
        Show_Blank;
        
        PlaySideMovies(movietoplay_practice_3e,'','caption_left','');
        PlaySideMovies('',movietoplay_practice_3_distr,'caption_right',''); 

        Play_Sound('Audio/Finished/aa_nouns/glorfin3.wav', 'toBlock');    
        
        parameters.practice3TestAns = Take_Response();
        Show_Blank;

        starimagenoun3 = parameters.practiceStars{3};
        imageArray = imread(starimagenoun3);
        rect = parameters.scr.rect;
        winPtr = parameters.scr.winPtr;
        Screen('PutImage', winPtr , imageArray, rect );
        Screen('flip',winPtr)
        Take_Response();
        Show_Blank;  
        
    %%%%%%%%%%%%%%%%%%%%%
    %FOURTH PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;

        movietoplay_practice_4a = 'Movies_Practice/practice_4a.mp4';
        movietoplay_practice_4b = 'Movies_Practice/practice_4b.mp4';
        movietoplay_practice_4c = 'Movies_Practice/practice_4c.mp4';
        movietoplay_practice_4d = 'Movies_Practice/practice_4d.mp4';
        movietoplay_practice_4e = 'Movies_Practice/practice_4e.mp4';
        movietoplay_practice_4_distr = 'Movies_Practice/practice_4_distr.mp4';
        Show_Blank;

        PlayCenterMovie(movietoplay_practice_4a);
        Show_Blank;
        
        Play_Sound(soundtoplay_letsWatchMore, 'toBlock');
        Text_Show('Ready to learn some verbs? Press space.');
        Take_Response();
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_4b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_4c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin1.wav', 'toBlock');
        Show_Blank;
        
        PlayCenterMovie(movietoplay_practice_4d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Text_Show('Ready for the test? Press space.');
        Take_Response();
        Show_Blank;
        
        Play_Sound('Audio/Finished/aa_nouns/glorfin2.wav', 'toBlock');
        Show_Blank;
        
        PlaySideMovies(movietoplay_practice_4e,'','caption_left','');
        PlaySideMovies('',movietoplay_practice_4_distr,'caption_right',''); 

        Play_Sound('Audio/Finished/aa_nouns/glorfin3.wav', 'toBlock');    
        
        parameters.practice3TestAns = Take_Response();
        Show_Blank;

        starimagenoun4 = parameters.practiceStars{4};
        imageArray = imread(starimagenoun4);
        rect = parameters.scr.rect;
        winPtr = parameters.scr.winPtr;
        Screen('PutImage', winPtr , imageArray, rect );
        Screen('flip',winPtr)
        Take_Response();
        Show_Blank;  

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % END NOUN TRAINING                             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    