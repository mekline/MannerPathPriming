function ReadParaFile(file)
% based on Rochester babylab script
% Author: Johnny, 3/7/09

global parameters

[keys, data] = textread(file, '%s %[^\n]');
num_lines_read = size(keys, 1);

%Scroll through para.txt lines and try to set parameters.  Needs a case
%line for every parameter in the file
try
    for i=1:num_lines_read
        switch keys{i}
            case 'experiment'
                k = textscan(data{i}, '%[^%]');
                parameters.experiment = strtrim(cast(k{1},'char'));
            case 'Debug'
                parameters.debug = sscanf(data{i},'%f');
            case 'ConnTobii'
                parameters.ConnTobii = sscanf(data{i},'%f');
            case 'CalibTobii'
                parameters.CalibTobii = sscanf(data{i},'%f');
            case 'ntrials'
                parameters.ntrials = sscanf(data{i},'%f');
            case 'stimnameLeft'
                k = textscan(data{i}, '%[^%]');
                tmp = strtrim(cast(k{1},'char'));
                parameters.stimnameLeft = regexp(tmp,' ', 'split');
            case 'stimnameRight'
                k = textscan(data{i}, '%[^%]');
                tmp = strtrim(cast(k{1},'char'));
                parameters.stimnameRight = regexp(tmp,' ', 'split');
            case 'verbnames'
                k = textscan(data{i}, '%[^%]');
                tmp = strtrim(cast(k{1},'char'));
                parameters.verbnames = regexp(tmp,' ', 'split');
            case 'bgcolor'
            	k = sscanf(data{i},'%f');
            	if strmatch(k, 'White')
            		parameters.scr.bgcolor = parameters.scr.white;
            	elseif strmatch(k, 'Black')
            		parameters.scr.bgcolor = parameters.scr.black;
            	elseif strmatch(k, 'Gray')
            		parameters.scr.bgcolor = parameters.scr.gray;
                end
            case 'hostName'
                parameters.hostName = sscanf(data{i},'%f');
            case 'portName'
                parameters.portName = sscanf(data{i},'%f');
            otherwise
                str = sprintf('Text file %s line# %d unknow keyword <%s>!',file,i, keys{i});
                %warndlg(str , '!! Warning !!');
                disp(str);
        end
    end
catch 
    error('Text file %s line# %d has error!',file,i);
end


%Some examples of fancier parameter reading/setting

%% After reading parameter file, we reset and calculate some parameters


% Example code - cleans up a directory name, and reads a bunch of
% filenames into a vector (parameters.imageBox)
% if parameters.imageBoxDir(end)~='/' && parameters.imageBoxDir(end)~='\'
%     parameters.imageBoxDir = [parameters.imageBoxDir '/'];
% end
% parameters.imageBox = [];
% tmpImageBoxFile = dir([parameters.imageBoxDir, '*.jpg']);
% j = 1;
% for i=1:length(tmpImageBoxFile)
%     if ~tmpImageBoxFile(i).isdir
%         parameters.imageBox(j).filename = [parameters.imageBoxDir tmpImageBoxFile(i).name];
%         j = j + 1;
%     end
% end
% if isempty(parameters.imageBox)
%     error('No any image files in the directory %s',parameters.imageBoxDir);
% end






