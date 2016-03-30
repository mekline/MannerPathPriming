function [response] = Trial_Extend(trialNo)
%Play 1 trial of the MannerPath experiment.
%This is just like Trial_Main except it plays whatever hte Extend movie 
%set it, and it just plays the bias test part of each trial!
%Bias test - show M1P1 movie; take a forced choice response between M1P2
%and M2P1

global parameters extItems
    
%This is the extend version, so adjust the global trial number to index
%into the extItems object

trialNo = trialNo - parameters.ntrials;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Trial movies
    movietoplay_ambigVid = strcat('Movies/', extItems.ambigV(trialNo));
    movietoplay_path = strcat('Movies/', extItems.pBiasV(trialNo));    
    movietoplay_manner = strcat('Movies/', extItems.mBiasV(trialNo));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUDIO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    soundtoplay_ambigAudioFuture = strcat('Audio/Finished/', extItems.ambigAudioFuture(trialNo));
    soundtoplay_ambigAudioPast = strcat('Audio/Finished/', extItems.ambigAudioPast(trialNo));
    soundtoplay_whichOne = strcat('Audio/Finished/', extItems.whichOneAudio(trialNo));
    soundtoplay_letsFind = strcat('Audio/Finished/aa_lets_find/', extItems.letsFindAudio(trialNo));
    
    %these ones are the same every time
    soundtoplay_letsWatchMore = 'Audio/Finished/aa_motivation/letswatchmore.wav';
    soundtoplay_getReady = 'Audio/Finished/aa_motivation/getready.wav';
    soundtoplay_goodJob = 'Audio/Finished/aa_motivation/goodjob.wav';
    soundtoplay_nowLetsSee = 'Audio/Finished/aa_motivation/nowletssee.wav';
    soundtoplay_wow = 'Audio/Finished/aa_motivation/wow.wav';
     
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STAR IMAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    starImage = parameters.extStars(trialNo); 
    greySquare = 'stars/grey.jpg';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY BIAS TEST VIDEO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioFuture{1}, 'toBlock');
    
        PlayCenterMovie(movietoplay_ambigVid{1});
        if strmatch(parameters.extendcondition, {'Action'}) %need a mask in between or they look super weird!
            imageArray = imread(greySquare);
            rect =  parameters.centerbox;
            winPtr = parameters.scr.winPtr;   
            Screen('PutImage', winPtr , imageArray, rect );    
            Screen('flip',winPtr)
            WaitSecs(0.500);
        end
        PlayCenterMovie(movietoplay_ambigVid{1});
        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioPast{1}, 'toBlock');
        
        Show_Blank; 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIAS TEST
% Play the two event movies; movie always plays L then R
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      
      
    %Using the human-interpretable side variables instead...
    if extItems.BiasManner(trialNo) == 'L'
        PlaySideMovies(movietoplay_manner{1},'');
        PlaySideMovies('',movietoplay_path{1});
    elseif extItems.BiasManner(trialNo) == 'R'
        PlaySideMovies(movietoplay_path{1},'');
        PlaySideMovies('',movietoplay_manner{1});
    end
        
    %And take a response
    Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
    extItems.biasTestAns{trialNo} = Take_Response();
    Show_Blank();
    
    %Fill in values for the rest of this item...
    extItems.finalTestEnd(trialNo) = GetSecs;
  
%%%%%%%%%%%%%%%%%%%%%%
% SHOW A NICE REWARD PICTURE
%%%%%%%%%%%%%%%%%%%%%%
    imageArray=imread(char(starImage));
    rect = parameters.scr.rect;
    winPtr = parameters.scr.winPtr;   
    Screen('PutImage', winPtr , imageArray, rect );    
    Screen('flip',winPtr)
    resp1 = Take_Response(); %just moving on...
    Show_Blank;
    
    
    if resp1 == 'q'
            Closeout_PTool();
    end
    
    
    
    
end




