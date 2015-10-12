function Sample_Experiment(subNo, condition)

%Code based on sign meaning experiment, Feb 2014
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

addpath('HelperFunctions')

global parameters

parameters.datafilepointer = AssignDataFile('MannerPathPriming',subNo);

try
    
    disp('Hey!')
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Parameter Setting
    %%%%%%%%%%%%%%%%%%%%%%
    
    % PsychTool setup
    Setup_PTool();
    SetParameters();
     
    % Restrict keyboard
    KbName('UnifyKeyNames')
    parameters.space=KbName('space');
    parameters.z_press=KbName('z');
    parameters.c_press=KbName('c');

    RestrictKeysForKbCheck([parameters.space parameters.z_press parameters.c_press]);
    
    % Sets specific values for this participant
    parameters.subNo = subNo;
    
    %Read the file into matlab
    vidNames = read_mixed_csv('new_final.csv',',')
    
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
    parameters.mBiasAns = vidNames(start_Index:end_Index, 16);
    parameters.pBiasV = vidNames(start_Index:end_Index, 17);
    parameters.pBiasAns = vidNames(start_Index:end_Index, 18);
    parameters.trainS1GoingTo = vidNames(start_Index:end_Index, 19);
    parameters.trainS1DidIt = vidNames(start_Index:end_Index, 20);
    parameters.trainV1 = vidNames(start_Index:end_Index, 21);
    parameters.trainS2GoingTo = vidNames(start_Index:end_Index, 22);
    parameters.trainS2DidIt = vidNames(start_Index:end_Index, 23);
    parameters.trainV2 = vidNames(start_Index:end_Index, 24);
    parameters.trainS3GoingTo = vidNames(start_Index:end_Index, 25);
    parameters.trainS3DidIt = vidNames(start_Index:end_Index, 26);
    parameters.trainV3 = vidNames(start_Index:end_Index, 27);
    parameters.mTestV = vidNames(start_Index:end_Index, 28);
    parameters.mTestAns = vidNames(start_Index:end_Index, 29);
    parameters.pTestV = vidNames(start_Index:end_Index, 30);
    parameters.pTestAns = vidNames(start_Index:end_Index, 31);
    parameters.movieLenght = vidNames(start_Index:end_Index, 32);
    parameters.ambigAudioFuture = vidNames(start_Index:end_Index, 33);
    parameters.ambigAudioPast = vidNames(start_Index:end_Index, 34);
    parameters.trainAudioFuture1 = vidNames(start_Index:end_Index, 35);
    parameters.trainAudioPast1 = vidNames(start_Index:end_Index, 36);
    parameters.trainAudioFuture2 = vidNames(start_Index:end_Index, 37);
    parameters.trainAudioPast2 = vidNames(start_Index:end_Index, 38);
    parameters.trainAudioFuture3 = vidNames(start_Index:end_Index, 39);
    parameters.trainAudioPast3 = vidNames(start_Index:end_Index, 40);
    parameters.whichOneAudio = vidNames(start_Index:end_Index, 41);
    parameters.letsFindAudio = vidNames(start_Index:end_Index, 42);
    parameters.starImage = vidNames(start_Index:end_Index, 43);
    
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
    parameters.mBiasAns = parameters.mBiasAns(myRandOrder)
    parameters.pBiasV = parameters.pBiasV(myRandOrder)
    parameters.pBiasAns = parameters.pBiasAns(myRandOrder)
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
    parameters.mTestAns = parameters.mTestAns(myRandOrder)
    parameters.pTestV = parameters.pTestV(myRandOrder)
    parameters.pTestAns = parameters.pTestAns(myRandOrder)
    parameters.movieLenght = parameters.movieLenght(myRandOrder)
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
    
    %Randomize sides for target and distractor movies
    parameters.LorR_bias = randi([0 1], length(start_Index:end_Index),1)
    parameters.LorR_final = randi([0 1], length(start_Index:end_Index),1)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    %Save a header file to the data file so it will be easier to read!
    WriteResultFile({'SubjectNo',...
        'trialNo',...
        'itemID',...
        'Experiment',...
        'mBiasAns',...
        'pBiasAns',...
        'LorR_bias',...
        'participantBiasAns',...  
        'mTestAns',...
        'pTestAns',...
        'LorR_final',...
        'participantTestAns',...  
        'noun1Test',...
        'noun2Test',...   
        'totalTime',...
        'expStartTime',...
        'trainingStartTime',...
        'trainingEndTime',...
        'finalTestStart',...
        'finalTestEnd',...
        'verbName',...
        'ambigV',...
        'mBiasV',...
        'pBiasV',...
        'trainV1',...
        'trainV2',...
        'trainV3',...
        'mTestV',...
        'pTestV',...
        'ambigAudioFuture',...
        'ambigAudioPast',...
        'trainAudioFuture1',...
        'trainAudioPast1',...
        'trainAudioFuture2',...
        'trainAudioPast2',...
        'trainAudioFuture3',...
        'trainAudioPast3',...
        'whichOneAudio',...
        'letsFindAudio',...     
        'Date',...
        'Time'});
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Text_Show('Press spacebar to start experiment.')
    Take_Response();
    Show_Blank();
    
    
    expStart = GetSecs;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    

    Play_Sound('Audio_stimuli_creation/Finished/aa_motivation/getready.wav', 'toBlock');
    Show_Blank();
    
    starImageStart = 'stars/stars.001.jpg';
    imageArray = imread(starImageStart);
   
    rect = parameters.scr.rect

    winPtr = parameters.scr.winPtr;

    Screen('PutImage', winPtr , imageArray, rect );

    Screen('flip',winPtr)
    Take_Response();
    Show_Blank;
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2 TRIALS OF NOUN TRAINING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    Noun_Training
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Trial Setup
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    % How many trials?
    %ntrials = length(parameters.pbiasV)
    ntrials = 1; %For the skeleton, play some short sample trials!
    
    Text_Show('Ready? Press space to watch the movies.');
    Take_Response();

        for i=1:ntrials
            Sample_Trial(i);
            
            expEnd = GetSecs;
            totalTime = expEnd - expStart;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Write result file
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            WriteResultFile({parameters.subNo,...
                i,...
                parameters.itemID(i),...
                parameters.amyFileName(i),...
                parameters.mBiasAns(i),...
                parameters.pBiasAns(i),...
                parameters.LorR_bias(i),...
                parameters.biasTestAns(i),...
                parameters.mTestAns(i),...
                parameters.pTestAns(i),...
                parameters.LorR_final(i),...
                parameters.finalTestAns(i),...
                parameters.noun1TestAns,...
                parameters.noun2TestAns,...
                expStart,...
                totalTime,...
                parameters.trainStart(i),...
                parameters.trainEnd(i),...
                parameters.finalTestStart(i),...
                parameters.finalTestEnd(i),...
                parameters.verbName(i),...
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
                parameters.letsFindAudio(i),...
                datestr(now,'dd-mmm-yyyy'),...
                datestr(now,'HH:MM:SS.FFF')});         
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



