% This script display the different sampling patterns used for a particular run 
% of Compute_psnr_curve_fourier.m or Compute_psnr_curve_fourier.m for a fixed 
% sampling rate.
%
% Adjust the `r_id` and `srate` paramters to match the desired `runID` and 
% subsampling rate.
% 
% Vegard Antun, 2019

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.


r_id = 32; % runID
disp_plots = 'off';
dest = 'plots';

data_full_path = fullfile('psnr_data', sprintf('run%03d', r_id));
run(fullfile(data_full_path, 'config_psnr.m'));

nbr_patterns = length(str_identifier);
psnr_curves= cell(nbr_patterns);

srate = 0.45; % Subsampling rate. Number in the interval [0,1].
nbr_samples = round(N*N*srate);

% Compute dimension of sampling pattern figure
is_odd = mod(nbr_patterns, 2);
l_h = floor(nbr_patterns/2) + is_odd;

fig = figure('visible', disp_plots);

for i = 1:nbr_patterns
    f_hand = samp_patt_handles{i};
    [idx, str_id] = f_hand(N, nbr_samples);
    Z = zeros([N,N]);
    Z(idx) = 1;
    pname = str_identifier{i};

    subplot(2, l_h, i); imagesc(Z); colormap('gray'); axis('off'); axis('square'); 
    title(pname, 'Interpreter', 'none', 'Fontsize', 5);
    
end

fname = sprintf('patt_exp_run_%03d_N_%d_sr_%02d.png', r_id, N, round(100*srate));
saveas(fig, fullfile(dest, fname));






