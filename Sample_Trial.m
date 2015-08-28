function [response] = Sample_Trial(trialNo)

%Plays a single trial of the memory test!

    global parameters
    
    %Set up movies to play  
    %movietoplay_target = strcat('Movies/', char(parameters.TargetMoviePath(trialNo)));
    %movietoplay_distractor = strcat('Movies/', char(parameters.DistractorMoviePath(trialNo)));
    %movietoplay_sign = strcat('Movies/', char(parameters.SignMoviePath(trialNo)));
   
    %FOR THE SKELETON - rather than playing movies chosen from a list, play
    %just 3 example movies rather than uploading a big movie directory.
    
    movietoplay_target = 'ExampleMovies/balloon.between.hills.mov';
    movietoplay_distractor = 'ExampleMovies/balloon.front.sunflowers.mov';
    movietoplay_sign = 'ExampleMovies/balloon.into.tree.mov';
    
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
    Show_Blank;
    PlayCenterMovie(movietoplay_sign);
    
    %And prompt and record the response!
    Text_Show('A or B?');
    response = Take_Response();
    
end