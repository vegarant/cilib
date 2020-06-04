% Compute the sparsity of a square grayscale image at each wavelet 
% scale.
%
% INPUT:
% im - Square grayscale image
% vm - Number of vanishing moments
% nres - (optional) Number of wavelet scales (Default: Maximum number of scales)
% epsilon - (optional) Count every coefficient whose absolute value 
%           exceeds epsilon. (Default: 1e-1. The image is scaled to [0, 1])
%
% OUTPUT:
% Vector with the number of non-zero coefficients in each scale. The vector 
% is ordered from the coarsest to finest levels. 
% 
function sparsity = cil_compute_sparsity_of_image(im, vm, nres, epsilon)
    % Store current boundary extension mode
    boundary_extension = dwtmode('status', 'nodisp');
    % Set the correct boundary extension for the wavelets
    dwtmode('per', 'nodisp');
    
    ma = max(im(:));
    mi = min(im(:));
    im = (im - mi)/(ma-mi); % scale image to [0, 1];
    
    if (size(im,1) ~= size(im,2))
        fprintf('Error: Image must be square\n');
    end
    if (length(size(im)) > 2)
        fprintf('Error: Image must be gray scale\n');
    end 
    
    N = size(im, 1);
    wname = sprintf('db%d', vm); 
    if (nargin < 3)
        nres = wmaxlev(N, wname);
    end
    if (nargin < 4)
        epsilon = 1e-1;
    end

    r = round(log2(N));
    J_0 = r - nres;

    [c,S] = wavedec2(im, nres, wname);

    sparsity = [];

    M = [1];

    for i = 1:nres
        M = [M, 2^(2*(J_0+i))]; 
    end

    for i = 1:nres
        idx = M(i):M(i+1);
        s = sum( abs( c( idx ) ) > epsilon); 
        sparsity = [sparsity, s];
    end

    % Restore dwtmode2
    dwtmode(boundary_extension, 'nodisp');
end
