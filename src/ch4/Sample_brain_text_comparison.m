% For a fixed number of samples, direct inversion and compressive sensing is compared 
% for Fourier sampling of the GLPU phantom where a small text string is added. 
% Cropped versions of the reconstructed images are stored.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';

dwtmode('per', 'nodisp');

fname_core = 'phantom_brain';
fname1 = fullfile(cil_dflt.data_path, 'test_images', ...
                  sprintf('%s_%d.png', fname_core, 2048));
X=imread(fname1);
X=cil_add_text_to_brain(X);
X=double(rgb2gray(X));


%%%%%%%%%%%%%%%%%%%%%%%% Direct inversion methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 2048;
M = 512;
s = (3*N/8);
idx_center = s:s+M-1;

xs = 960;
ys = 1524;
lx = 120;
ly = 120;
idx_crop_x = xs:xs+lx-1;
idx_crop_y = ys:ys+ly-1;


% DFT 512 square
Y = fftshift(fft2(X))/(N*N);
s = round(3*N/8);
Y = Y(idx_center, idx_center);
Y = ifft2(ifftshift(Y))*(M*M);

Z = abs(Y(xs/4:((xs+lx)/4 -1), ys/4:((ys+ly)/4) -1));
idx_255 = Z > 255;
Z(idx_255) = 255;
Z = round(Z);

Z2 = upcil_sample_image_raw(Z, 4);
%imagesc(Z2); colormap('gray');
fname = 'idir_inv_512';
imwrite(uint8(Z2), fullfile(dest, [fname,'.', cil_dflt.image_format]))
patt = zeros([M,M], 'uint8');
patt(:) = uint8(255);
patt(1:5, :)   = uint8(0);
patt(end-4:end, :) = uint8(0);
patt(:, 1:5)   = uint8(0);
patt(:, end-4:end) = uint8(0);
imwrite(patt, fullfile(dest, [fname,'_samp.', cil_dflt.image_format]))


% DFT 2048 square, only 512 nonzero 
Y = fftshift(fft2(X));
Z = zeros(size(Y));
Z(idx_center, idx_center) = Y(idx_center, idx_center);
Z = abs(ifft2(ifftshift(Z)));

idx_255 = Z > 255;
Z(idx_255) = 255;
Z = round(Z);

fname = 'idir_inv_2048';
imwrite(uint8(Z(idx_crop_x, idx_crop_y)), fullfile(dest, [fname,'.', cil_dflt.image_format]))
patt = zeros([N,N], 'uint8');
patt(idx_center, idx_center) = uint8(255);
imwrite(patt, fullfile(dest, [fname,'_samp.', cil_dflt.image_format]))

%% DFT Gaussian 
nbr_samples = M*M;
fully_sample = 0.01;
nbr_levels = 70;
p_norm = 2;
[idx, str_id] = cil_spf2_exp(N, nbr_samples, fully_sample, nbr_levels, p_norm); 

% Adjoint 
Y = fftshift(fft2(X));
Z = zeros(size(Y));
Z(idx) = Y(idx);
Z = abs(ifft2(ifftshift(Z)));

idx_255 = Z > 255;
Z(idx_255) = 255;
Z = round(Z);


fname = sprintf('idir_inv_%s', str_id);
imwrite(uint8(Z(idx_crop_x, idx_crop_y)), fullfile(dest, [fname,'.', cil_dflt.image_format]))
patt = zeros([N,N], 'uint8');
patt(idx) = uint8(255);
imwrite(patt, fullfile(dest, [fname,'_samp.', cil_dflt.image_format]))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Compressive sesning %%%%%%%%%%%%%%%%%%%%%%%%%%%

vm = 4;
noise = 1;
fname = sprintf('i_splg1_db%d_%s', vm, str_id);
filename = fullfile(dest, fname);
[im_rec, wave_coeff] = cil_sample_fourier_wavelet(X, noise, idx, filename, vm);

Z = im_rec(idx_crop_x, idx_crop_y);
fname = sprintf('i_splg1_db%d_%s_crop.png', vm, str_id);
filename = fullfile(dest, fname);
imwrite(im2uint8(Z), filename);




