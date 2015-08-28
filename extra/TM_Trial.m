function [response] = TBW_Trial(trialNo)

%Plays a single trial of the memory test!

    global parameters
   
    
    %Clear screen
    Show_Blank;
    
    %Show start screen
    Text_Show('get ready...');
    WaitSecs(0.25);
    response = Take_Response();
    %Want to finish early?
    if response == 'q'
        return
    end
    
    %Show 2 movies

    PlayCenterMovie(char(parameters.BaselineMoviePath(trialNo)),'',0,0);
    Show_Blank();
    PlayCenterMovie(char(parameters.TestMoviePath(trialNo)),'',0,0);
    

    
    %Prompt for response
    Text_Show('Same=z, Different=x');
    WaitSecs(0.25);
    response = Take_Response();
    
end

