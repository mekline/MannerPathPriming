function [] = WriteResultFile(infoVector)

%A simpler function that writes out whatever you give it, with commas
%between!  It makes sure everything is a char before sending it along.

global parameters


stringOut = '';

for v=1:length(infoVector)
    if isnumeric(infoVector{v})
        nextString = num2str(infoVector{v});
    else
        nextString = char(infoVector{v});
    end
    
    stringOut = strcat(stringOut, ',', nextString);
end
        
stringOut = strcat(stringOut, '\n');

% Write trial result to the file!
fprintf(parameters.datafilepointer, stringOut);


end