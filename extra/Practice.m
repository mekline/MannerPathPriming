ntrials = length(parameters.TargetMoviePath); %length of trial    

    for i=1:length(parameters.TargetMoviePath)
        if strcmp(char(parameters.Item(i)),'T1')
            parameters.TargetMoviePath = [parameters.TargetMoviePath, 'Movies2/T1_Train_X_Target.mov'];
            parameters.DistractorMoviePath = [parameters.DistractorMoviePath, 'Movies2/T1_Train_Y_Distractor.mov'];
            parameters.SignMoviePath = [parameters.SignMoviePath, 'Movies2/36_1_B_Train1.mov'];
        elseif strcmp(char(parameters.Item(i)),'T2')
            parameters.TargetMoviePath = [parameters.TargetMoviePath, 'Movies2/T2_Train_X_Target.mov'];
            parameters.DistractorMoviePath = [parameters.DistractorMoviePath, 'Movies2/T2_Train_Y_Distractor.mov'];
            parameters.SignMoviePath = [parameters.SignMoviePath, 'Movies2/159_2_A_Train2.mov']
        elseif strcmp(char(parameters.Item(i)),'T3')
            parameters.TargetMoviePath = [parameters.TargetMoviePath, 'Movies2/T3_Train_X_Target.mov'];
            parameters.DistractorMoviePath = [parameters.DistractorMoviePath, 'Movies2/T3_Train_Y_Distractor.mov'];
            parameters.SignMoviePath = [parameters.SignMoviePath, 'Movies2/184_2_B_Train2.mov']
        else
            parameters.BaselineMoviePath = [parameters.TargetMoviePath, char(parameters.TargetMoviePath(trialNo))];
            parameters.TestMoviePath = [parameters.DistractorMoviePath, char(parameters.DistractorMoviePath(trialNo))];
            parameters.SignMoviePath = [parameters.SignMoviePath, char(parameters.DistractorMoviePath(trialNo))];
        end
    end   
    
    for i=1:ntrials
         char(parameters.TargetMoviePath(i));
         char(parameters.DistractorMoviePath(i));
         char(parameters.SignMoviePath(i));
         response = TM_Trial_AK(i);  
         if response == 'q'
             break
         end
         WriteResultFile(i, response);
   end