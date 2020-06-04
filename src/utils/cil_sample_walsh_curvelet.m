% cil_sample_fourier_curvelet() performs a compressive sensing experiment with a 
% Hadamard sampling operator and a curvelet-operator as the sparsifying
% transform. The image `im` is sampled in the Hadamard-domain, at the indices
% specified in `idx`. The samples are then stored in a vector, say b, and we
% solve the optimization problem 
%              minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
% using the SPGL1 package. Here A is the matrix obtained by right multiplying
% the Hadamard operator with the inverse curvelet transform. Finally both the 
% reconstructed image and it's sampling map (given by `idx`) is stored as
% images. 

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
% is_real  - Type of transform, 
%                0: complex-valued curvelets
%                1: real-valued curvelets
%
% OUTPUT
% im_rec - The recovered image
% z      - The recovered coefficients (raw data)
%
function [im_rec, z] = cil_sample_walsh_curvelet(im, sigma, idx, filename, ...
                                                                is_real);
    load('cilib_defaults.mat') % load font size, line width, etc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Verify that the input is correct and initialize all relevant variables %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cil_validate_sample_args(im, sigma, idx)     

    N = size(im, 1);
    M = length(idx);                       % The number of samples

    [curvelet_system, n] = cil_find_curvelet_size(im, is_real);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                Start the compressive sensing process                 %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hadamard_order = 'sequency';    

    % Sample the image
    b = cil_op_fastwht_2d(im);
    b = b(idx);                            % Extract the sampled indices

    % Initialize the `A` matrix operator
    opA = @(x, mode) cil_op_fastwht_curvelet_2d(x, mode, N, idx, curvelet_system, ...
                                        n, is_real);

    %  minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
    opts_spgl1 = spgSetParms('verbosity', cil_dflt.spgl1_verbosity);
    opts = cil_merge_structs(opts_spgl1, opts);
    z    = spg_bpdn(opA, b, sigma, opts); 

    % Reconstruct image 
    C = fdct_wrapping_vector2cell(z, curvelet_system);
    im_rec = ifdct_wrapping(C, is_real, N, N);
    
    im_rec = (im_rec - min(abs(im_rec(:))))/...
             (max(abs(im_rec(:))) - min(abs(im_rec(:))));

    % Store the image
    imwrite(im2uint8(abs(im_rec)), sprintf('%s.%s', filename, ...
                                               cil_dflt.image_format));

    % Store the sampling map
    Y = zeros([N, N] ,'uint8');
    Y(idx) = 255;
    imwrite(im2uint8(flipud(Y)), sprintf('%s_samp.%s', filename, ...
                                               cil_dflt.image_format));
end

