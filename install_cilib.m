% This install file tries to detect your 'startup.m' file and add the requiered
% cilib paths as default. It also add these paths to the current session.
% If this install file fails, you will have to find the 'startup.m' file 
% and add the requiered paths manually. 

% IMPROVE
% In the next version of this file, I should consider forking out the part of
% the code which  

dependent_paths = {fullfile('src','utils'), fullfile('src','samp_patt'), 'var'};

us_root = userpath();
startup_file = fullfile(us_root, 'startup.m'); 

if (exist('var') ~= 7)
    mkdir('var');
end
if (exist('data') ~= 7)
    mkdir('data');
end

if (exist(us_root) == 7 )
    
    fID = fopen(startup_file, 'a');
    
    fprintf(fID, strcat(...
                 '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', ...
                 '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n', ...
                 '%% These paths have automatically been added by the\n', ... 
                 '%% cilib_install.m belonging to cilib\n'));
    
    for cilib_path = dependent_paths 
        fprintf(fID, 'addpath %s\n', fullfile(pwd(), cilib_path{1}));
    end
    fprintf(fID, strcat( ... 
                 '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', ...
                 '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'));
    fclose(fID);
    fprintf('cilib have added the following paths:\n');
    for cilib_path = dependent_paths 
        fprintf('addpath %s\n', fullfile(pwd(), cilib_path{1}));
        addpath(sprintf('%s', fullfile(pwd(), cilib_path{1})))
    end
    fprintf(strcat(...
                 'to the file ', ... 
                 ' %s\n'), startup_file);
else 
    fprintf('cilib was unable to find the file startup.m\n');        
    fprintf('in your `userpath()`.');
    fprintf('Adding the following paths to the current session');
    for cilib_path = dependent_paths 
        fprintf('addpath %s\n', fullfile(pwd(), cilib_path{1}));
        addpath(sprintf('%s', fullfile(pwd(), cilib_path{1})));
    end
end

