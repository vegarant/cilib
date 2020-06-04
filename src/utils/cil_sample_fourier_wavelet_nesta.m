% cil_sample_fourier_wavelet_nesta() performs a compressive sensing experiment using a
% two dimensional Fourier sampling operator and wavelet two dimensional wavelet 
% sparsifying operator. The optimization problem is solved using the analysis 
% formulation of quadratically constrained basis pursuit. 
%          minimize ||W x||   s.t.  ||Ax - b||_2 <= noise.
% It is solved using the NESTA software package. 
%
% The function stores the recovered image and its sampling pattern as 
% 'filename' and 'filename_samp' with the file extension specified by
% cil_dflt.image_format (see etc/set_defaults.m)
% 
% INPUT
% im       - Image which will be sampled
% noise    - Error threshold 
% idx      - The matrix indices one would like to sample, given in an linear
%            order (see sub2ind(..) for conversion to linear order)
% filename - Name of file without the format extension.
% vm       - Number of vanishing moments
%
% OUTPUT
% im_rec - The recovered image
% z      - The recovered coefficients (raw data)
% 
% NAME VALUE PAIRS:
%
% 'nesta_mu' :: 0.2. Smoothing parameter for the nesta objective function.
%
function [im_rec, z] = cil_sample_fourier_wavelet_nesta(im, noise, idx, filename, vm, varargin);
    
    load('cilib_defaults.mat') % load font size, line width, etc.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Verify that the input is correct and initialize all relevant variables %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cil_validate_sample_args(im, noise, idx)     

    N = size(im, 1);
    M = length(idx);                       % The number of samples
    x = reshape(im, [N*N, 1]);             % Create a vectorized version of the
                                           % image 
    wname = sprintf('db%d', vm);
    % Store current boundary extension mode
    boundary_extension = dwtmode('status', 'nodisp');
    % Set the correct boundary extension for the wavelets
    dwtmode('per', 'nodisp');

    opts.nesta_mu = 0.2;
    opts = cil_argparse(opts, varargin); 

    % All the NESTA parameters are specialized for images in the range [0,100]
    % so we ensure the image values lie in this range
    %x = 100*(x - min(x))/(max(x) - min(x));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Start the compressive sensing process                 %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Initialize the `A` matrix operator
    A  = @(x) cil_op_fourier_2d(x, 1, N, idx); 
    At = @(x) cil_op_fourier_2d(x, 0, N, idx); % A transpose
    
    b = A(x);                                   % Obtain the samples 
    if (isfield(opts, 'measurement_noise'))
        b = b + opts.measurement_noise;

    end

    % The choice of parameter values are based on the example file in the NESTA
    % package 
    
    opts.maxintiter = 5;
    opts.TOlVar = 1e-5;
    opts.verbose = 1;
    opts.maxiter = 5000;
    

    nres = wmaxlev(N, wname);
    opts.U  = @(z) cil_op_wavelet_2d(z, 1, N, nres, wname); % Forward  wavelet transform 
    opts.Ut = @(z) cil_op_wavelet_2d(z, 0, N, nres, wname); % Backward wavelet transform 
    opts.MinType = 'L1';
    opts.verbose = 10;
    %opts.stoptest = 1;  

    %  minimize ||Wx||  s.t.  ||Ax - b||_2 <= noise
    [im_rec, niter, resid, err] = NESTA(A, At, b, opts.nesta_mu, noise, opts);
    z = im_rec; 
    im_rec = reshape(im_rec, [N, N]);

    im_rec = (im_rec - min(im_rec(:)))/(max(im_rec(:)) - min(im_rec(:)));
    im_rec = abs(im_rec);    
    
    % Store the image
    imwrite(im2uint8(im_rec), sprintf('%s.%s', filename, ...
                                               cil_dflt.image_format));

    % Store the sampling map
    Y = zeros([N, N] ,'uint8');
    Y(idx) = 255;
    imwrite(im2uint8(Y), sprintf('%s_samp.%s', filename, ...
                                               cil_dflt.image_format));
    % Restore dwtmode
    dwtmode(boundary_extension, 'nodisp')

end






