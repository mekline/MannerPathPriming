function [response] = Sign_Trial(trialNo)

%Plays a single trial of the memory test!

    global parameters
    
    %Set up movies to play  
    movietoplay_target = strcat('Movies/', char(parameters.TargetMoviePath(trialNo)));
    movietoplay_distractor = strcat('Movies/', char(parameters.DistractorMoviePath(trialNo)));
    movietoplay_sign = strcat('Movies/', char(parameters.SignMoviePath(trialNo)));
   
    
    %Start the trial!
    
    %Clear screen
    Show_Blank;
    
    %%%%%
    %Show start screen
    
    Text_Show('Ready? Press space to watch the sign movies.');
    response = Take_Response();
    %Want to finish early?
    if response == 'q'
        return
    end

    %%%%
    %Play the sign movie, in a 'repeat' block
    
    finishedSignMovie = 0;
    
    while not(finishedSignMovie)
        
        Show_Blank;
        PlayCenterMovie(movietoplay_sign);
        
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
    %Play the two event movies, in a 'repeat' block
    
    finishedWatchingMovie = 0;
    
    while not(finishedWatchingMovie)
     
        if strcmp(char(parameters.LeftMovie), 'T') %play Target Movie on left
            
            Show_Blank;
            PlaySideMovies(movietoplay_target,'','caption_left','A');
            Show_Blank;
            PlaySideMovies('',movietoplay_distractor,'caption_right','B');

        else strcmp(char(parameters.LeftMovie), 'D') %play Distractor Movie on left
            
            Show_Blank;
            PlaySideMovies(movietoplay_distractor,'','caption_left','A');
            Show_Blank;
            PlaySideMovies('',movietoplay_target,'caption_right','B');
            
        end

        %Decide if we should we watch again?
        Text_Show('Want to watch again? Press r. If not, press space');
        response_events = Take_Response();
        
        if response_events == 'r'
            finishedWatchingMovie = 0;
        else
            finishedWatchingMovie = 1;
        end
    end
    
    %Play the sign movie, in a 'repeat' block
    finishedSignMovie = 0;
    
    while not(finishedSignMovie)
        
        PlayCenterMovie(movietoplay_sign);
        
        %Decide if we should we watch again?
        Text_Show('Want to watch again? Press r. If not, press space');
        response_sign = Take_Response();
        
        if response_sign == 'r'
            finishedSignMovie = 0;
        else
            finishedSignMovie = 1;
        end
    end

    
    %And prompt and record the response!
    Text_Show('A or B?');
    response = Take_Response();
    
end