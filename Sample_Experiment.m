function Sample_Experiment(subNo, condition)
        
%The sign meaning experiment, Feb 2014
%                         
%subNo, the subject number to run. Subject code above
%99 is for testing; data overwrite will not be checked.
%
%
%condition, one of 6 set lists of items, specify 1-6
% 1= MannerOfMotionCondition
% 2= MannerOfMotionCondition_Instrumental
% 3= PathCondition
% 4= PathCondition_Instrumental
% 5= EffectCondition
% 6= MeansCondition
%
%
%
%Note: Make sure that you add the helper functions to the path, otherwise
%it won't work. You can do this by clicking on the folder helper functions
% -> add to path.

addpath('HelperFunctions')

%%%%%%%%%%%%%%%%%%%%%%%%%
% Preliminary stuff
%%%%%%%%%%%%%%%%%%%%%%%%%

global parameters

% File handling - makes the file where data will be stored
    parameters.datafilepointer = AssignDataFile('SampleExp',subNo);

try %everything goes inside a 'try' block, so if it crashes, it crashes 
    %cleanly (and maybe even tells us what went wrong)
    
    disp('Hey!')
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Parameter Setting
    %%%%%%%%%%%%%%%%%%%%%%
    
    % PsychTool setup
     Setup_PTool();
     SetParameters();
      
    % Sets specific values for this participant
    parameters.subNo = subNo;

    %%%%%%%%%%%%%%%%%%%%%%
    % Randomization of files, conditions, etc. goes here! An example is
    % below (Annemarie K.)
    %%%%%%%%%%%%%%%%%%%%%%  
%    
%    
%
%     %Read the file into matlab
%
% Note: ',' below depicts the delimeter in the csv file. Depending on the file, 
% this can either be ';' or ',' (or tab) (you can check this by printing the file,
% so without ; at the end of the line).
%
%
    vidNames = read_mixed_csv('Experiment_Items_final.csv',',')
%     
%                                             
%
%
%    %Routine to pick the specified signList (algebra to get us the right rows)
    
start_Index = (8*condition)-6;
end_Index = (8*condition)+1;


%     
%
%
%     %Turn list into vectors of variables
%
%
%
    parameters.Experiment = vidNames(start_Index:end_Index, 2)
    parameters.amyFileName = vidNames(start_Index:end_Index, 3)
    parameters.itemID = vidNames(start_Index:end_Index, 4)
    parameters.eventType = vidNames(start_Index:end_Index, 5)
    parameters.Condition = vidNames(start_Index:end_Index, 6)
    parameters.Manner = vidNames(start_Index:end_Index, 7)
    parameters.Path = vidNames(start_Index:end_Index, 8)
    parameters.verbName = vidNames(start_Index:end_Index, 9)
    parameters.verbMeaning = vidNames(start_Index:end_Index, 10)
    parameters.ambigS_not_recording = vidNames(start_Index:end_Index, 11)
    parameters.ambig_going_to = vidNames(start_Index:end_Index, 12)
    parameters.ambig_did_it = vidNames(start_Index:end_Index, 13)
    parameters.ambigV = vidNames(start_Index:end_Index, 14)
    parameters.which_one = vidNames(start_Index:end_Index, 15)
    parameters.mbiasV = vidNames(start_Index:end_Index, 16)
    parameters.mbiasAns = vidNames(start_Index:end_Index, 17)  
    parameters.pbiasV = vidNames(start_Index:end_Index, 18)              
    parameters.pbiasAns = vidNames(start_Index:end_Index, 19)
    parameters.trainS1_not_recording = vidNames(start_Index:end_Index, 20)
    parameters.trainS1_going_to = vidNames(start_Index:end_Index, 21)
    parameters.trainS1_did_it = vidNames(start_Index:end_Index, 22)
    parameters.trainV1 = vidNames(start_Index:end_Index, 23)
    parameters.trainS2_not_recording = vidNames(start_Index:end_Index, 24)
    parameters.trainS2_going_to = vidNames(start_Index:end_Index, 25)
    parameters.trainS2_did_it = vidNames(start_Index:end_Index, 26)
    parameters.trainV2 = vidNames(start_Index:end_Index, 27)
    parameters.trainS3_not_recording = vidNames(start_Index:end_Index, 28)
    parameters.trainS3_going_to = vidNames(start_Index:end_Index, 29)
    parameters.trainS3_did_it = vidNames(start_Index:end_Index, 30)
    parameters.trainV3 = vidNames(start_Index:end_Index, 31)
    parameters.which_one_not_recording = vidNames(start_Index:end_Index, 32)
    parameters.mtestV = vidNames(start_Index:end_Index, 33)
    parameters.mtestAns = vidNames(start_Index:end_Index, 34)
    parameters.ptestV = vidNames(start_Index:end_Index, 35)
    parameters.ptestAns = vidNames(start_Index:end_Index, 36)
    parameters.movieLenght = vidNames(start_Index:end_Index, 37)
    parameters.LeftMovie = vidNames(start_Index:end_Index, 38)
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
% %     %Now randomize everything (apply random order to all columns/objects)

    myRandOrder = randperm(8)
    parameters.Experiment = parameters.Experiment(myRandOrder)                      
    parameters.amyFileName = parameters.amyFileName(myRandOrder)
    parameters.itemID = parameters.itemID(myRandOrder)
    parameters.eventType = parameters.eventType(myRandOrder)
    parameters.Condition = parameters.Condition(myRandOrder)
    parameters.Manner = parameters.Manner(myRandOrder)
    parameters.Path = parameters.Path(myRandOrder)
    parameters.verbName = parameters.verbName(myRandOrder)
    parameters.verbMeaning = parameters.verbMeaning(myRandOrder)
    parameters.ambigS_not_recording = parameters.ambigS_not_recording(myRandOrder)
    parameters.ambig_going_to = parameters.ambig_going_to(myRandOrder)
    parameters.ambig_did_it = parameters.ambig_did_it(myRandOrder)
    parameters.ambigV = parameters.ambigV(myRandOrder)
    parameters.which_one = parameters.which_one(myRandOrder)
    parameters.mbiasV = parameters.mbiasV(myRandOrder)
    parameters.mbiasAns = parameters.mbiasAns(myRandOrder)
    parameters.pbiasV = parameters.pbiasV(myRandOrder)             
    parameters.pbiasAns = parameters.pbiasAns(myRandOrder)
    parameters.trainS1_not_recording = parameters.trainS1_not_recording(myRandOrder)
    parameters.trainS1_going_to = parameters.trainS1_going_to(myRandOrder)
    parameters.trainS1_did_it = parameters.trainS1_did_it(myRandOrder)
    parameters.trainV1 = parameters.trainV1(myRandOrder)
    parameters.trainS2_not_recording = parameters.trainS2_not_recording(myRandOrder)
    parameters.trainS2_going_to = parameters.trainS2_going_to(myRandOrder)
    parameters.trainS2_did_it = parameters.trainS2_did_it(myRandOrder)
    parameters.trainV2 = parameters.trainV2(myRandOrder)
    parameters.trainS3_not_recording = parameters.trainS3_not_recording(myRandOrder)
    parameters.trainS3_going_to = parameters.trainS3_going_to(myRandOrder)
    parameters.trainS3_did_it = parameters.trainS3_did_it(myRandOrder)
    parameters.trainV3 = parameters.trainV3(myRandOrder)
    parameters.which_one_not_recording = parameters.which_one_not_recording(myRandOrder)
    parameters.mtestV = parameters.mtestV(myRandOrder)
    parameters.mtestAns = parameters.mtestAns(myRandOrder)
    parameters.ptestV = parameters.ptestV(myRandOrder)
    parameters.ptestAns = parameters.ptestAns(myRandOrder)
    parameters.movieLenght = parameters.movieLenght(myRandOrder)
    parameters.LeftMovie = parameters.LeftMovie(myRandOrder)
                               
       
    %Randomize sides for target and distractor movies
    %parameters.LeftMovie = {'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D'}
    %newRand = randperm(1); %how many trials'
    %parameters.LeftMovie = parameters.LeftMovie(newRand);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Experiment
    %%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%
    % Prelim Screen/Instructions
    %%%%%%%%%%%%%%%%%%%%%%
    
     Text_Show('Press spacebar to start experiment.')
     Take_Response();    
    
     
     %Save a header file to the data file so it will be easier to read!
     WriteResultFile({'SubjectNo',...
         'trialNo',...
         'LeftMovie',...
         'Response'}); 
     
     
    %%%%%%%%%%%%%%%%%%%%%%
    % 2 TRIALS OF NOUN TRAINING
    %%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
    
    
     
     
     
     
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Trial Setup
    %%%%%%%%%%%%%%%%%%%%%%
    
    
    Text_Show('Ready? Press space to watch the movies.');
    response = Take_Response();
    %Want to finish early?
    if response == 'q'
        return
    end                                                                                                                                                                                                                                                                                                                                                                         
    
    
     
     %ntrials = length(parameters.pbias) %how many trials?

     ntrials = 1; %For the skeleton, play some short sample trials!


        
     for i=1:ntrials     
Text_Show('(((... is going to ...)))');
Take_Response();
Show_Blank;   



                 
Play_Sound('test.wav', 'toBlock')
Take_Response();
Show_Blank;
        


        Text_Show(char(parameters.ambigS_not_recording(i)));
         Take_Response();      
         
         
          response = Sample_Trial(i);  
         if response == 'q'                       
             break  

                                 
         end
         
         
         WriteResultFile({parameters.subNo, ...
             i, ...
             response}) %Note the curly brackets - this needs to be a cellarray of stuff you want to save
         
     end

    %%%%%%%%%%%%%%%%%%%%%%
    % Cleanup & Shutdown
    %%%%%%%%%%%%%%%%%%%%%%
    
     Closeout_PTool();
     
catch
    
    % Catch error: in case anything went wrong...
    % Do same cleanup as at the end of a regular session...
    Closeout_PTool();
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);

end

end

