% This script demonstrate the flip test and flip test in levels 
% for Fourier sampling and wavelet reconstruction. Change the variable 
% flip_test_in_levels, to choose which of the tests you would like to run
%
% Vegard Antun 2018

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end

dest = 'plots';
dwtmode('per', 'nodisp');

% Parameters
nu = 8;                        % 2^nu = signal size
subsampling_rate = 0.20;
sigma = 0;                     % Noise parameter
vanishing_moments = 4;    % The experiment is preformed for each number 
                               % specified 
flipp_test_in_levels = 1;% Boolean, 0: flip all wavelet coefficients
                         %          1: flip wavelet coefficients within each
                         %          level

nbr_sampling_levels = 15;
nbr_sampling_lines = 33;
% Dependent parameters
N = 2^(nu);                     % N × N image
nbr_samples = round(N*N*subsampling_rate); % Number of samples
fname = sprintf('klubbe_%d.png', N);
im = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname))); % OBS: image must have range [0,255] for PSNR calculations

% Create an image where all wavelet coefficients are flipped.


% Create various sampling patterns
nbr_levels = 50;
r0=1;
a = 2;
[idx1, samp_str_id1] = cil_spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels);
[idx2, samp_str_id2] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
[idx3, samp_str_id3] = cil_spf2_radial_lines(N, nbr_samples, nbr_sampling_lines); 
[idx4, samp_str_id4] = cil_sp2_uniform(N, nbr_samples);

sampling_pattern = {idx1, idx2,idx3, idx4};
sampling_string_id = {samp_str_id1, samp_str_id2, samp_str_id3, samp_str_id4};


for vm = vanishing_moments
    
    wname = sprintf('db%d', vm);    % Wavelet name 
    nres = wmaxlev([N,N], wname);

    [c,S] = wavedec2(im, nres, wname);
    if (flipp_test_in_levels)
        c_flipped = cil_flip_wavelet_2d_in_levels(c, S);
        test_str_id = 'FTL'; % Flip test in levels
    else 
        c_flipped = flip(c);
        test_str_id = 'FT'; % Flip test
    end
    
    im_flipped = waverec2(c_flipped, S, wname);
    
    %  Test wavelet recovery with flipped and unflipped images for
    %  various sampling patterns
    for i = 1:length(sampling_pattern);
    
        idx = sampling_pattern{i};
        samp_str_id = sampling_string_id{i};
        
        fname = fullfile(dest, sprintf('%s_four_wave_%s_db%d_non_flipped', ...
                                                test_str_id, samp_str_id, vm));
        [im_rec_non_flipped, wave_rec] = cil_sample_fourier_wavelet(im, sigma, idx, ...
                                                    fname, vm);
        
        im_rec_non_flipped = waverec2(wave_rec, S, wname);

        im_rec_non_flipped = abs(im_rec_non_flipped);
        idx_rem = im_rec_non_flipped > 255;
        im_rec_non_flipped(idx_rem) = 255;
        
        [peaksnr_non_flipped, snr] = psnr(im_rec_non_flipped, im, 255); 

        RGB = insertText(uint8(round(im_rec_non_flipped)),[N, N],...
                 sprintf('PSNR: %4.1f', peaksnr_non_flipped), ...
                 'BoxColor', 'white', 'BoxOpacity',0.4, ...
                 'TextColor','black', ...
                 'AnchorPoint', 'RightBottom', ...
                 'FontSize', cil_dflt.font_size);
        im_rec_non_flipped = uint8(rgb2gray(RGB));

        % Store the recovered image
        imwrite(im_rec_non_flipped, sprintf('%s_psnr.%s', fname, ...
                                                    cil_dflt.image_format));





        fname = fullfile(dest, sprintf('%s_four_wave_%s_db%d_flipped', ...
                         test_str_id, samp_str_id, vm));
        [im_rec, wave_rec_flipped] = cil_sample_fourier_wavelet(im_flipped, ...
                                     sigma, idx, fname, vm);

        % Flip the wavelet coefficients back again, and recover image 
        if (flipp_test_in_levels)
            wave_rec_unflipped = cil_flip_wavelet_2d_in_levels(wave_rec_flipped, S);
        else
            wave_rec_unflipped = flip(wave_rec_flipped);
        end

        % unflipped means that we have reveresed the flipping
        im_rec_unflipped = waverec2(wave_rec_unflipped, S, wname);
        
        im_rec_unflipped = abs(im_rec_unflipped);
        idx_rem = im_rec_unflipped > 255;
        im_rec_unflipped(idx_rem) = 255;
        
        [peaksnr_flipped, snr] = psnr(im_rec_unflipped, im, 255); 

        % Store the recovered image
        imwrite(uint8(round(im_rec_unflipped)), sprintf('%s.%s', fname, ...
                                                    cil_dflt.image_format));

        RGB = insertText(uint8(round(im_rec_unflipped)),[N, N],...
                 sprintf('PSNR: %4.1f', peaksnr_flipped), ...
                 'BoxColor', 'white', 'BoxOpacity',0.4, ...
                 'TextColor','black', ...
                 'AnchorPoint', 'RightBottom', ...
                 'FontSize', cil_dflt.font_size);
        im_rec_unflipped = uint8(rgb2gray(RGB));

        % Store the recovered image
        imwrite(im_rec_unflipped, sprintf('%s_psnr.%s', fname, ...
                                                    cil_dflt.image_format));

    end
end



