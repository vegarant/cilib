% Preforms a fourier sampling experiment with shearlet + TGV + reweihting 
% reconstruction. 
%
% Note that this code is somehow 'non-standard' in the cilib library, and
% realizes on a lot of different packages. It is not our intention to
% reimplement everything to make it fit into this framework.
%
%
function im_rec = cil_sample_fourier_shearlet_tgv_reweighting(im, idx, filename, nbr_iterations, varargin)
    load('cilib_defaults.mat') % load font size, line width, etc.
    N = size(im, 1);

    max_im_val = max(im(:)); 
    im = im/max_im_val;
    
    mask = zeros([N,N], 'logical');
    mask(idx) = logical(1);

    A = getFourierOperator([N,N], mask);
   
    sparse_param = [1, 1, 2];
    D = getShearletOperator([N,N], sparse_param);

    y = A.times(im(:));
    
    % set parameters
    beta        = 1e5;
    alpha       = [1 1];
    mu          = [5e3, 1e1, 2e1];
    epsilon     = 1e-5;
    
    maxIter     = nbr_iterations;
    adaptive    = 'NewIRL1';
    %correct     = @(x) real(x);
    doTrack     = true;
    doPlot      = false;
    
    out = TGVsolver(y, [N,N], A, D, alpha, beta, mu, ...
                'maxIter',  maxIter, ...
                'adaptive', adaptive, ...
                'f',        im, ...
                'epsilon',  epsilon, ...
                'doTrack',  doTrack, ...
                'doPlot',   doPlot);

    im_rec = abs(out.rec);
    
    im_rec = (im_rec - min(im_rec(:)))/(max(im_rec(:)) - min(im_rec(:)));
    X = abs(im_rec);
    
    % Store the image
    imwrite(im2uint8(X), sprintf('%s.%s', filename, ...
                                               cil_dflt.image_format));

    % Store the sampling map
    Y = zeros([N, N] ,'uint8');
    Y(idx) = 255;
    imwrite(im2uint8(Y), sprintf('%s_samp.%s', filename, ...
                                               cil_dflt.image_format));

    % Scale the image to the right return value range
    im_rec = max_im_val*im_rec;
end

