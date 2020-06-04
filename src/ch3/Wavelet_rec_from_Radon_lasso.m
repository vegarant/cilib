% Reconstruct shepp logan phantom from 50 radial lines, using a radon sampling 
% operator.
%
clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
dest = 'plots/';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

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
sigma = 0.001;

noise = sigma*randn(size(A,1), 1);
b = A*im(:) + noise; 


radWaveOp = @(x, mode) cil_op_dense_wavelet_2d(x, mode, A, wname, nres); 
% mode = 1  is the forward operator
% mode = 0 is the backward operator (transpose)

lambda = sigma;


la_max = svds(A, 1)^2; % Compute singular value of A, and 
                       % square it, to get the larges eigenvalue 
                       % of A'*A. (Using that the wavelet transform 
                       % is a unitary matrix)  

L = 2*la_max; 

nbr_of_itr = 20000;
sol = cil_FISTA_solver(b, radWaveOp, nbr_of_itr, L, lambda);

% Reconstruct image
s = cil_get_wavedec2_s(round(log2(N)), nres);
im_rec_raw  = waverec2(sol, s, wname);

im_rec = im_rec_raw;
idx = im_rec < 0;
im_rec(idx) = 0;
im_rec = (im_rec - min(im_rec(:)))/(max(im_rec(:)) - min(im_rec(:)));
im_rec = abs(im_rec);

fname_wave_raw  = fullfile(dest, sprintf('rec_radon_views_%d_N_%d_db%d_lasso_%g_itr_%d_raw.png', views, N, vm, lambda, nbr_of_itr));
fname_wave_post = fullfile(dest, sprintf('rec_radon_views_%d_N_%d_db%d_lasso_%g_itr_%d_post.png', views, N, vm, lambda, nbr_of_itr));

% Store the image
imwrite(im2uint8(cil_scale_to_01(im_rec_raw)), fname_wave_raw);
imwrite(im2uint8(im_rec), fname_wave_post);

% Compute FBP and adjoint
theta = linspace(0,180*(1-1/views), views);

sinogram = radon(im, theta);
im_FBP = iradon(sinogram, theta, 'linear', 'Ram-Lak', 1, N);
idx = im_FBP < 0;
im_FBP(idx) = 0;
im_FBP = im_FBP/max(im_FBP(:));

im_Adj = iradon(sinogram, theta, 'linear', 'None', 1, N);
idx = im_Adj < 0;
im_Adj(idx) = 0;
im_Adj = im_Adj/max(im_Adj(:));

fname_FBP = fullfile(dest, sprintf('rec_radon_views_%d_N_%d_FBP.png', views, N));
fname_Adj = fullfile(dest, sprintf('rec_radon_views_%d_N_%d_adjoint.png', views, N));
imwrite(im2uint8(im_FBP), fname_FBP);
imwrite(im2uint8(im_Adj), fname_Adj);



