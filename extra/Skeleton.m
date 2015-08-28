function TM(subNo)
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

    
    %Here's how to randomize things, by the way (you can copy these 3 lines
    %into the matlab prompt to see what they do
    List1 = {'twinkle'; 'twinkle'; 'little';'star'};
    myRandOrder = randperm(4); %This makes a list of the numbers 1-4, in a random order
    List1 = List1(myRandOrder); %This gives you back list1 in a random order

    
    %In real life these would get set by a randomization procedure...here
    %we just add them directly to the lists...
    parameters.BaselineMoviePath = {'Movies/Training/2_Train_BL.mov'};
    parameters.TestMoviePath = {'Movies/Training/2_Train_Change.mov'};
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Experiment
    %%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Prelim Screen/Instructions
    %%%%%%%%%%%%%%%%%%%%%%
    
    Text_takeKey('Press Spacebar to start experiment (same=z, diff=x)', parameters.space);

    
    %%%%%%%%%%%%%%%%%%%%%%
    % Trial Setup
    %%%%%%%%%%%%%%%%%%%%%%
     
     ntrials = length(parameters.BaselineMoviePath);
     
     for i=1:ntrials
         char(parameters.BaselineMoviePath(i));
         char(parameters.TestMoviePath(i));
         response = TM_Trial(i);  
         if response == 'q'
             break
         end
         WriteResultFile(i, response);
       end
% 
    %%%%%%%%%%%%%%%%%%%%%%
    % Cleanup & Shutdown
    %%%%%%%%%%%%%%%%%%%%%%
    
     Closeout_PTool();
     
catch
    
    % catch error: in case anything went wrong...
    % Do same cleanup as at the end of a regular session...
    Closeout_PTool();
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);

end

end

