function [response] = TM_Trial_AKZ(trialNo)

%Plays a single trial of the memory test!

    global parameters
   
    %Clear screen
    Show_Blank;
    
    %Show start screen
    Text_Show('Ready? Press space to watch the movies.');
    WaitSecs(0.25);
    response = Take_Response();
    %Want to finish early?
    if response == 'q'
        return
    end
    
    %Training trials function (while not)
    
    %Show signed description
    movietoplay_three = strcat('Movies2/', char(parameters.SignMoviePath(trialNo)));
    movietoplay_three
    
    finishedWatchingSignMovie = 0;
    
    while not(finishedWatchingSignMovie)
        
        %Sign description to play
        PlayCenterMovie(movietoplay_three,'',0,0); 
        Show_Blank();
        
        %Should we watch again?
        Text_Show('Want to watch again? Press r. If not, press space');
        WaitSecs(0.25);
        response = Take_Response();
            if response == 'r'
                finishedWatchingSignMovie = 0;
            else
                finishedWatchingSignMovie = 1;
            end
    end
%     
%     
%     %Show 2 stim movies
%     movietoplay = strcat('Movies2/', char(parameters.TargetMoviePath(trialNo)));
%     movietoplay_two = strcat('Movies2/', char(parameters.DistractorMoviePath(trialNo)));
%               
%     finishedWatchingMovie = 0;
%         
%     while not(finishedWatchingMovie)
% 
%     %Decide side movie plays on      
%         if strcmp(char(parameters.LeftMovie), 'T') %play Target Movie on left
%             Text_Show('A'); %display A above movie on left (***how to get text to stay for whole time?)
%             WaitSecs(0.60)
%             PlaySideMoviesNew(movietoplay,0,0,0,0);
%             Show_Blank();
%             Text_Show2('B'); %display A above movie on right (***how to get text to stay for whole time?)
%             WaitSecs(0.60)
%             PlaySideMoviesNew(0,movietoplay_two,0,0,0);
%             Show_Blank();
% 
%         else strcmp(char(parameters.LeftMovie), 'D') %play Distractor Movie on left
%             Text_Show('A'); %display A above movie on left (***how to get text to stay for whole time?)
%             WaitSecs(0.60)
%             PlaySideMoviesNew(movietoplay_two,0,0,0,0);
%             Show_Blank();
%             Text_Show2('B'); %display A above movie on right (***how to get text to stay for whole time?)
%             WaitSecs(0.60)
%             PlaySideMoviesNew(0,movietoplay,0,0,0);
%             Show_Blank();
% 
%     %Should we watch again?
%         Text_Show('Want to watch again? Press r. If not, press space');
%         response = Take_Response();
%             if response == 'r'
%                 finishedWatchingMovie = 0;
%             else
%                 finishedWatchingMovie = 1;
%             end
%         end
%     end
      
    %Prompt for response
    Text_Show('A or B?');
    WaitSecs(0.25);
    response = Take_Response();
    
end

