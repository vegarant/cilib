% For an image 'im', an 'nres' DWT is computed using a Daubechies wavelet
% with 'vm' vanishing moments. The 's' larges wavelet coefficients are then 
% located, and we tally up how many of them lies in each wavelet scale. The
% function returns an image 'approx' where all, except the s larges wavelet 
% coefficients, have been zeroed out. It also return a vector 'sparsities'
% with the number of non-zero coefficients in each level.
%
% INPUT:
% im   - Grayscale image
% s    - Total sparsity
% vm   - Number of vanishing moments for the wavelet
% nres - Number of wavelet decompositions
%
% OUTPUT:
% approx     - Image, whose wavelet transform contains at most s non-zero i
%              wavelet coefficients 
% sparsities - Vector with the number of non-zero wavelet coefficients at each
%              scale 
function [approx, sparsities] = cil_compute_best_s_term_approx(im, s, vm, nres)

    % Store current boundary extension mode
    boundary_extension = dwtmode('status', 'nodisp');
    % Set the correct boundary extension for the wavelets
    dwtmode('per', 'nodisp');

    N = size(im, 1);
    wname = sprintf('db%d', vm); 
    if (nargin < 4)
        nres = wmaxlev(N, wname);
    end

    r = round(log2(N));
    J_0 = r - nres;

    [c,S] = wavedec2(im, nres, wname);

    [~, idx1] = sort(abs(c), 'descend');
    
    c_sparse = zeros(size(c));
    c_sparse(idx1(1:s)) = c(idx1(1:s));

    sparsities = [];

    M = [1];

    for i = 1:nres
        M = [M, 2^(2*(J_0+i))]; 
    end

    for i = 1:nres
        idx = M(i):M(i+1);
        s1 = sum( abs( c_sparse( idx ) ) > 1e-12); 
        sparsities = [sparsities, s1];
    end
    approx = waverec2(c_sparse, S, wname);

    

    % Restore dwtmode2
    dwtmode(boundary_extension, 'nodisp');

end


