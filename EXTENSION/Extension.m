function [response] = Extension(trialNo)
%Play 1 trial of extension MannerPath experiment.
%Final test - take a forced choice response between M1P2 and M2P1.

global parameters
    
    %Ext movies 
    movietoplay_extPath = strcat('Movies/', char(parameters.extTestPathVid(trialNo)));
    movietoplay_extManner = strcat('Movies/', char(parameters.extTestMannerVid(trialNo)));

    %Ext audio
    soundtoplay_extWhichOne = strcat('Audio_stimuli_creation/Finished/', char(parameters.extWhichOne(trialNo)));
    soundtoplay_extLetsFind = strcat('Audio_stimuli_creation/Finished/aa_lets_find/', char(parameters.extLetsFind(trialNo)));
  
    %Ext stars
    extStarImage = strcat('stars/', char(parameters.extStarImage(trialNo)));
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TEST
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Show_Blank;
    
    Play_Sound(soundtoplay_extLetsFind, 'toBlock');
    Show_Blank;      
           
    %Using the human-interpretable side variables instead...
    if parameters.mannerSideExt(trialNo) == 'L'
        PlaySideMovies(movietoplay_extManner,'');
        PlaySideMovies('',movietoplay_extPath);
    elseif parameters.mannerSideExt(trialNo) == 'R'
        PlaySideMovies(movietoplay_extPath,'');
        PlaySideMovies('',movietoplay_extManner);
    end
        

    %And take a response
    Play_Sound(soundtoplay_extWhichOne, 'toBlock');
    parameters.extTestAns{trialNo} = Take_Response();
    Show_Blank();


    
%%%%%%%%%%%%%%%%%%%%%%
% SHOW A NICE REWARD PICTURE
%%%%%%%%%%%%%%%%%%%%%%

    imageArray = imread(char(parameters.extStarImage(trialNo)));
    rect = parameters.scr.rect;
    winPtr = parameters.scr.winPtr;   
    Screen('PutImage', winPtr , imageArray, rect );    
    Screen('flip',winPtr)
    resp1 = Take_Response(); %just moving on...
    Show_Blank;
    
    
end




