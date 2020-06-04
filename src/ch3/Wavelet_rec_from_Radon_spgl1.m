% Reconstruct shepp logan phantom from 50 radial lines, using a radon sampling 
% operator.
clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';

dwtmode('per', 'nodisp');


src = cil_dflt.data_path;
N = 256;
views = 50;
noise = 0.01;
vm = 2;
fname_matrix = sprintf('radonMatrix2N%d_ang%d.mat', N, views);
fname_matrix = fullfile(src, 'radon_matrices', fname_matrix);
load(fname_matrix)


sigma = 0.001;


wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);

im = phantom(N);
m = size(A,1);

y = A*im(:) + sigma*randn(m,1);
noise = sqrt(m)*sigma;

radWaveOp = @(x, mode) cil_op_dense_wavelet_2d(x, mode, A, wname, nres);

%  minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
opts = spgSetParms('verbosity', cil_dflt.spgl1_verbosity);
z    = spg_bpdn(radWaveOp, y, noise,  opts); 
 
% Reconstruct image
s = cil_get_wavedec2_s(round(log2(N)), nres);
im_rec_raw  = waverec2(z, s, wname);

im_rec = im_rec_raw;
idx0 = im_rec < 0;
idx1 = im_rec > 1;
im_rec(idx0) = 0;
im_rec(idx1) = 1;

fname_wave_raw  = fullfile(dest, sprintf('rec_radon_views_%d_N_%d_db%d_splg1_raw.png',  views, N, vm));
fname_wave_post = fullfile(dest, sprintf('rec_radon_views_%d_N_%d_db%d_splg1_post.png', views, N, vm));

% Store the image
imwrite(im2uint8(cil_scale_to_01(im_rec_raw)), fname_wave_raw);
imwrite(im2uint8(im_rec), fname_wave_post);

% Compute FBP
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

