% Samples using a circular convolution and reconstructs the samples using
% wavelet sparsity.
%
% INPUT
% im - N×N image
% nbr_samples - Number of samples
% sigma - Noise level for quadratically constrained basis pursuit 
% filename - Name of the output files without the file extension
% vm - Number of vanishing moments for the Daubechies wavelet used.
%
% OUTPUT
% im_rec - Image reconstruction 
% z - Wavelet coefficients of wavelet reconstruction
%
function [im_rec, z] = cil_sample_circulant_wavelet(im, nbr_samples, sigma, filename, vm, varargin);
    load('cilib_defaults.mat') % load font size, line width, etc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Verify that the input is correct and initialize all relevant variables %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N = size(im, 1);
    idx = sp2_uniform(N, nbr_samples);
    cil_validate_sample_args(im, sigma, idx)     


    % Store current boundary extension mode
    boundary_extension = dwtmode('status', 'nodisp');
    % Set the correct boundary extension for the wavelets
    dwtmode('per', 'nodisp');
    % Initialization
    wave_name = sprintf('db%d', vm);
    opts.wave_levels = wmaxlev(N, wave_name);  % Maximum wavelet decomposition level
    opts = cil_argparse(opts, varargin); 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Start the compressive sensing process                 %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Sample the image
    % Generate random integer matrix of size N×N which consists +1 and -1.
    C = 2*randi([0 1],N,N)-1; % random convolution
    D = fft2(C); % symbol of c
    sampOp = @(x,mode) cil_op_binary_circulant_2d(x, mode, D, idx);
    sampOp_w_sparsity = @(x,mode) cil_op_binary_circulant_wavelet_2d(x, mode,...
                                     D, idx, wave_name, opts.wave_levels);
    b = sampOp(im(:),1); % Generate measurements
 
    if isfield(opts, 'measurement_noise')
        b = b + opts.measurement_noise;
    end

    %  minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
    opts_spgl1 = spgSetParms('verbosity', cil_dflt.spgl1_verbosity);
    opts = cil_merge_structs(opts_spgl1, opts);
    z = spg_bpdn(sampOp_w_sparsity, b, sigma, opts); 
     
    % Reconstruct image 
    s = cil_get_wavedec2_s(round(log2(N)), opts.wave_levels);
    im_rec  = waverec2(z, s, wave_name);
     
    im_rec = (im_rec - min(im_rec(:)))/(max(im_rec(:)) - min(im_rec(:)));
    im_rec = abs(im_rec);

    % Store the image
    imwrite(im2uint8(im_rec), sprintf('%s.%s', filename, ...
                                               cil_dflt.image_format));

    % Restore dwtmode
    dwtmode(boundary_extension, 'nodisp')

end

