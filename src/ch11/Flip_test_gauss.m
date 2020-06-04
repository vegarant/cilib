% This script demonstrate the flip test and flip test in levels 
% for gaussian sampling and wavelet reconstruction. Change the variable 
% flip_test_in_levels, to choose the which of the tests you would like to run.
%
% Vegard Antun, 2018

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
subsampling_rate = 0.20;       % 
vanishing_moments = [4];    % The experiment is preformed for each number 
                               % specified 
sigma = 0;                     % Noise parameter
spgl1_iterations = 5000;
flipp_test_in_levels = 0;% Boolean, 0: flippes all wavelet coefficents
                         %          1: flippes wavelts coefficents within each
                         %          level

% Dependent parameters
N = 2^(nu);                                % N × N image
nbr_samples = round(N*N*subsampling_rate); % Number of samples

fname = sprintf('klubbe_%d.png', N);
im = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname))); % OBS: image must have range [0,255] for PSNR calculations


for vm = vanishing_moments

    wname = sprintf('db%d', vm);    % Wavelet name 
    nres = wmaxlev([N,N], wname);

    % Create an image where all wavelet coefficients are flipped.
    [c,S] = wavedec2(im, nres, wname);
    if (flipp_test_in_levels)
        c_flipped = cil_flip_wavelet_2d_in_levels(c, S);
        test_str_id = 'FTL'; % Flip test in levels
    else 
        c_flipped = flip(c);
        test_str_id = 'FT'; % Flip test
    end
    
    im_flipped = waverec2(c_flipped, S, wname);
    
    % Non flipped
    fname = fullfile(dest, sprintf('%s_gauss_wave_db%d_non_flipped',...
                           test_str_id, vm));
    [im_rec_non_flipped, wave_rec] = cil_sample_gauss_wavelet(im, ...
                                        subsampling_rate,  sigma,...
                                        fname, vm, 'spgl1_iterations', spgl1_iterations);
    
    im_rec_non_flipped = waverec2(wave_rec, S, wname);
    idx_255 = im_rec_non_flipped > 255;
    idx_0 = im_rec_non_flipped < 0;
    im_rec_non_flipped(idx_255) = 255;
    im_rec_non_flipped(idx_0) = 0;
    
    
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
    
    % Flipped
    fname = fullfile(dest, sprintf('%s_gauss_wave_db%d_flipped', ...
                           test_str_id, vm));
    [im_rec, wave_rec_flipped] = cil_sample_gauss_wavelet(im_flipped, ...
                                 subsampling_rate, sigma, fname, vm, ...
                                 'spgl1_iterations', spgl1_iterations);
    
    % Flip the wavelet coefficients back again, and recover image 
    if (flipp_test_in_levels)
        wave_rec_unflipped = cil_flip_wavelet_2d_in_levels(wave_rec_flipped, S);
    else
        wave_rec_unflipped = flip(wave_rec_flipped);
    end

    im_rec_unflipped = waverec2(wave_rec_unflipped, S, wname);


    idx_255 = im_rec_unflipped > 255;
    idx_0 = im_rec_unflipped < 0;
    im_rec_unflipped(idx_255) = 255;
    im_rec_unflipped(idx_0) = 0;
    %im_rec_unflipped = (im_rec_unflipped - min(im_rec_unflipped(:)))/...
    %                   (max(im_rec_unflipped(:)) - min(im_rec_unflipped(:)));
    %im_rec_unflipped = abs(im_rec_unflipped);
    
    imwrite(im2uint8(im_rec_unflipped), sprintf('%s.%s', fname, ...
                                                cil_dflt.image_format));

    [peaksnr_unflipped, snr] = psnr(im_rec_unflipped, im, 255); 

    RGB = insertText(uint8(round(im_rec_unflipped)),[N, N],...
             sprintf('PSNR: %4.1f', peaksnr_unflipped), ...
             'BoxColor', 'white', 'BoxOpacity',0.4, ...
             'TextColor','black', ...
             'AnchorPoint', 'RightBottom', ...
             'FontSize', cil_dflt.font_size);
    im_rec_unflipped = uint8(rgb2gray(RGB));

    % Store the recovered image
    imwrite(im_rec_unflipped, sprintf('%s_psnr.%s', fname, ...
                                                cil_dflt.image_format));

end




