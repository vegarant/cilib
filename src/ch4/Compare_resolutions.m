% Computes a Fourier-wavelet reconstruction using a sampling rate of 5% at 
% different resolutions. Compute the reconstructions and store cropped version of
% reconstructed and original images. The cropped reconstructions will have the 
% PSNR value of the reconstructed image written in their lover right corner.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';

fname_core = 'pomegranate';

subsampling_rate = 0.05;           % nbr_samples = round(N*subsamplingRate)
vm    = 4;                         % Number of vanishing moments
sigma = 1;                       % Minimize ||Ax-b||_2 subject to ||x||_1 ≤ sigma

% Position of zoom. It is assumed to be a value in the interval [0,1]
cx = 0.6;
cy = 0.7;

N_zoom = 256;

%nbr_samples = round(N_im*subsampling_rate);

nus = [8:11];
for i = 1:length(nus) 
    nu = nus(i);
    N = 2^nu;

    nbr_samples = round(N*N*subsampling_rate);

    % Resized image might not lie in the interval [0,255]. To compute error we map
    % all images to be integers in the interval [0,255].
    fname = sprintf('%s_%d.png', fname_core, N);
    im = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
    im = im;

    r0 = 2;
    a = 1;
    nbr_levels = 100;

    idx = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels); 
    
    filename = fullfile(dest, sprintf('pomegranate_rec%04d_subs%d_vm%d', N, ...
                       round(100*subsampling_rate), vm));
    
    sigma = 4*sigma; % Increase noise level with resolution
    [im_rec, wave_coeff] = cil_sample_fourier_wavelet(im, sigma, idx, ...
                                     filename, vm);

    filename_zoom = fullfile(dest, sprintf('pomegranate_zoom_rec%04d_subs%d_vm%d.%s', N, ...
                       round(100*subsampling_rate), vm, ...
                       cil_dflt.image_format));
    filename_org  = fullfile(dest, sprintf('pomegranate_zoom_org%04d_subs%d_vm%d.%s', N, ...
                       round(100*subsampling_rate), vm, ...
                       cil_dflt.image_format));

    px = round(N*cx);
    py = round(N*cy);
    d = N_zoom/2;

    xpos = px-d+1:px+d;
    ypos = py-d+1:py+d;

    if (xpos(1) < 1)
        xpos = -xpos(1) + 1 + xpos;
    elseif(xpos(end) > N)
        xpos = xpos - (xpos(end) - N);
    end

    if (ypos(1) < 1)
        ypos = -ypos(1) + 1 + ypos;
    elseif(ypos(end) > N)
        ypos = ypos - (ypos(end) - N);
    end
    

    im_rec = round(255*im_rec);
    psnr_val = psnr(im_rec, im, 255);

    im_rec_zoom = im_rec(ypos, xpos);
    im_org_zoom = im(ypos, xpos);
    RGB = insertText(uint8(im_rec_zoom),[144, 225],...
                     sprintf('PSNR: %4.1f', psnr_val), ...
                     'BoxColor', 'white', 'BoxOpacity',0.4, ...
                     'TextColor','black', ... 
                     'FontSize', cil_dflt.font_size+5);
    im_rec_zoom = uint8(rgb2gray(RGB));
    imwrite(im_rec_zoom, filename_zoom);
    imwrite(uint8(im_org_zoom), filename_org);
end




