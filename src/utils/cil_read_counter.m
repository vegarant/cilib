% Reads the current count and add 1 to it.
%
% This script is intended as a helper function for large scale simulation.
% The file pointed to by `path` is assumed to be a single line text file
% containing one single number "The count". The script reads the current 
% "The count" adds 1 to it and write the new count back to the file. The 
% current count is returned. 
%
% INPUT:
% path - path to a text file one line and one number on that line.
%
% OUTPUT:
% count - The function returns the current count. It also update the count in
%         the pointed to by path. 
function count = cil_read_counter(path)

    fID = fopen(path, 'r');

    count = fscanf(fID, '%f');
    fclose(fID);

    fID = fopen(path, 'w');
    fprintf(fID, '%d\n', count + 1);
    fclose(fID);

end 

