function [response] = Extension(trialNo)

% Play extension part of the MannerPath experiment.
% Trial structure: First 8 trails MMP, followed by 8 tests.
% Below only test - take a forced choice response between Means and Effect

global parameters
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BIAS TEST EXTENSION
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Play_Sound(soundtoplay_letsFind, 'toBlock');
    Show_Blank;      

    if parameters.mannerSideExt(trialNo) == 'L'
        PlaySideMovies(movietoplay_manner,'');
        PlaySideMovies('',movietoplay_path);
    elseif parameters.mannerSideExt(trialNo) == 'R'
        PlaySideMovies(movietoplay_path,'');
        PlaySideMovies('',movietoplay_manner);
    end
        
     
    %....and take a response
    Play_Sound(soundtoplay_whichOne, 'toBlock');
    parameters.extTestAns{trialNo} = Take_Response();
    parameters.extTestEnd(trialNo) = GetSecs;
    Show_Blank();
    
%%%%%%%%%%%%%%%%%%%%%%
% SHOW A NICE REWARD PICTURE
%%%%%%%%%%%%%%%%%%%%%%

    imageArray = imread(char(parameters.starImageExt(trialNo)));
    rect = parameters.scr.rect;
    winPtr = parameters.scr.winPtr;   
    Screen('PutImage', winPtr , imageArray, rect );    
    Screen('flip',winPtr)
    resp1 = Take_Response(); %just moving on...
    Show_Blank;
    
end




