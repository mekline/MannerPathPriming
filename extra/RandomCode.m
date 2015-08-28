%     while not(finishedWatchingMovie)
%         %Stim movies to play
%         Text_Show('A'); %display A above movie on left (how to get text to stay for whole time?)
%         WaitSecs(0.60)
%         PlaySideMoviesNew(movietoplay,0,0,0,0);
%         Show_Blank();
%         Text_Show2('B'); %display A above movie on right (how to get text to stay for whole time?)
%         WaitSecs(0.60)
%         PlaySideMoviesNew(0,movietoplay_two,0,0,0);
%         Show_Blank();


%     %Randomize order of items
%     ax = randperm(16);
%     bx = randperm(16);
%     cx = randperm(16);
%     dx = randperm(16);
%     ex = randperm(16);
%     fx = randperm(16);
%     gx = randperm(16);
%     hx = randperm(16);
%     
%     ux = randperm(2);
%     
%     %Now randomize everything (apply random order to all columns/objects)
%     parameters.Item = parameters.Item(ax)
%     parameters.Contrast = parameters.Contrast(bx)
%     parameters.Type_Target = parameters.Type_Target(cx)
%     parameters.Target = parameters.Target(dx)
%     parameters.Distractor = parameters.Distractor(ex)
%     parameters.Cohort = parameters.Cohort(fx)
%     parameters.SignerID = parameters.SignerID(gx)
%     %parameters.Side = parameters.Side(hx)
    
%       parameters.TargetMoviePathOne = {'Movies/Training/1_Train_BL.mov'};
%       parameters.DistractorMoviePathOne = {'Movies/Training/2_Train_BL.mov'};
%       parameters.SignMoviePathOne = {'Movies/Training/1_1_A_Train1.mov'};
%       parameters.TargetMoviePathTwo = {'Movies/Training/2_Train_BL.mov'};
%       parameters.DistractorMoviePathTwo = {'Movies/Training/2_Train_Change.mov'};
%       parameters.SignMoviePathTwo = {'Movies/Training/1_1_A_Train2.mov'};
% 
    %Randomize the order!

%     for i=1:parameters.List
%         if strcmp(char(parameters.List(i)), 'Train1')
%             parameters.TargetMoviePath = [parameters.TargetMoviePath(i), 'Movies/Training/1_Train_BL.mov']
%             parameters.DistractorMoviePath = [parameters.DistractorMoviePath(i), 'Movies/2_Train_BL.mov']
%             %parameters.SignMoviePath = {parameters.SignMoviePath(i), 'Movies/Training/____.mov'}
%         elseif strcmp(char(parameters.List(i)),'Train2')
%             parameters.TargetMoviePath = [parameters.TargetMoviePath(i), 'Movies/Training/1_Train_BL.mov'];
%             parameters.DistractorMoviePath = [parameters.DistractorMoviePath(i), 'Movies/Training/2_Train_BL.mov']
%             %parameters.SignMoviePath = {parameters.SignMoviePath(i), 'Movies/Training/____.mov'}
%         else
%             %Get movie name
%             TargetPath = strcat('Movies/', parameters.TargetMoviePath(i))
%             DistractorPath = strcat('Movies/', parameters.DistractorMoviePath(i))
%             %SignPath = strcat('Movies/', parameters.SignMoviePath(i))
% 
%             parameters.TargetMoviePath = [parameters.TargetMoviePath, strcat(TargetPath,bMov,'.mov')];
%             parameters.DistractorMoviePath = [parameters.DistractorMoviePath, strcat(DistractorPath,tMov,'.mov')];
%             parameters.SignMoviePath = [parameters.SignMoviePath, strcat(SignPath,xxx, '.mov')];
%         end
%     end