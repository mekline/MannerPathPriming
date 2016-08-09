% The first thing I'm going to do is get the data I need in a reasonable format. 
% (To run this script, you need to first import data (allData.xlxs) as individual column vectors) 
impdata = [SubjectNo Condition trialNo choseMBias choseMTest]; %but these are the columns we care about

Actiondata = impdata(impdata(:,2)==0,1:5); %seperate into action and effect conidtions 
Effectdata = impdata(impdata(:,2)==1,1:5);

allactionsubjects = unique(Actiondata(:,1)); %Let's start with all the action subjects

%Now I am going to make a column vector that tells me the row numbers at
%which there is a new subject. E.g. Subject 1 starts at row 1, subject 2
%starts at row 16, and so on. 

imp_rows = nan(length(unique(Actiondata(:,1)))+1, 1); %preallocate: an empty variable to later put in the 
% important row numbers 
imp_rows(end,1) = length(Actiondata(:,1));
counter = unique(Actiondata(:,1));
count = 1; 
for i1 = 1:length(Actiondata(:,1)); %for loop to check for number changes 
    if count > length(counter) %this is for debugging
        continue
    elseif Actiondata(i1,1)==counter(count)%find the next unique subject number
         imp_rows(count,1)=i1; %write down the row number in our preallocated variable 
         count = count+1; %increase counter after finding a number change 
    end
end

all_action_bresponses = (Actiondata(:,4)); %this is a column vector of 1s and 0s, their responses on each trial, 
%for ALL the subjects and for all of the trials 

n_action = length(imp_rows) %find total number of participants in the action condition 
actionbscores = sum(reshape(all_action_bresponses,15,n_action)); %this sums every 15 rows 
% so that we get one bias score for every participant in the action condition
actionbscores = actionbscores'; %because we need to transpose it so that it's a column vector 

all_action_tresponses = (Actiondata(:,5));
actiontscores = nansum(reshape(all_action_tresponses,15,25));
% we use the function nansum because we went to ignore all the NaNs 
actiontscores = actiontscores';

all_action_scores = [imp_rows actionbscores actiontscores];

scatter(all_action_scores(:,2),all_action_scores(:,3))
lsline %makes a best fit line! 
xlabel('Action/Manner Responses on Bias Trials (Base + Extension)', 'FontSize', 10)
ylabel('Action/Manner Responses on Same-Verb Test Trials (Base)', 'FontSize', 10)
title('This is awesome (ACTION)', 'FontSize', 16,'FontWeight', 'bold')

% Now let's do all the effect subjects! 

alleffectsubjects = unique(Effectdata(:,1)); %Let's start with all the action subjects

%This is the same for loop as before; applied to the Effectdata 
effect_imp_rows = nan(length(unique(Effectdata(:,1)))+1, 1);
effect_imp_rows(end,1) = length(Effectdata(:,1));
counter = unique(Effectdata(:,1));
count = 1; 
for i1 = 1:length(Effectdata(:,1));
    if count > length(counter) %this is for debugging
        continue
    elseif Effectdata(i1,1)==counter(count)
         effect_imp_rows(count,1)=i1;
         count = count+1;
    end
end

all_effect_bresponses = (Effectdata(:,4)); %this is a column vector of 1s and 0s, their responses on each trial, 
% for ALL the subjects and for all of the trials 

n_effect = length(alleffectsubjects) % find total number of participants in effect condition
effectbscores = sum(reshape(all_effect_bresponses,15,n_effect)); %this sums every 15 rows 
% so that we get one bias score for every participant in the effect condition
effectbscores = effectbscores'; %because we need to transpose it so that it's a column vector 

all_effect_tresponses = (Effectdata(:,5));
effecttscores = nansum(reshape(all_effect_tresponses,15,22));
effecttscores = effecttscores';

all_effect_scores = [alleffectsubjects effectbscores effecttscores];
figure; 
scatter(all_effect_scores(:,2),all_effect_scores(:,3))
lsline
xlabel('Action/Manner Responses on Bias Trials (Base + Extension)', 'FontSize', 10)
ylabel('Action/Manner Responses on Same-Verb Test Trials (Base)', 'FontSize', 10)
title('This is awesome (EFFECT)', 'FontSize', 16,'FontWeight', 'bold')


% Let's make one big figure for both 
figure; 
subplot(1,2,1)
scatter(all_action_scores(:,2),all_action_scores(:,3),'ro') %plot action as red circles 
axis([0, 16, 0, 8]) %format is xmin, xmax, ymin, ymax: 0-16 on the bottom and 0-8 on top 
xlabel('Action/Manner Responses on Bias Trials (Base + Extension)', 'FontSize', 10)
ylabel('Action/Manner Responses on Same-Verb Test Trials (Base)', 'FontSize', 10)
title('ACTION Responses on Training and Bias Tests', 'FontSize', 16,'FontWeight', 'bold')

subplot(1,2,2) 
scatter(all_effect_scores(:,2),all_effect_scores(:,3),'bo') %plot effect as blue circles
axis([0, 16, 0, 8])
xlabel('Action/Manner Responses on Bias Trials (Base + Extension)', 'FontSize', 10)
ylabel('Action/Manner Responses on Same-Verb Test Trials (Base)', 'FontSize', 10)
title('EFFECT Responses on Training and Bias Tests', 'FontSize', 16,'FontWeight', 'bold')

%% This makes ONE SINGLE figure with both plots overlaid! 

figure; %first we plot action
scatter(all_action_scores(:,2),all_action_scores(:,3),'ro','jitter','on') %plot action as red circles 
hold on; %now we're going to plot effect overlaid 
scatter(all_effect_scores(:,2),all_effect_scores(:,3),'bo','jitter','on') %plot effect as blue circles
h = lsline; %we're going to need two best fit lines, one for action and one for effect
set(h(1),'color','b') %effect is blue
set(h(2),'color','r') %action is red
axis([0, 16, 0, 8]) %format is xmin, xmax, ymin, ymax: 0-16 on the bottom and 0-8 on top 
xlabel('Action/Manner Responses on Bias Trials (Base + Extension)', 'FontSize', 10)
ylabel('Action/Manner Responses on Same-Verb Test Trials (Base)', 'FontSize', 10)
% title('Responses on Training and Bias Tests', 'FontSize', 16,'FontWeight', 'bold') % if you want the title
legend('Action','Effect','location','northeastoutside')

%% Finding correlation coefficients 

[R_action, P_action] = corrcoef(all_action_scores(:,2),all_action_scores(:,3))
% the correlation coefficient for action is 0.7682, 
% the p value appears to be so small it has only 0s 

[R_effect, P_effect] = corrcoef(all_effect_scores(:,2),all_effect_scores(:,3))
% the correlation coefficient for effect is 0.7560, 
% same problem with the the p value! 
% so we're just going to write down that p < 0.00001 for both 