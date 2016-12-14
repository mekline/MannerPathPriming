function [datafilepointer] = AssignDataFile(prefix, subNo)
% This returns a file pointer, or throws an error that we already 
% ran that subject!  Exit everything in that case...

% Define filenames of input files and result file:
datafilename = strcat('Data_rp/',prefix,'_',num2str(subNo),'.dat'); % name of data file to write to

% check for existing result file to prevent accidentally overwriting
% files from a previous subject/session (except for subject numbers > 99):
if subNo<99 & fopen(datafilename, 'rt')~=-1
    %fclose('all');
    error('Result data file already exists! Choose a different subject number.');
    Closeout_PTool();
else
    datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing
end


end

