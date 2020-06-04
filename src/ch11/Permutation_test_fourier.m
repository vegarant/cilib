% This script demonstrate the flip test with random permutations 
% for Fourier sampling and wavelet reconstruction. 
%
% Vegard Antun 2018

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

dwtmode('per', 'nodisp');

% Parameters
nu = 8;                        % 2^nu = signal size
subsampling_rate = 0.20;
sigma = 0;                     % Noise parameter
vm = 1;

% Dependent parameters
N = 2^(nu);                     % N × N image
nbr_samples = round(N*N*subsampling_rate); % Number of samples
nres = nu-3;
im = phantom(N); 

wname = sprintf('db%d', vm);
[c,S] = wavedec2(im, nres, wname);

% Create an image where all wavelet coefficients are flipped.
idx_perm1 = randperm(N*N);
%idx_perm2 = randperm(N*N);
[c_sorted, idx_perm2] = sort(abs(c));
idx_perm2 = fftshift(reshape(idx_perm2, N, N));
idx_perm2 = reshape(idx_perm2, 1, N*N);

S = cil_get_wavedec2_s(nu, nres);
idx_perm3 = cil_wave_ord_2d_image(1:N*N, S, wname);
idx_perm3 = flipud(fliplr(idx_perm3));
idx_perm3 = cil_wave_ord_2d_leveled(idx_perm3, S);


test_str_id = 'PT'; % Flip test in levels

% Create sampling pattern
nbr_levels = 50;
r0=1;
a = 2;
[idx, samp_str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);


eps = 0.6;
sparsity = sum(abs(c)>eps);
ma = max(im(:));
mi = min(im(:));


idx_perm_all = {idx_perm1, idx_perm2, idx_perm3};
idx_perm_str_all = {'rand1','sorted_fftshift', 'updown'};
for i = 1:length(idx_perm_all)
    idx_perm = idx_perm_all{i};
    idx_perm_inv = zeros(1,N*N);
    idx_perm_inv(idx_perm) = 1:N*N;
    idx_perm_str = idx_perm_str_all{i};

    c_permuted = c(idx_perm);
    assert(norm(c - c_permuted(idx_perm_inv)) < 1e-8)
    % Visualize the original wavelet coefficents and the permuted once
    c_im = abs(cil_wave_ord_2d_image(c, S, wname));
    c_im_permuted = abs(cil_wave_ord_2d_image(c_permuted, S, wname));
            
    c_im = (c_im - min(c_im(:)))/(max(c_im(:))-min(c_im(:)));
    c_im_permuted = (c_im_permuted - min(c_im_permuted(:)))/...
                    (max(c_im_permuted(:)) - min(c_im_permuted(:)));
    
    fname = fullfile(dest, sprintf('%s_wavecoef_db%d_%s_no_perm', test_str_id, vm, idx_perm_str));
    % Save the recovered image
    imwrite(im2uint8(c_im.^(1/3)), sprintf('%s.%s', fname, ...
                                                cil_dflt.image_format));
    
    fname = fullfile(dest, sprintf('%s_wavecoef_db%d_%s_perm', test_str_id, vm, idx_perm_str));
    % Save the recovered image
    imwrite(im2uint8(c_im_permuted.^(1/3)), sprintf('%s.%s', fname, ...
                                                cil_dflt.image_format));
    
    % Save the unnatural image from permuted wavelet coefficents
    im_permuted = waverec2(c_permuted, S, wname);
    im_permuted_scaled = (im_permuted - min(im_permuted(:)))/...
                    (max(im_permuted(:)) - min(im_permuted(:)));

    fname = fullfile(dest, sprintf('%s_image_perm_db%d_%s', test_str_id,vm, idx_perm_str));
    imwrite(im2uint8(im_permuted_scaled), sprintf('%s.%s', fname, ...
                                                cil_dflt.image_format));


    fname = fullfile(dest, sprintf('%s_four_wave_%s_db%d_%s_perm', test_str_id, ...
                     samp_str_id, vm, idx_perm_str));

    [im_rec, wave_rec_permuted] = cil_sample_fourier_wavelet(im_permuted, ...
                                 sigma, idx, fname, vm, 'wave_levels', nres);

    % Flip the wavelet coefficients back again, and recover image 
    wave_rec_inv_perm = wave_rec_permuted(idx_perm_inv);

    im_rec_inv_perm = waverec2(wave_rec_inv_perm, S, wname);
    
    im_rec_inv_perm = abs(im_rec_inv_perm);
    idx_rem = im_rec_inv_perm > 1
    im_rec_inv_perm(idx_rem) = 1;

    % Save the recovered image
    imwrite(im2uint8(im_rec_inv_perm), sprintf('%s.%s', fname, ...
                                                cil_dflt.image_format));



    [peaksnr_inv_perm, snr] = psnr(im_rec_inv_perm, im, 1); 
    RGB = insertText(im2uint8(im_rec_inv_perm),[N, N],...
             sprintf('PSNR: %4.1f', peaksnr_inv_perm), ...
             'BoxColor', 'white', 'BoxOpacity',0.4, ...
             'TextColor','black', ...
             'AnchorPoint', 'RightBottom', ...
             'FontSize', cil_dflt.font_size);
    im_rec_inv_perm_psnr = uint8(rgb2gray(RGB));

    % Store the recovered image
    imwrite(im_rec_inv_perm_psnr, sprintf('%s_psnr.%s', fname, ...
                                             cil_dflt.image_format));


    % Reconstruct image without any permutation

    fname = fullfile(dest, sprintf('%s_four_wave_%s_db%d_%s_no_perm', ...
                     test_str_id, samp_str_id, vm, idx_perm_str));
    [im_rec_no_perm, wave_rec] = cil_sample_fourier_wavelet(im, sigma, idx, ...
                                               fname, vm, 'wave_levels', nres);

    im_rec_no_perm = waverec2(wave_rec, S, wname);

    im_rec_no_perm = abs(im_rec_no_perm);
    idx_rem = im_rec_no_perm > 1;
    im_rec_no_perm(idx_rem) = 1;

    [peaksnr_no_perm, snr] = psnr(im_rec_no_perm, im, 1); 
    RGB = insertText(im2uint8(im_rec_no_perm),[N, N],...
             sprintf('PSNR: %4.1f', peaksnr_no_perm), ...
             'BoxColor', 'white', 'BoxOpacity',0.4, ...
             'TextColor','black', ...
             'AnchorPoint', 'RightBottom', ...
             'FontSize', cil_dflt.font_size);
    im_rec_no_perm_psnr = uint8(rgb2gray(RGB));

    % Store the recovered image
    imwrite(im_rec_no_perm_psnr, sprintf('%s_psnr.%s', fname, ...
                                             cil_dflt.image_format));

end


