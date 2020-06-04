% Compute various compressive sensing experiments with the following setup. 
% - Gauss sampling & wavelet reconstruction
% - Forirer samplin & wavelet reconstruction, multilevel sampling pattern
% - Forirer samplin & wavelet reconstruction, radial lines sampling pattern
%
% Vegard Antun 2017

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';

vm = 4;                                     % Number of vanishing moments
subsampling_rate = 0.20;                    % ∈ [0,1]
sigma = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma

N = 256;
fname = sprintf('brain1_%d.png', N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));

nbr_samples = round(subsampling_rate*N*N);


fully_sample = 0.100;
nbr_levels = 30;
p_norm = 2;
a = 2.5;
r0 = 2;
nbr_levels = 50;

[idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels); 

% Fourier wavelet - multilevel sampling pattern
fprintf('Computing wavelet reconstruction\n');
fname = sprintf('aFourier_wavelet_srate_%g_db%d_%s', subsampling_rate*100, vm, str_id);
cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

nbr_lines = 21;
all_samples = 1;
[idx, str_id] = cil_spf2_radial_lines(N, nbr_samples, nbr_lines, all_samples); 

% Fourier wavelet - Radial lines
fprintf('Computing wavelet reconstruction\n');
fname = sprintf('aFourier_wavelet_srate_%g_db%d_%s', subsampling_rate*100, vm, str_id);
cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

% Gauss wavelet
fname = sprintf('aFGauss_srate_%g_db%d_wavelet', subsampling_rate*100, vm);
cil_sample_gauss_wavelet(X, subsampling_rate, sigma, ... 
                         fullfile(dest, fname), vm);
