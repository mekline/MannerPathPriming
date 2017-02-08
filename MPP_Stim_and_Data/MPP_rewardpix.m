function MPP(subNo, condition, extendcondition)

%Code based on sign meaning experiment, Feb 2014
%                         
%subNo, the subject number to run. Subject code above
%99 is for testing; data overwrite will not be checked.
%
%
%Old condition numbering for reference!
% 1= MannerOfMotionCondition (agentive manners)
% 2= MannerOfMotionCondition_Instrumental
% 3= PathCondition (agentive manners)
% 4= PathCondition_Instrumental
% 5= EffectCondition
% 6= MeansCondition
%
% Use mode parameter to specify we want to run a pilot version with
% just 2 trials (of reg & extension, if it's extension, and no noun training!

global parameters 

todebug = 0; %debuuuuug
parameters.nowrite = 0; %1=Optionally avoid trying to write files during debugging cause that ususally doesn't work!

assert(nargin > 1, 'Require Subno, Condition, optionally extension condition')
if(nargin == 2)
    extendcondition = 'NoExtend';
end


Conditions = {'Manner', 'Path', 'Action', 'Effect'};
knownCond = strfind(Conditions, condition);
k = logical(sum(~cellfun(@isempty, knownCond)));
assert(k, 'Use Manner Path Action or Effect for main exp')

ExtConditions = {'Extend', 'NoExtend'};
knownCond = strfind(ExtConditions, extendcondition);
k = logical(sum(~cellfun(@isempty, knownCond)));
assert(k, 'Use NoExtend or Extend for the extension (NoExtend is default)')



%Some numeric versions of condition names for indexing into tables...

switch condition
    case 'Manner'
        conditionno = 1;
    case 'Path'
        conditionno = 3;
    case 'Action'
        conditionno = 6;
    case 'Effect'
        conditionno = 5; %(yes #s reversed between domains for now)
end

switch extendcondition
    case 'NoExtend'
        toExtend = 0;
    otherwise
        toExtend = 1;
end

%Add paths to subfolders in case matlab can't find them...
addpath('HelperFunctions', 'finalMovies', 'stars');

%parameters object stores exp session values
parameters.datafilepointer = AssignDataFile_rp('MannerPathPriming',subNo);
parameters.condition = condition;
parameters.extendcondition = extendcondition;

global mainItems extItems %and these ones store trial values

try

    %%%%%%%%%%%%%%%%%%%%%%
    % Parameter Setting
    %%%%%%%%%%%%%%%%%%%%%%
    
    % PsychTool setup
    Setup_PTool();
    SetParameters();
    
    % Restrict keyboard
    KbName('UnifyKeyNames')
    parameters.space=KbName('space');
    parameters.space2=KbName('SPACE');
    parameters.z_press=KbName('z');
    parameters.c_press=KbName('c');
    parameters.w_press=KbName('w');
    parameters.p_press=KbName('p');    
    RestrictKeysForKbCheck([parameters.space parameters.z_press parameters.c_press parameters.space2 parameters.p_press parameters.w_press]);
    
    parameters.subNo = subNo;
    
    %%%%%%%%%%%%%%%%%%
    %NEW FILEREAD PROCEDURE STARTS HERE, WISH ME LUCK
    
    vidInfo = readtable('MPP_videos.csv');
    mainItems = vidInfo(vidInfo.List == conditionno,:);
    if toExtend %Assign the other-domain set! Since we don't do any learning, arbitrarily get Manner or Action
        if(conditionno == 1 |conditionno == 3) %Start with MannerPath, move to Action
            parameters.extendcondition = 'Action';
            extItems = vidInfo(vidInfo.List == 6,:);
        elseif (conditionno == 5 |conditionno == 6) %Start with ActionEffect, move to Manner
            parameters.extendcondition = 'Manner';
            extItems = vidInfo(vidInfo.List == 1,:);
        end
    end
    
    %Randomize the order of the items
    mainItems = mainItems(randperm(height(mainItems)), :);
    if toExtend
        extItems = extItems(randperm(height(extItems)), :);
    end
    
    %Add the star pictures _in order!!!_
    if toExtend
        myStars = dir('rewardpix/longstars*.jpeg');
        myStars = struct2cell(myStars);  
        myStars(1,:) = strcat('rewardpix/',myStars(1,:));
        parameters.nounStars = myStars(1,1:3);
        parameters.mainStars = myStars(1,4:11);
        parameters.extStars = myStars(1,12:19);
    else
        myStars = dir('rewardpix/longstars*.jpeg');
        myStars = struct2cell(myStars);
        myStars(1,:) = strcat('rewardpix/',myStars(1,:));
        parameters.nounStars = myStars(1,1:3);
        parameters.mainStars = myStars(1,4:11);
    end
    
    %Randomize the side presentation of the items
    %(Counterbalancing note: left video always plays first, assignment is
    %to play either the M or P video first.  Remember that we use
    %manner/path as the example case, you might be showing action/effect
    %really...
    
    %verbose code for readable output!
   
    screenside = ['LR';'LR';'LR';'LR';'RL';'RL';'RL';'RL'];
    
    screenside = screenside(randperm(8),:);
    mainItems.BiasManner = screenside(:,1);
    mainItems.BiasPath = screenside(:,2);
    
    screenside = screenside(randperm(8),:);
    mainItems.TestManner = screenside(:,1);
    mainItems.TestPath = screenside(:,2);
    
    if toExtend
        screenside = screenside(randperm(8),:);
        extItems.BiasManner = screenside(:,1);
        extItems.BiasPath = screenside(:,2);
        
        screenside = screenside(randperm(8),:);
        extItems.TestManner = screenside(:,1);
        extItems.TestPath = screenside(:,2);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save a header file to the data file so it will be easier to read!
    Write_Trial_to_File(0);
    %%%%%%%%%%%%%%%%%%%%%
    % EXPERIMENT STARTS HERE
    %%%%%%%%%%%%%%%%%%%%%
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Text_Show('Press spacebar to start experiment.')
    Take_Response();
    Show_Blank();
    
    parameters.expStart = GetSecs;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GET READY....
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~todebug
        Play_Sound('Audio/Finished/aa_motivation/getready.wav', 'toBlock');
        Show_Blank();
        
        starImageStart = parameters.nounStars{1}
        
        imageArray = imread(starImageStart);
        rect = parameters.scr.rect;
        winPtr = parameters.scr.winPtr;
        Screen('PutImage', winPtr , imageArray, rect );
        Screen('flip',winPtr);
        Take_Response();
        Show_Blank;
    end
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2 TRIALS OF NOUN TRAINING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~todebug
        MPP_Noun_Training();
    else
        parameters.noun1TestAns = 'pilot';
        parameters.noun2TestAns = 'pilot';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % N TRIALS OF WITHIN-FIELD PRIMING/VERB LEARNING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % How many trials?
    if ~todebug
        parameters.ntrials = height(mainItems);
    else
        parameters.ntrials = 2; %For the skeleton, play some short sample trials!
    end
    
    Text_Show('Ready? Press space to watch the movies.');
    Take_Response();
    
    %And actually play the trials! Data is saved on each round to allow for
    %partial data collection
    for i=1:parameters.ntrials
        Trial_Main(i)
        
        expEnd = GetSecs;
        parameters.totalTime = expEnd - parameters.expStart;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Write result file
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Write_Trial_to_File(i, mainItems);

    end
    
    %And do the same for the Extension trials, if we're doing that!
    for i=(parameters.ntrials+1):(2*parameters.ntrials)
        Trial_Extend(i);
        expEnd = GetSecs;
        parameters.totalTime = expEnd - parameters.expStart;
        Write_Trial_to_File(i, extItems);
    end
    
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Cleanup & Shutdown
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Closeout_PTool();
        

catch 
    Closeout_PTool();
    psychrethrow(psychlasterror);
    
end

end


     