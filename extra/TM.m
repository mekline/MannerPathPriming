function TM(subNo, lengths, lists)
%Runs the match/mismatch task for the event-sequence Temporal Memory
%project
%
%
%Input parameters:
%
%subNo, the subject number to run. Subject code above
%99 is for testing; data overwrite will not be checked.
%
%lengths, the length of sequences to use - either 'five' or
%'fivefour' for both
%
%lists, how many lists to show (1 or 2)


%%%%%%%%%%%%%%%%%%%%%%%%%
% Preliminary stuff
%%%%%%%%%%%%%%%%%%%%%%%%%

global parameters

% File handling - makes the file where data will be stored
parameters.datafilepointer = AssignDataFile('TM',subNo);

try
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Parameter Setting
    %%%%%%%%%%%%%%%%%%%%%%
    
    %PsychTool setup
    Setup_PTool();
    SetParameters();
    
    % Sets specific values for this participant
    parameters.subNo = subNo;
    parameters.lengths = lengths;
    parameters.numLists = lists;
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Choose video settings for this participant
    %%%%%%%%%%%%%%%%%%%%%%
    
    %Randomize the changes they'll see
    for i=1:2
    
        %Total change/nochange assignments to be given in a list of 12
        changeSet = {'Baseline', 'Baseline', 'Baseline', 'Baseline', 'TempEasy',...
            'TempMed', 'TempH1M2', 'TempH1M2', 'TempHard', 'TempHard', 'Object', 'Manner'};

        %Total length asignments to be given in a list of 12 - divided between
        %change and nochange, since those get set separately
        if strcmp(char(parameters.lengths), 'fivefour')
            changeLengths = {'five', 'five', 'five', 'five', 'four', 'four', 'four', 'four'};
            ix = randperm(length(changeLengths));
            changeLengths = changeLengths(ix);
            noChangeLengths = {'five', 'five', 'four', 'four'};
            ix = randperm(length(noChangeLengths));
            noChangeLengths = noChangeLengths(ix);

            lengthSet = [noChangeLengths, changeLengths];
        else
            lengthSet = {'five', 'five', 'five', 'five', 'five', 'five', 'five', 'five',...
                'five', 'five', 'five', 'five'};
        end
        
        %And randomize presentation order!
        ax = randperm(length(changeSet));
        
        if i==1
            List1Changes = changeSet(ax);
            List1Lengths = lengthSet(ax);
        elseif i==2
            List2Changes = changeSet(ax);
            List2Lengths = lengthSet(ax);
        end
    end
    
    %And get the actual videos and video links!
    vidNames = read_mixed_csv('Temporal_Items.csv',',');
    List1Names = vidNames(2:13,:);
    List2Names = vidNames(14:25,:);
    trainingNames = vidNames(26:27,:);
    
    %Randomize sequences and choose list order
    ax = randperm(12);
    ox = randperm(12);
    ux = randperm(2);
    
    List1Names = List1Names(ax,:);
    List2Names = List2Names(ox,:);
    trainingNames = trainingNames(ux,:);
    
    listOrder = randperm(2);
    
    
    %And add everything to the arrays!
    parameters.Change = {};
    parameters.Length = {};
    parameters.List = {};
    parameters.Sequence = {};
    
    %TRAINING
    nTrain = size(trainingNames);
    parameters.Change = [parameters.Change, trainingNames(:,4)'];
    parameters.Length = [parameters.Length, {'training', 'training'}];
    parameters.List = [parameters.List, trainingNames(:,2)'];
    parameters.Sequence = [parameters.Sequence, trainingNames(:,1)'];
    
    %LISTS (stops if just 1!)
    for i = 1:lists
        thisList = listOrder(i);
        if thisList == 1
            changes = List1Changes;
            lengths = List1Lengths;
            names = List1Names;
        else
            changes = List2Changes;
            lengths = List2Lengths;
            names = List2Names;
        end
        
        nList = size(trainingNames);
        parameters.Change = [parameters.Change, changes];
        parameters.Length = [parameters.Length, lengths];
        parameters.List = [parameters.List, names(:,2)'];
        parameters.Sequence = [parameters.Sequence, names(:,1)'];
        
    end
    
    parameters.Change;
    parameters.Length;
    parameters.List;
    parameters.Sequence;
    
    %And then actually get all the video names recorded!!
    parameters.changeMapper = containers.Map({'Baseline', 'TempEasy', 'TempMed', ...
        'TempH1M2', 'TempHard', 'Object', 'Manner', 'DiffEvent'},...
        [0,1,2,3,4,5,6,7]);
    parameters.fiveStartIndex = 3;
    parameters.fourStartIndex = 13;
    
    parameters.BaselineMoviePath = {};
    parameters.TestMoviePath = {};
    
    for i=1:length(parameters.Change)
        if strcmp(char(parameters.Change(i)),'Train_Diff')
            parameters.BaselineMoviePath = [parameters.BaselineMoviePath, 'Movies/Training/2_Train_BL.mov'];
            parameters.TestMoviePath = [parameters.TestMoviePath, 'Movies/Training/2_Train_Change.mov'];
        elseif strcmp(char(parameters.Change(i)),'Train_Same')
            parameters.BaselineMoviePath = [parameters.BaselineMoviePath, 'Movies/Training/1_Train_BL.mov'];
            parameters.TestMoviePath = [parameters.TestMoviePath, 'Movies/Training/1_Train_BL.mov'];
        else
            %get moviename!
            BpathName = strcat('Movies/List ', parameters.List(i), '/', parameters.Length(i), '/Baseline/');
            TpathName = strcat('Movies/List', parameters.List(i), '/', parameters.Length(i), '/', parameters.Change(i) ,'/');
            
            %Indices for columns
            if strcmp(char(parameters.Length(i)),'five')
                b = (parameters.fiveStartIndex);
            elseif strcmp(char(parameters.Length(i)),'four')
                b = (parameters.fourStartIndex);
            end
            
            t = b + parameters.changeMapper(char(parameters.Change(i)));
            
            %Index for row
            r = find(~cellfun('isempty',strfind(vidNames(:,1),char(parameters.Sequence(i)))));
            
            bMov = vidNames(r, b);
            tMov = vidNames(r, t);

            parameters.BaselineMoviePath = [parameters.BaselineMoviePath, strcat(BpathName,bMov,'.mov')];
            parameters.TestMoviePath = [parameters.TestMoviePath, strcat(TpathName,tMov,'.mov')];
        end
    end
   
    
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
     
     ntrials = length(parameters.Change);
     
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

