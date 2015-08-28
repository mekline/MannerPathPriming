function [] = AssignDataFiles()
% This returns various files for subject data, or throws an error that we already 
% ran that subject number!  Exit everything in that case...

global parameters

% Define filenames of input files and result file:
parameters.datafilename = strcat('Data/',parameters.experiment,'_',num2str(parameters.subNo),'_Info.dat'); % name of data file to write to

% check for existing result file to prevent accidentally overwriting
% files from a previous subject/session (except for subject numbers > 99):
if parameters.subNo<99 & fopen(parameters.datafilename, 'rt')~=-1
    %fclose('all');
    error('Result data file already exists! Choose a different subject number.');
    Closeout_PTool();
else
    parameters.datafile = fopen(parameters.datafilename,'wt'); % open ASCII file for writing
end

%If that worked, go ahead and prepare Tobii data files for this subject

qualityfile = strcat(parameters.experiment,'_', num2str(parameters.subNo),'_Quality.txt');
trackerfile = strcat(parameters.experiment,'_', num2str(parameters.subNo),'_Tracking.txt');
eventfile = strcat(parameters.experiment,'_', num2str(parameters.subNo),'_Events.txt');

parameters.qualityFileName = fullfile('./Data/', qualityfile); 
parameters.trackFileName = fullfile('./Data/', trackerfile); %So tobii will find the locations correctly!
parameters.eventFileName = fullfile('./Data/', eventfile);


end

