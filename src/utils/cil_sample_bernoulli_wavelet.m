% cil_sample_bernoulli_wavelet() performs a compressive sensing experiment with a 
% Bernoulli sampling operator and a Daubechies wavelet as the sparsifying operator
% The entries in the Bernoulli matrix A is -1 or 1, drawn with equal probability.
% The samples in the image are sampled as Ax = b, where x is the image im,
% written as a vector. Let Ψ denote the two dimensional wavelet transform. We
% then solve the optimization problem
%              minimize ||x||_1  s.t.  ||AΨ^{-1}x - b||_2 <= sigma
% using the SPGL1 package. The solution z of this problem, is then used to
% reconstruct the image as Ψ^{-1}z.
%
%
% The function stores the reconstructed image and its sampling pattern as 
% 'filename' and 'filename_samp' with the file extension specified by
% cil_dflt.image_format (see etc/set_defaults.m)
%
% INPUT
% im       - Image which will be sampled
% subsamplin_rate - Fraction between the number of samples M and number of
%                   pixels in the image, i.e. subsampling_rate ∈ (0,1].
% sigma    - Error threshold 
% vm       - Number of vanishing moments of the Daubechies wavelet
% filename - Name of file without the format extension.
%
% OUTPUT
% im_rec - The recovered image
% z - The recovered coefficients (raw data)
% 
function [im_rec, z] = cil_sample_bernoulli_wavelet(im, subsampling_rate, sigma, filename, vm, varargin);
    load('cilib_defaults.mat') % load font size, line widht, etc.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Verify that the input is correct and initialize all relevant variables %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    N = size(im, 1);

    M = round(subsampling_rate*N*N);
    
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
    
    % Create the sampling matrix
    A = 2*randi(2,M, N*N) - 3; 
    A = A/N;
    % Form the image as a vector
    x = reshape(im, [N*N, 1]);
    % Sample the image
    b = A*x;
    
    opA = @(x, mode) cil_op_dense_wavelet_2d(x, mode, A, wave_name, opts.wave_levels); 
    
    %  minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
    opts_spgl1 = spgSetParms('verbosity', cil_dflt.spgl1_verbosity);
    opts = cil_merge_structs(opts_spgl1, opts);
    z    = spg_bpdn(opA, b, sigma, opts); 
     
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
