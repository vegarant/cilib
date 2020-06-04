% Computes a wavelet and TV reconstruction using different sampling rates and
% sampling patterns. With these reconstructed images the following is computed.
% - A cropped version of the reconstructed images.
% - The difference between the true and reconstructed gradient image for TV
%   reconstruction
% - PSNR-values for the various reconstructions are written to the file 'psnr_values.txt'
%
% Vegard Antun, 2020.
clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dest = 'plots';
% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end

N = 512;
fname_core = 'phantom_brain';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
X = X/max(X(:));

vm = 4;                                     % Number of vanishing moments.
sigma = 1e-2;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma.
spgl1_iterations = 5000;                    % Maximum number of spgl1 iterations.
subsampling_rates = [0.10, 0.15];                    % ∈ [0,1]
alpha = 1;                                   % Inverse square law sampling pattern


vs = round(N/24);
hs = round(N/2.2);
v = N/3; 

%im_zoom =  X(vs:vs+v/2-1, hs:hs+v-1);
%figure(); imagesc(im_zoom); colormap('gray'); colorbar(); axis('equal');

[~, im_grad] = cil_gradient_isotropic(X);
max_im_grad = max(im_grad(:));
fname_tv_psnr = fullfile(dest, 'psnr_values.txt');
fID = fopen(fname_tv_psnr, 'a');
fwrite(fID, '-----------------------------------------------------\n');

for i = 1:length(subsampling_rates)
    nbr_samples = round(subsampling_rates(i)*N*N);
    [idx1, str_id1] = cil_spf2_power_law(N, nbr_samples, alpha);
    [idx2, str_id2] = cil_sp2_uniform(N, nbr_samples);
    P = zeros([N,N]);
    P(idx2) = 1;
    P(N/2+1, N/2+1) = 1;
    idx2 = find(P);
    
    pattern = {idx1, idx2};
    pattern_id = {str_id1, str_id2};
    for j = 1:length(pattern)
        idx = pattern{j};
        str_id = pattern_id{j};
        
        % Fourier wavelet
        fprintf('\n\nComputing wavelet reconstruction: sampling rate %g\n\n', subsampling_rates(i)*100);
        fname = sprintf('aFourier_srate_%g_%s_db%d', ...
                        subsampling_rates(i)*100, str_id, vm);
        [im_rec_wave, ~] = cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm, ...
                                   'spgl1_iterations', spgl1_iterations);

        % Store the cropped version
        im_rec_wave_zoom = im_rec_wave(vs:vs+v/2-1, hs:hs+v-1);
        fname_crop = [fname, '_crop.', cil_dflt.image_format];
        imwrite(im2uint8(im_rec_wave_zoom), fullfile(dest, fname_crop));

        % Fourier TV
        fprintf('\n\nComputing TV reconstruction: sampling rate %g\n\n', subsampling_rates(i)*100);
        fname = sprintf('aFourier_srate_%g_%s_TV', ...
                        subsampling_rates(i)*100, str_id);
        [im_rec_tv_01, im_rec_tv] = cil_sample_fourier_TV(100*X, sigma, idx, fullfile(dest, fname));

        % Store the cropped version
        im_rec_tv_01_zoom = im_rec_tv_01(vs:vs+v/2-1, hs:hs+v-1);
        fname_crop = [fname, '_crop.', cil_dflt.image_format];
        imwrite(im2uint8(im_rec_tv_01_zoom), fullfile(dest, fname_crop));

        % Store gradient with flipped colors.
        im_rec_tv = im_rec_tv/100;
        im_rec_tv = reshape(im_rec_tv, [N,N]);
        [~, grad_im_rec_TV] = cil_gradient_isotropic(im_rec_tv);
        [psnr_im, snr_im] = psnr(im_rec_tv, X, 1);
        [psnr_im_grad, snr_im_grad] = psnr(grad_im_rec_TV, im_grad, max_im_grad);



        % 
        fname = sprintf('aFourier_srate_%g_%s_TV_grad.%s', ...
                        subsampling_rates(i)*100, str_id, cil_dflt.image_format);
        
        max_im_grad = max(grad_im_rec_TV(:));
        imwrite(im2uint8(1 - (grad_im_rec_TV/max_im_grad)), fullfile(dest, fname));
        data_str = fprintf(fID, 'patt: %s, srate: %g, psnr im: %g, psnr grad: %g\n', ...
                            str_id, subsampling_rates(i)*100, psnr_im, ...
                            psnr_im_grad);

    end
end


fclose(fID);
















