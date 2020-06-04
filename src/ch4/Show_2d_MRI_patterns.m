% Create different 2d MRI sampling patterns and write them to file
% The patterns created are
% - Power law horizontal lines
% - Two types of spiral patterns
% - Radial lines going through the center

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';

r = 8;
N = 2^r;
subsampling_ratio = 0.15;
nbr_samples = round(subsampling_ratio*N*N);


alpha = 1;
[idx1 , ~] = cil_spf2_power_law_2d_hlines(N, nbr_samples, alpha);
a = 0.5;
b = 0.3;
[idx2 , ~] = cil_spf2_spiral(N, nbr_samples, a, b);
a = 0.5;
b = 0.1;
[idx3 , ~] = cil_spf2_spiral(N, nbr_samples, a, b);
nbr_of_lines = 22;
all_samples = 0;
[idx4, ~] = cil_spf2_radial_lines(N, nbr_samples, nbr_of_lines, all_samples);

Z1 = zeros([N,N], 'uint8');
Z2 = zeros([N,N], 'uint8');
Z3 = zeros([N,N], 'uint8');
Z4 = zeros([N,N], 'uint8');

Z1(idx1) = uint8(255);
Z2(idx2) = uint8(255);
Z3(idx3) = uint8(255);
Z4(idx4) = uint8(255);

fname1 = ['2d_patt_hlines.', cil_dflt.image_format];
fname2 = ['2d_patt_spiral1.', cil_dflt.image_format];
fname3 = ['2d_patt_spiral2.', cil_dflt.image_format];
fname4 = ['2d_patt_radial_lines.', cil_dflt.image_format];

imwrite(Z1, fullfile(dest, fname1));
imwrite(Z2, fullfile(dest, fname2));
imwrite(Z3, fullfile(dest, fname3));
imwrite(Z4, fullfile(dest, fname4));


