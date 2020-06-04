% This file set variuous parameters to get consistency between files
% The parameters found in this file, will be considered as default parameters

clear('all'); close('all');

% Create destination for the data
dest = fullfile('..', 'var');
if (exist(dest) ~= 7) 
    mkdir(dest);
end

% cilib defaults
cil_dflt.font_size = 14; 
cil_dflt.marker_size = 8;
cil_dflt.color =[0,    0.4470,    0.7410]; % Blue 
cil_dflt.marker = 'o';
cil_dflt.marker_edge_color = [0,0,0]; % Black
cil_dflt.marker_face_color = [0,0,0]; % Black
cil_dflt.line_width = 2;
cil_dflt.image_format = 'png';
cil_dflt.plot_format = 'epsc';
cil_dflt.blue    = [0,    0.4470,    0.7410];
cil_dflt.yellow  = [1,1,0]; 
cil_dflt.green   = [102, 255, 51]./255;
cil_dflt.brown   = [153, 102, 51]./255;
cil_dflt.red     = [1, 0, 0];
cil_dflt.magenta = [1, 0, 1];
cil_dflt.cyan    = [0, 1, 1]; 
cil_dflt.black   = [0, 0, 0];

cil_dflt.line_color = 'k';
cil_dflt.spgl1_verbosity = 1;
cil_dflt.data_path = '/home/vegant/db-cs/cilib_data';

cil_dflt.cmap_matrix = jet(256);

save(fullfile(dest,'cilib_defaults.mat'));


