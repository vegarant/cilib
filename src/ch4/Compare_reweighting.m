% Using standard Fourier sampling, we compare standard l1-minimization using wavelets
% with state-of-the-art methods. 
% To run this script it is necessary to install the ShearletReweighting dependency.
%
% Vegard Antun 2019

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';

vm = 4;                                     % Number of vanishing moments
subsampling_rate = 0.25;                    % ∈ [0,1]
sigma = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma
is_real = 0;
nbr_iterations = 100;
max_iterations = 2000;

N = 512;
fname_core = 'brain1';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
X = X/255;

nbr_samples = round(subsampling_rate*N*N);

alpha = 1;
[idx1, str_id1] = cil_spf2_power_law_2d_hlines(N, nbr_samples, alpha);

%%% Fourier wavelet
fprintf('Computing Fourier wavelet db%d reconstruction with %s\n', vm, str_id1);
fname = sprintf('aFourier_%s_wavelet_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id1);
rec_wave = cil_sample_fourier_wavelet(X, sigma, idx1, fullfile(dest, fname), vm,...
               'spgl1_iterations', max_iterations);

fprintf('Computing Fourier shearlet+tgv+reweighting db%d reconstruction with %s\n', vm, str_id1);
fname = sprintf('aFourier_%s_shear_tgv_reweighting_srate_%d_%s', fname_core, 100*subsampling_rate, str_id1);
rec_advanced = cil_sample_fourier_shearlet_tgv_reweighting(X, idx1, ...
                   fullfile(dest, fname), nbr_iterations);

nbr_levels = 50;
r0 = 0;
a = 2;
% Create sampling pattern
[idx2, str_id2] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
fprintf('Computing Fourier wavelet db%d reconstruction with %s\n', vm, str_id1);
fname = sprintf('aFourier_%s_wavelet_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id2);
rec_wave = cil_sample_fourier_wavelet(X, sigma, idx2, fullfile(dest, fname), vm,...
               'spgl1_iterations', max_iterations);

fprintf('Computing Fourier shearlet+tgv+reweighting db%d reconstruction with %s\n', vm, str_id1);
fname = sprintf('aFourier_%s_shear_tgv_reweighting_srate_%d_%s', fname_core, 100*subsampling_rate, str_id2);
rec_advanced = cil_sample_fourier_shearlet_tgv_reweighting(X, idx2, ...
                   fullfile(dest, fname), nbr_iterations);


