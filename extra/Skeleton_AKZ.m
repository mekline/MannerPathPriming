function TM(subNo, signList)
%Just the basics to run a study!
%subNo, the subject number to run. Subject code above
%99 is for testing; data overwrite will not be checked.
%
%If you want additional parameters (e.g. choose a list, rather
%than just randomly generating one), add their variable names
%above


%%%%%%%%%%%%%%%%%%%%%%%%%
% Preliminary stuff
%%%%%%%%%%%%%%%%%%%%%%%%%

global parameters

% File handling - makes the file where data will be stored
parameters.datafilepointer = AssignDataFile('TM',subNo);

try %everything goes inside a 'try' block, so if it crashes, it crashes 
    %cleanly (and maybe even tells us what went wrong)
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Parameter Setting
    %%%%%%%%%%%%%%%%%%%%%%
    
    %PsychTool setup
    Setup_PTool();
    SetParameters();
      
    % Sets specific values for this participant
    parameters.subNo = subNo;

    %%%%%%%%%%%%%%%%%%%%%%
    % Randomization of files, conditions, etc. goes here!
    %%%%%%%%%%%%%%%%%%%%%%

    %Read the file into matlab
    vidNames = read_mixed_csv('Skeleton_Practice2.csv',',');
    
    %Routine to pick list (algebra to get us the right rows)
    start_Index = 14*(signList-1)+2;
    end_Index = 14*signList + 1;
    vidNames(start_Index:end_Index,:);
    %To test: Skeleton_AK(99,1) Skeleton_AK(99,2) Skeleton_AK(99,3)
    
    %Turn list into vectors of variables
    parameters.Item = vidNames(start_Index:end_Index, 2);
    parameters.Contrast = vidNames(start_Index:end_Index, 3);
    parameters.Type_Target = vidNames(start_Index:end_Index, 4);
    parameters.Target = vidNames(start_Index:end_Index, 5);
    parameters.Distractor = vidNames(start_Index:end_Index, 6);
    parameters.Cohort = vidNames(start_Index:end_Index, 7);
    parameters.SignerID = vidNames(start_Index:end_Index, 8);
       
    %Make video files (takes the video names from the .csv file)  
    parameters.TargetMoviePath = vidNames(start_Index:end_Index, 10);
    parameters.DistractorMoviePath = vidNames(start_Index:end_Index, 11);
    parameters.SignMoviePath = vidNames(start_Index:end_Index, 12);
    parameters.LeftMovie = vidNames(start_Index:end_Index, 13);
    
    %Now randomize everything (apply random order to all columns/objects)
    myRandOrder = randperm(14); %This makes a list of the numbers 1-14, in a random order
    parameters.Item = parameters.Item(myRandOrder);
    parameters.Contrast = parameters.Contrast(myRandOrder);
    parameters.Type_Target = parameters.Type_Target(myRandOrder);
    parameters.Target = parameters.Target(myRandOrder);
    parameters.Distractor = parameters.Distractor(myRandOrder);
    parameters.Cohort = parameters.Cohort(myRandOrder);
    parameters.SignerID = parameters.SignerID(myRandOrder);
    parameters.TargetMoviePath = parameters.TargetMoviePath(myRandOrder);
    parameters.DistractorMoviePath = parameters.DistractorMoviePath(myRandOrder);
    parameters.SignMoviePath = parameters.SignMoviePath(myRandOrder);
    
    %Randomize sides for target and distractor movies
    parameters.LeftMovie = {'T','T','T','T','T','T','T','D','D','D','D','D','D','D'}
    newRand = randperm(14);
    parameters.LeftMovie = parameters.LeftMovie(newRand);
    
%     %%%%%%%%%%%%%%%%%%%%%%
%     % Experiment
%     %%%%%%%%%%%%%%%%%%%%%%
% 
%     %%%%%%%%%%%%%%%%%%%%%%
%     % Prelim Screen/Instructions
%     %%%%%%%%%%%%%%%%%%%%%%
    
     Text_takeKey('Press Spacebar to start experiment', parameters.space);
    
%     %%%%%%%%%%%%%%%%%%%%%%
%     % Trial Setup
%     %%%%%%%%%%%%%%%%%%%%%%
     
     ntrials = length(parameters.TargetMoviePath); %length of trial
     
     for i=1:ntrials
         char(parameters.SignMoviePath(i));
         char(parameters.TargetMoviePath(i));
         char(parameters.DistractorMoviePath(i));
         response = TM_Trial_AKY(i);  
         if response == 'q'
             break
         end
         WriteResultFile(i, response);
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

