% Compute various compressive sensing experiments with different binary sampling
% operators and wavelet reconstruction. 
% - Bernoulli & Wavelets
% - Walsh & Wavelets, variable density (VD) sampling pattern 
% - Walsh & Wavelets, uniformly random sampling pattern
%
% Note: The bernoulli matrix experiment uses quite a bit of memory.
%
% Vegard Antun 2017
%

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dwtmode('per', 'nodisp');


dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';

vm = 4;                                     % Number of vanishing moments
srate = 0.20;                               % ∈ [0,1]
sigma = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma

N = 256;
fname_core = 'peppers1';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
X = X/255;

nbr_samples = round(srate*N*N);


% Bernoulli wavelet
max_iterations = 1000;
fprintf('Computing Bernoulli wavelet db%d reconstruction\n', vm);
fname = sprintf('aBernoulli_%s_wavelet_srate_%d_db%d_maxItr_%d', fname_core, 100*srate, vm,max_iterations);
cil_sample_bernoulli_wavelet(X, srate, sigma, ... 
                         fullfile(dest, fname), vm, 'spgl1_iterations',max_iterations);

% Create variable density (VD) sampling pattern.
nbr_levels = 50;
radius = 2;
p_norm_exp = 0.5;
a = 2;
r0=2;
[idx, str_id] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm_exp);
% Walsh wavelet - VD pattern.
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_%s_wavelet_srate_%d_db%d_%s', fname_core, 100*srate, vm, str_id);
rec_wave = cil_sample_walsh_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

% Walsh Wavelet uniformly random
[idx, str_id] = cil_sp2_uniform(N, nbr_samples);
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_%s_wavelet_srate_%d_db%d_%s', fname_core, 100*srate, vm, str_id);
cil_sample_walsh_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

