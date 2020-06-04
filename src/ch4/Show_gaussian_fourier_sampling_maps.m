% Computes the Gaussian sampling maps for Fourier sampling, witht the l^2 and l^1
% ball for a = 1 and a = 2, at different sampling rates

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end

dest = 'plots/';
disp_plots = 'off';


N = 256;
nbr_levels = 50;
r0 = 2;

for srate = [0.1, 0.25, 0.45]

    nbr_samples = round(srate*N*N);

    a = 1;
    [idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
    Z = zeros([N,N], 'uint8');
    Z(idx) = uint8(255);
    fname = sprintf('spatt_four_exp_l_2_r_%d_r0_%d_a_%d_srate_%d.%s', ...
    nbr_levels, r0, a, round(100*srate), cil_dflt.image_format);
    imwrite(Z, fullfile(dest,fname));

    a = 2;
    [idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
    Z = zeros([N,N], 'uint8');
    Z(idx) = uint8(255);
    fname = sprintf('spatt_four_exp_l_2_r_%d_r0_%d_a_%d_srate_%d.%s', ...
    nbr_levels, r0, a, round(100*srate), cil_dflt.image_format);
    imwrite(Z, fullfile(dest,fname));

    a = 1;
    [idx, str_id] = cil_spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels);
    Z = zeros([N,N], 'uint8');
    Z(idx) = uint8(255);
    fname = sprintf('spatt_four_exp_l_1_r_%d_r0_%d_a_%d_srate_%d.%s', ...
    nbr_levels, r0, a, round(100*srate), cil_dflt.image_format);
    imwrite(Z, fullfile(dest,fname));

    a = 2;
    [idx, str_id] = cil_spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels);
    Z = zeros([N,N], 'uint8');
    Z(idx) = uint8(255);
    fname = sprintf('spatt_four_exp_l_1_r_%d_r0_%d_a_%d_srate_%d.%s', ...
    nbr_levels, r0, a, round(100*srate), cil_dflt.image_format);
    imwrite(Z, fullfile(dest,fname));

end
