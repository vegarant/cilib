% Compute reconstructions of the Shepp-Logan phantom from Fourier measurements. 
% This script compute a linear reconstruciton and a reconstruction using TV minimization. 
% The script tries to reproduce the classical "A Puzzling Numerical Experiment" from the paper
% Robust Uncertainty Principles: Exact Signal Reconstruction From Highly Incomplete Frequency 
% Information, by E. J. Candes, J. Romberg and T. Tao.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dest = 'plots';
% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end


N = 256; % Resolution (N × N)
L = 22;  % Number of lines

% Create sampling pattern, using code from Romberg.
mask = LineMask(L, N); 
mask = fftshift(mask);
idx = find(mask);

im = phantom(N);

fim = mask.*fftshift(fft2(im));
lin_rec = ifft2(ifftshift(fim));

% Scale to [0,1], ignoring complex values
lin_rec = (lin_rec - min(lin_rec(:)))./(max(lin_rec(:)) - min(lin_rec(:)));
lin_rec = abs(lin_rec);

fname_samp = sprintf('CRT_samp_patt_m_%d.%s', sum(mask(:)), cil_dflt.image_format);
fname_lin_rec = sprintf('CRT_lin_rec.%s', cil_dflt.image_format);

imwrite(im2uint8(mask), fullfile(dest, fname_samp));
imwrite(im2uint8(lin_rec), fullfile(dest, fname_lin_rec));

% Scale to [0, 100] for optimal performance using NESTA.
im = 100*im;
noise = 1e-5;
fname_tv_rec = 'CRT_tv_rec'; 
% Compute TV reconstruction and store it to file
[~, ~] = cil_sample_fourier_TV(im, noise, idx, fullfile(dest, fname_tv_rec));






