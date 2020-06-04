% Create different Walsh sampling patterns and write them to file
% The patterns created are
% - Gaussian, l^2, a = 2, r = 50, r0 = 2
% - Gaussian, l^2, a = 1, r = 50, r0 = 2
% - Gaussian, l^1, a = 2, r = 50, r0 = 2
% - Gaussian, l^1, a = 1, r = 50, r0 = 2
% - DAS
% - DIS

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';

r = 9;
N = 2^r;
subsampling_ratio = 0.15;
nbr_samples = round(subsampling_ratio*N*N);

vm = 4;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);



r0 = 2;
nbr_levels = 50;
radius = 2;
p_norm_exp = 0.5;
a1 = 1;
a2 = 2;

[idx1, ~] = cil_sph2_gcircle(N, nbr_samples, a1, r0, nbr_levels);
fname1 = sprintf('fig48_patt_exp_l2_r_%d_r0_%d_a_%g.%s', nbr_levels, r0, a1, ... 
                 cil_dflt.image_format);

[idx2, ~] = cil_sph2_gcircle(N, nbr_samples, a2, r0, nbr_levels);
fname2 = sprintf('fig48_patt_exp_l2_r_%d_r0_%d_a_%g.%s', nbr_levels, r0, a2, ... 
                 cil_dflt.image_format);


[idx3, ~] = cil_sph2_exp(N, nbr_samples, a1, r0, nbr_levels, radius, p_norm_exp);
fname3 = sprintf('fig48_patt_exp_l0_5_r_%d_r0_%d_a_%g.%s', nbr_levels, r0, a1, ... 
                 cil_dflt.image_format);

[idx4, ~] = cil_sph2_exp(N, nbr_samples, a2, r0, nbr_levels, radius, p_norm_exp);
fname4 = sprintf('fig48_patt_exp_l0_5_r_%d_r0_%d_a_%g.%s', nbr_levels, r0, a2, ... 
                 cil_dflt.image_format);

im = phantom(N);
epsilon = 1;
sparsity = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
[idx5, ~] = cil_sph2_DAS(N, nbr_samples, sparsity);
fname5 = sprintf('fig48_patt_DAS.%s', cil_dflt.image_format);

[idx6, ~] = cil_sph2_DIS(N, nbr_samples, sparsity);
fname6 = sprintf('fig48_patt_DIS.%s', cil_dflt.image_format);


Z1 = zeros([N,N], 'uint8');
Z2 = zeros([N,N], 'uint8');
Z3 = zeros([N,N], 'uint8');
Z4 = zeros([N,N], 'uint8');
Z5 = zeros([N,N], 'uint8');
Z6 = zeros([N,N], 'uint8');

Z1(idx1) = uint8(255);
Z2(idx2) = uint8(255);
Z3(idx3) = uint8(255);
Z4(idx4) = uint8(255);
Z5(idx5) = uint8(255);
Z6(idx6) = uint8(255);

imwrite(flipud(Z1), fullfile(dest, fname1));
imwrite(flipud(Z2), fullfile(dest, fname2));
imwrite(flipud(Z3), fullfile(dest, fname3));
imwrite(flipud(Z4), fullfile(dest, fname4));
imwrite(flipud(Z5), fullfile(dest, fname5));
imwrite(flipud(Z6), fullfile(dest, fname6));


