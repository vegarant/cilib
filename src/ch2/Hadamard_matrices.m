% Script for visualizing the different Hadamard matrices. 

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

N = 32;

order_list = {'dyadic', 'sequency', 'hadamard'};
for i = 1:length(order_list)

    order = order_list{i};

    X = eye(N);
    Y = fwht(X, N, order)*N;
    Y = uint8(round(255*(0.5*(Y+1))))
    fname = sprintf('Had_mat_N_%d_%s.%s', N, order, cil_dflt.image_format);
    imwrite(Y, fullfile(dest,fname));

end

