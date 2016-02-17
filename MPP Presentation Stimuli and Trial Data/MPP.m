function MPP(subNo, condition, willextend, runmode)

%Code based on sign meaning experiment, Feb 2014
%                         
%subNo, the subject number to run. Subject code above
%99 is for testing; data overwrite will not be checked.
%
%
%condition, one of 6 set lists of items, specify 1-6
% 1= MannerOfMotionCondition (agentive manners)
% 2= MannerOfMotionCondition_Instrumental
% 3= PathCondition (agentive manners)
% 4= PathCondition_Instrumental
% 5= EffectCondition
% 6= MeansCondition
%
% Use mode parameter to specify we want to run a pilot version with
% just 2 trials (of reg & extension, if it's extension, and no noun training!

%Add paths to subfolders in case matlab can't find them...
addpath('HelperFunctions', 'finalMovies', 'stars')

%Set up mode
switch nargin
    case 4
        %parameters set, move on
    case 3
        runmode = 'exp'; %It's a normal participant!
    case 2
        runmode = 'exp';
        willextend = 'NoExtend'; 
    otherwise
        error('Not enough parameters!!');
end


%Did we get a condition number or a string?
%Convert named convenience parameters to numbers!
if ischar(condition)
    switch condition
        case 'Manner'
            condition = 1;
        case 'Path'
            condition = 3;
        otherwise
            error ('You cannot use that condition here yet, use MPP_Extension_Manner_Path or _Means_Effect for now!')
    end
end

%object that stores all exp/session values
global parameters

parameters.datafilepointer = AssignDataFile('MannerPathPriming',subNo);



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
    
    % Sets specific values for this participant
    parameters.subNo = subNo;
    
    %Read the file into matlab
    vidNames = read_mixed_csv('MPP.csv',',')
    
    %Routine to pick the specified signList (algebra to get us the right rows)
    start_Index = (8*condition)-6;
    end_Index = (8*condition)+1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %Turn list into vectors of variables
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parameters.Experiment = vidNames(start_Index:end_Index, 2);
    parameters.amyFileName = vidNames(start_Index:end_Index, 3);
    parameters.itemID = vidNames(start_Index:end_Index, 4);
    parameters.eventType = vidNames(start_Index:end_Index, 5);
    parameters.Condition = vidNames(start_Index:end_Index, 6);
    parameters.Manner = vidNames(start_Index:end_Index, 7);
    parameters.Path = vidNames(start_Index:end_Index, 8);
    parameters.verbName = vidNames(start_Index:end_Index, 9);
    parameters.verbMeaning = vidNames(start_Index:end_Index, 10);
    parameters.ambigGoingTo = vidNames(start_Index:end_Index, 11);
    parameters.ambigDidIt = vidNames(start_Index:end_Index, 12);
    parameters.ambigV = vidNames(start_Index:end_Index, 13);
    parameters.whichOne = vidNames(start_Index:end_Index, 14);
    parameters.mBiasV = vidNames(start_Index:end_Index, 15); 
    parameters.pBiasV = vidNames(start_Index:end_Index, 16);
    parameters.trainS1GoingTo = vidNames(start_Index:end_Index, 17);
    parameters.trainS1DidIt = vidNames(start_Index:end_Index, 18);
    parameters.trainV1 = vidNames(start_Index:end_Index, 19);
    parameters.trainS2GoingTo = vidNames(start_Index:end_Index, 20);
    parameters.trainS2DidIt = vidNames(start_Index:end_Index, 21);
    parameters.trainV2 = vidNames(start_Index:end_Index, 22);
    parameters.trainS3GoingTo = vidNames(start_Index:end_Index, 23);
    parameters.trainS3DidIt = vidNames(start_Index:end_Index, 24);
    parameters.trainV3 = vidNames(start_Index:end_Index, 25);
    parameters.mTestV = vidNames(start_Index:end_Index, 26);
    parameters.pTestV = vidNames(start_Index:end_Index, 27);
    parameters.ambigAudioFuture = vidNames(start_Index:end_Index, 28);
    parameters.ambigAudioPast = vidNames(start_Index:end_Index, 29);
    parameters.trainAudioFuture1 = vidNames(start_Index:end_Index, 30);
    parameters.trainAudioPast1 = vidNames(start_Index:end_Index, 31);
    parameters.trainAudioFuture2 = vidNames(start_Index:end_Index, 32);
    parameters.trainAudioPast2 = vidNames(start_Index:end_Index, 33);
    parameters.trainAudioFuture3 = vidNames(start_Index:end_Index, 34);
    parameters.trainAudioPast3 = vidNames(start_Index:end_Index, 35);
    parameters.whichOneAudio = vidNames(start_Index:end_Index, 36);
    parameters.letsFindAudio = vidNames(start_Index:end_Index, 37);
    parameters.starImage = vidNames(start_Index:end_Index, 38);
    
    parameters.extPathEffect = vidNames(start_Index:end_Index, 40);
    parameters.extVerbName = vidNames(start_Index:end_Index, 41);
    parameters.extMannerMeans = vidNames(start_Index:end_Index, 42);
    parameters.extBiasVid = vidNames(start_Index:end_Index, 43);
    parameters.extAmbigAudioFuture =  vidNames(start_Index:end_Index, 44);
    parameters.extAmbigAudioPast = vidNames(start_Index:end_Index, 45);
    parameters.extTestMannerVid = vidNames(start_Index:end_Index, 46);
    parameters.extTestPathVid = vidNames(start_Index:end_Index, 47);
    parameters.extLetsFind = vidNames(start_Index:end_Index, 48);
    parameters.extWhichOne = vidNames(start_Index:end_Index, 49);
    parameters.extStarImage = vidNames(start_Index:end_Index, 50); 
    
    parameters.biasTestAns = {};
    parameters.finalTestAns = {};
    
    parameters.extTestAns = {};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % Now randomize everything (apply random order to all columns/objects)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    parameters.ambigGoingTo = parameters.ambigGoingTo(myRandOrder)
    parameters.ambigDidIt = parameters.ambigDidIt(myRandOrder)
    parameters.ambigV = parameters.ambigV(myRandOrder)
    parameters.whichOne = parameters.whichOne(myRandOrder)
    parameters.mBiasV = parameters.mBiasV(myRandOrder)
    parameters.pBiasV = parameters.pBiasV(myRandOrder)
    parameters.trainS1GoingTo = parameters.trainS1GoingTo(myRandOrder)
    parameters.trainS1DidIt = parameters.trainS1DidIt(myRandOrder)
    parameters.trainV1 = parameters.trainV1(myRandOrder)
    parameters.trainS2GoingTo = parameters.trainS2GoingTo(myRandOrder)
    parameters.trainS2DidIt = parameters.trainS2DidIt(myRandOrder)
    parameters.trainV2 = parameters.trainV2(myRandOrder)
    parameters.trainS3GoingTo = parameters.trainS3GoingTo(myRandOrder)
    parameters.trainS3DidIt = parameters.trainS3DidIt(myRandOrder)
    parameters.trainV3 = parameters.trainV3(myRandOrder)
    parameters.mTestV = parameters.mTestV(myRandOrder)
    parameters.pTestV = parameters.pTestV(myRandOrder)
    parameters.ambigAudioFuture = parameters.ambigAudioFuture(myRandOrder)
    parameters.ambigAudioPast = parameters.ambigAudioPast(myRandOrder)
    parameters.trainAudioFuture1 = parameters.trainAudioFuture1(myRandOrder)
    parameters.trainAudioPast1 = parameters.trainAudioPast1(myRandOrder)
    parameters.trainAudioFuture2 = parameters.trainAudioFuture2(myRandOrder)
    parameters.trainAudioPast2 = parameters.trainAudioPast2(myRandOrder)
    parameters.trainAudioFuture3 = parameters.trainAudioFuture3(myRandOrder)
    parameters.trainAudioPast3 = parameters.trainAudioPast3(myRandOrder)
    parameters.whichOneAudio = parameters.whichOneAudio(myRandOrder)
    parameters.letsFindAudio = parameters.letsFindAudio(myRandOrder)
    
    
    %%%%%%%%%%
    % In addition to randomizing trial order, randomize side presentation
    % of M and P at bias and test
    %%%%%%%%%%
    
    %Randomize sides for target and distractor movies
    parameters.LorR_bias = randi([0 1], length(start_Index:end_Index),1);
    parameters.LorR_final = randi([0 1], length(start_Index:end_Index),1);
    
    %Make a more human-readable version actually
    parameters.mannerSideBias(parameters.LorR_bias == 0) = 'R';
    parameters.mannerSideBias(parameters.LorR_bias == 1) = 'L';
    parameters.pathSideBias(parameters.LorR_bias == 0) = 'L';
    parameters.pathSideBias(parameters.LorR_bias == 1) = 'R';
    %annelot I found it? -mk 10/30 (was .LoR_bias before)
    parameters.mannerSideFinal(parameters.LorR_final == 0) = 'L';
    parameters.mannerSideFinal(parameters.LorR_final == 1) = 'R';
    parameters.pathSideFinal(parameters.LorR_final == 0) = 'R';
    parameters.pathSideFinal(parameters.LorR_final == 1) = 'L' ;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save a header file to the data file so it will be easier to read!
    WriteResultFile({'SubjectNo',...
        'Date',...
        'Time',...
        'Experiment',...
        'trialNo',...
        'itemID',...
        'verbName',...
        'verbMeaning',...
        'mannerSideBias',...
        'pathSideBias',...
        'kidResponseBias',...
        'mannerSideTest',...
        'pathSideTest',...
        'kidResponseTest',...
        'noun1Test',...
        'noun2Test',...
        'totalTime',...
        'xxxxxxxxx',...
        'expStartTime',...
        'trainingStartTime',...
        'trainingEndTime',...
        'finalTestStart',...
        'finalTestEnd',...
        'ambigVid',...
        'mBiasVid',...
        'pBiasVid',...
        'trainVid1',...
        'trainVid2',...
        'trainVid3',...
        'mTestVid',...
        'pTestVid',...
        'ambigAudioFuture',...
        'ambigAudioPast',...
        'trainAudioFuture1',...
        'trainAudioPast1',...
        'trainAudioFuture2',...
        'trainAudioPast2',...
        'trainAudioFuture3',...
        'trainAudioPast3',...
        'whichOneAudio',...
        'letsFindAudio'});
    
    %%%%%%%%%%%%%%%%%%%%%
    % EXPERIMENT STARTS HERE
    %%%%%%%%%%%%%%%%%%%%%
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Text_Show('Press spacebar to start experiment.')
    Take_Response();
    Show_Blank();
    
    expStart = GetSecs;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    Play_Sound('Audio/Finished/aa_motivation/getready.wav', 'toBlock');
    Show_Blank();
    
    starImageStart = 'stars/stars.001.jpg';
    imageArray = imread(starImageStart);
    
    rect = parameters.scr.rect;
   
    winPtr = parameters.scr.winPtr;
    
    Screen('PutImage', winPtr , imageArray, rect );
    
    Screen('flip',winPtr);
    Take_Response();
    Show_Blank;
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2 TRIALS OF NOUN TRAINING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(runmode, 'exp')
        MPP_Noun_Training();
    else
        parameters.noun1TestAns = 'pilot';
        parameters.noun2TestAns = 'pilot';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % N TRIALS OF WITHIN-FIELD PRIMING/VERB LEARNING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % How many trials?
    if strcmp(runmode, 'exp')
        ntrials = length(parameters.pBiasV);
    else
        ntrials = 2; %For the skeleton, play some short sample trials!
    end
    
    Text_Show('Ready? Press space to watch the movies.');
    Take_Response();
    
    %And actually play the trials! Data is saved on each round to allow for
    %partial data collection
    for i=1:ntrials
        
        %Trials have slightly different structure if they will be followed
        %by extension trials (different star arrays - TOFIX this should
        %just be parameters to one method...)
        if strcmp(willextend, 'Extend')
            Trial_MP_toExtend(i);
        else
            Trial_MP_noExtend(i);
        end
        
        expEnd = GetSecs;
        totalTime = expEnd - expStart;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Write result file
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        WriteResultFile({parameters.subNo,...
            datestr(now,'dd-mmm-yyyy'),...
            datestr(now,'HH:MM:SS.FFF'),...
            parameters.amyFileName(i),...
            i,...
            parameters.itemID(i),...
            parameters.verbName(i),...
            parameters.verbMeaning(i),...
            parameters.mannerSideBias(i),...
            parameters.pathSideBias(i),...
            parameters.biasTestAns(i),...
            parameters.mannerSideFinal(i),...
            parameters.pathSideFinal(i),...
            parameters.finalTestAns(i),...
            parameters.noun1TestAns,...
            parameters.noun2TestAns,...
            totalTime,...
            'xxxx',...
            expStart,...
            parameters.trainStart(i),...
            parameters.trainEnd(i),...
            parameters.finalTestStart(i),...
            parameters.finalTestEnd(i),...
            parameters.ambigV(i),...
            parameters.mBiasV(i),...
            parameters.pBiasV(i),...
            parameters.trainV1(i),...
            parameters.trainV2(i),...
            parameters.trainV3(i),...
            parameters.mTestV(i),...
            parameters.pTestV(i),...
            parameters.ambigAudioFuture(i),...
            parameters.ambigAudioPast(i),...
            parameters.trainAudioFuture1(i),...
            parameters.trainAudioPast1(i),...
            parameters.trainAudioFuture2(i),...
            parameters.trainAudioPast2(i),...
            parameters.trainAudioFuture3(i),...
            parameters.trainAudioPast3(i),...
            parameters.whichOneAudio(i),...
            parameters.letsFindAudio(i)});
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


     