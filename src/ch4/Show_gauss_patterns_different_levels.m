% Create different 2d MRI sampling patterns and write them to file

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

r0 = 0;
nbr_levels1 = 7;
nbr_levels2 = 50;
a = 2;
[idx1, ~] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels1);
[idx2, ~] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels2);
idx3 = cil_spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels2);

Z1 = zeros([N,N], 'uint8');
Z2 = zeros([N,N], 'uint8');
Z3 = zeros([N,N], 'uint8');

Z1(idx1) = uint8(255);
Z2(idx2) = uint8(255);
Z3(idx3) = uint8(255);

fname1 = sprintf('fig41_patt_exp_l2_r_%d_r0_%d_a_%g.%s', nbr_levels1, r0, a, ... 
                 cil_dflt.image_format);
fname2 = sprintf('fig41_patt_exp_l2_r_%d_r0_%d_a_%g.%s', nbr_levels2, r0, a, ... 
                 cil_dflt.image_format);
fname3 = sprintf('fig41_patt_exp_l1_r_%d_r0_%d_a_%g.%s', nbr_levels2, r0, a, ... 
                 cil_dflt.image_format);

imwrite(Z1, fullfile(dest, fname1));
imwrite(Z2, fullfile(dest, fname2));
imwrite(Z3, fullfile(dest, fname3));



