
function [im_rec, z] = cil_sample_walsh_wavelet(im, sigma, idx, filename, vm, varargin);
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
    hadamard_order = 'sequency';    
    perm = randperm(N*N);
    
    % Ensure that zero frequency is always sampled
    a = find(perm == 1);
    tmp_elem = perm(1);
    perm(1) = 1;
    perm(a) = tmp_elem;
    perm_rev(perm) = 1:N*N;

    % Check that zero frequency is sampled 
    a = find(idx == 1);
    if length(a) == 0
        idx(1) = 1;
    end

    im_perm = im(perm);
    % Sample the image
    b = cil_op_fastwht_2d(reshape(im_perm, [N,N]));
    b = b(idx);                            % Extract the sampled indices
    b = b(:);
    
    % Initialize the `A` matrix operator
    opA = @(x, mode) cil_op_binary_scramble_wavelet_2d(x, mode, N, idx, ...
                                        opts.wave_levels, wave_name, perm, ...
                                        perm_rev, hadamard_order);

    %  minimize ||x||_1  s.t.  ||Ax - b||_2 <= sigma
    opts_spgl1 = spgSetParms('verbosity', cil_dflt.spgl1_verbosity);
    opts = cil_merge_structs(opts_spgl1, opts);
    z    = spg_bpdn(opA, b, sigma, opts); 

    % Reconstruct image 
    s = cil_get_wavedec2_s(round(log2(N)), opts.wave_levels);
    im_rec  = waverec2(z, s, wave_name);

    im_rec = (im_rec - min(im_rec(:)))/(max(im_rec(:)) - min(im_rec(:)));

    % Store the image
    imwrite(im2uint8(im_rec), sprintf('%s.%s', filename, ...
                                               cil_dflt.image_format));

    % Store the sampling map
    Y = zeros([N, N] ,'uint8');
    Y(idx) = 255;
    imwrite(im2uint8(flipud(Y)), sprintf('%s_samp.%s', filename, ...
                                               cil_dflt.image_format));

    % Restore dwtmode
    dwtmode(boundary_extension, 'nodisp')

end

