% Create different Walsh sampling patterns and write them to file
% The patterns created are
% - Gaussian, l^2, a = 2, r = 50, r0 = 0
% - Gaussian, l^(1/2), a = 2, r = 50, r0 = 0, radius = 2
% - 2 level, l^2 norm, r_factor = 4

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

p_norm_2level = 2;
r_factor = 4;
r0 = 0;
nbr_levels = 50;
a = 2;
radius = 2;
p_norm_exp = 0.5;
[idx1, ~] = cil_sph2_2level(N, nbr_samples, p_norm_2level, r_factor);
[idx2, ~] = cil_sph2_gcircle(N, nbr_samples, a, r0, nbr_levels);
[idx3, ~] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm_exp);

Z1 = zeros([N,N], 'uint8');
Z2 = zeros([N,N], 'uint8');
Z3 = zeros([N,N], 'uint8');

Z1(idx1) = uint8(255);
Z2(idx2) = uint8(255);
Z3(idx3) = uint8(255);

fname1 = sprintf('fig43_patt_2level_l%d_m_div_%d.%s', p_norm_2level, r_factor, ... 
                 cil_dflt.image_format);
fname2 = sprintf('fig43_patt_exp_l2_r_%d_r0_%d_a_%g.%s', nbr_levels, r0, a, ... 
                 cil_dflt.image_format);
fname3 = sprintf('fig43_patt_exp_l0_5_r_%d_r0_%d_a_%g.%s', nbr_levels, r0, a, ... 
                 cil_dflt.image_format);

imwrite(flipud(Z1), fullfile(dest, fname1));
imwrite(flipud(Z2), fullfile(dest, fname2));
imwrite(flipud(Z3), fullfile(dest, fname3));




