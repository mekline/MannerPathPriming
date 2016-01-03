function [response] = Extension(trialNo)

% Play extension part of the MannerPath experiment.
% Trial structure: 
% Bias test - show M1P1 ambigious video
% Final test - take a forced choice response between M1P2 and M2P1

global parameters

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




