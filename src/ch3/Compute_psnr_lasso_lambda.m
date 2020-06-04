% This script computes and stores an array of PSNR values for different values
% of lambda, when solving LASSO with FISTA. To create the figure run
% `Create_psnr_lasso_plot.m`


clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

dest_data = './data';
if (exist(dest_data) ~= 7) 
    mkdir(dest_data);
end

dwtmode('per', 'nodisp');

% Set path to cilib_data
src = cil_dflt.data_path;
N = 256;
views = 50;
vm = 2;      % Number of vanishing moments
fname_matrix = sprintf('radonMatrix2N%d_ang%d.mat', N, views);
fname_matrix = fullfile(src, 'radon_matrices', fname_matrix);
load(fname_matrix) % Matrix is named 'A'

wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname)-1;
im = phantom(N);


b = A*im(:); 

radWaveOp = @(x, mode) cil_op_dense_wavelet_2d(x, mode, A, wname, nres); 
% mode = 1  is the forward operator
% mode = 0 is the backward operator (transpose)


la_max = svds(A, 1)^2; % Compute singular value of A, and 
                       % square it, to get the larges eigenvalue 
                       % of A'*A. (Using that the wavelet transform 
                       % is a unitary matrix)  

L = 2*la_max;
nbr_of_itr = 10000;

k_start = -10;
k_end = 10;
k_values = k_start:k_end;

n = length(k_values);
pnsr_arr = zeros([n,1]);

noise = randn(size(b));

sigma_vals = [1,0.1, 0.01, 0.001]

for sigma = sigma_vals
    measurements = b + sigma*noise;
    for i = 1:n
        k = k_values(i);
        lambda = (2^k)*sigma;

        fprintf('sigma: %g, k: %d\n', sigma, k);

        sol = cil_FISTA_solver(measurements, radWaveOp, nbr_of_itr, L, lambda);

        S = cil_get_wavedec2_s(round(log2(N)), nres);
        im_rec  = waverec2(sol, S, wname);
        idx_low  = im_rec < 0;
        idx_high = im_rec > 1;
        im_rec(idx_low)  = 0;
        im_rec(idx_high) = 1;

        psnr_val = psnr(im_rec, im, 1);
        psnr_arr(i) = psnr_val;

    end

    fname = fullfile(dest_data, sprintf('psnr_fista_fourier_sigma_%g_N_%d_itr_%d.mat', sigma, N, nbr_of_itr));
    save(fname, 'psnr_arr', 'noise', 'nbr_of_itr', 'sigma', 'k_values', 'L');

end

