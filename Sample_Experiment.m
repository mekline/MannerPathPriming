function Sample_Experiment(subNo, signList)
%The sign meaning experiment, Feb 2014
%
%subNo, the subject number to run. Subject code above
%99 is for testing; data overwrite will not be checked.
%
%Signlist - one of eight set lists of items, specify 1-8
%
%Note: Make sure that you add the helper functions to the path, otherwise
%it won't work. You can do this by clicking on the folder helper functions
% -> add to path.



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
    
    %PsychTool setup
    Setup_PTool();
    SetParameters();
      
    % Sets specific values for this participant
    parameters.subNo = subNo;

    %%%%%%%%%%%%%%%%%%%%%%
    % Randomization of files, conditions, etc. goes here! An example is
    % below (Annemarie K.)
    %%%%%%%%%%%%%%%%%%%%%%

%     %Read the file into matlab
%     vidNames = read_mixed_csv('Sign_Meaning_Items.csv',',');
%     
%     %Routine to pick the specified signList (algebra to get us the right rows)
%     start_Index = 14*(signList-1)+2;
%     end_Index = 14*signList + 1;
%     vidNames(start_Index:end_Index,:);
%     
%     %Turn list into vectors of variables
%     parameters.Item = vidNames(start_Index:end_Index, 2);
%     parameters.Contrast = vidNames(start_Index:end_Index, 3);
%     parameters.Type_Target = vidNames(start_Index:end_Index, 4);
%     parameters.Target = vidNames(start_Index:end_Index, 5);
%     parameters.Distractor = vidNames(start_Index:end_Index, 6);
%     parameters.Cohort = vidNames(start_Index:end_Index, 7);
%     parameters.SignerID = vidNames(start_Index:end_Index, 8);
%        
%     %Make video files (takes the video names from the .csv file)  
%     parameters.TargetMoviePath = vidNames(start_Index:end_Index, 10);
%     parameters.DistractorMoviePath = vidNames(start_Index:end_Index, 11);
%     parameters.SignMoviePath = vidNames(start_Index:end_Index, 12);
%     parameters.LeftMovie = vidNames(start_Index:end_Index, 13);
%     
%     %Now randomize everything (apply random order to all columns/objects)
%     myRandOrder = randperm(14); %This makes a list of the numbers 1-14, in a random order
%     parameters.Item = parameters.Item(myRandOrder);
%     parameters.Contrast = parameters.Contrast(myRandOrder);
%     parameters.Type_Target = parameters.Type_Target(myRandOrder);
%     parameters.Target = parameters.Target(myRandOrder);
%     parameters.Distractor = parameters.Distractor(myRandOrder);
%     parameters.Cohort = parameters.Cohort(myRandOrder);
%     parameters.SignerID = parameters.SignerID(myRandOrder);
%     parameters.TargetMoviePath = parameters.TargetMoviePath(myRandOrder);
%     parameters.DistractorMoviePath = parameters.DistractorMoviePath(myRandOrder);
%     parameters.SignMoviePath = parameters.SignMoviePath(myRandOrder);
%     
    %Randomize sides for target and distractor movies
    parameters.LeftMovie = {'T','T','T','T','T','T','T','D','D','D','D','D','D','D'}
    newRand = randperm(14); %how many trials?
    parameters.LeftMovie = parameters.LeftMovie(newRand);
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Experiment
    %%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%
    % Prelim Screen/Instructions
    %%%%%%%%%%%%%%%%%%%%%%
    
     Text_Show('Press Spacebar to start experiment.');
     Take_Response();
     
     %Save a header file to the data file so it will be easier to read!
     WriteResultFile({'SubjectNo',...
         'trialNo',...
         'LeftMovie',...
         'Response'}); 
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Trial Setup
    %%%%%%%%%%%%%%%%%%%%%%
     
     %ntrials = length(parameters.TargetMoviePath); %how many trials?
     ntrials = 3; %For the skeleton, play some short sample trials!
     
     for i=1:ntrials
         response = Sample_Trial(i);  
         if response == 'q'
             break
         end
         WriteResultFile({parameters.subNo, ...
             i, ...
             parameters.LeftMovie(i),...
             response}); %Note the curly brackets - this needs to be a cellarray of stuff you want to save
         
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

