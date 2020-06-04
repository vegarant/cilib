% cil_sample_fourier_wavelet() performs a compressive sensing experiment with a 
% Fourier sampling operator and a Daubechies wavelet as the sparsifying operator
% The image `im` is sampled in the Fourier-domain, at the indices specified in 
% `idx`. The samples are then stored in a vector, say b, and we solve the 
% optimization problem 
%              minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
% using the SPGL1 package. Here A is the matrix obtained by right multiplying
% the Fourier operator with an inverse wavelet operator. Finally both the 
% reconstructed image and it's sampling map (given by `idx`) is stored as
% images. 
%
% The function stores the reconstructed image and its sampling pattern as 
% 'filename' and 'filename_samp' with the file extension specified by
% cil_dflt.image_format (see etc/set_defaults.m)
%
% INPUT
% im       - Image which will be sampled
% sigma    - Error threshold 
% idx      - The matrix indices one would like to sample, given in an linear
%            order (see sub2ind(..) for conversion to linear order)
% filename - Name of file without the format extension.
% vm       - Number of vanishing moments of the Daubechies wavelet
% name value pairs - See below (optional)
%
% OUTPUT
% im_rec - The recovered image
% z      - The recovered coefficients (raw data)
%
% NAME VALUE PAIRS:
%
% 'wave_levels' :: wmaxlev(size(im,1), wave_name). Specifies the number of 
%     wavelet levels used in the wavelet transform
%
function [im_rec, z] = cil_sample_fourier_wavelet(im, sigma, idx, filename, vm, varargin);
    load('cilib_defaults.mat') % load font size, line width, etc.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Verify that the input is correct and initialize all relevant variables %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cil_validate_sample_args(im, sigma, idx)     
    N = size(im, 1);
    M = length(idx);                       % The number of samples
    
    % Initialization
    wave_name = sprintf('db%d', vm);
    opts.wave_levels = wmaxlev(N, wave_name);  % Maximum wavelet decomposition level
    opts = cil_argparse(opts, varargin); 
    
    % Store current boundary extension mode
    boundary_extension = dwtmode('status', 'nodisp');
    % Set the correct boundary extension for the wavelets
    dwtmode('per', 'nodisp');
    
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Start the compressive sensing process                 %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Sample the image
    b = fftshift(fft2(im))./N;             % 1/N is a normalizing factor
    b = b(idx);                            % Extract the sampled indices
    if isfield(opts, 'measurement_noise')
        b = b + opts.measurement_noise;
    end

    % Initialize the `A` matrix operator
    opA = @(x, mode) cil_op_fourier_wavelet_2d(x, mode, N, idx, opts.wave_levels, wave_name);
     
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
    
    % Store the sampling map
    Y = zeros([N, N] ,'uint8');
    Y(idx) = 255;
    imwrite(im2uint8(Y), sprintf('%s_samp.%s', filename, ...
                                               cil_dflt.image_format));
    
    % Restore dwtmode
    dwtmode(boundary_extension, 'nodisp')
    
end


