% Spasify the image X in the wavelet domain, by thresholding  1-p of the
% wavelet coefficients and transforming the image back to the original domain.
%
% INPUT
% X         - Image
% p         - fraction in the interval [0,1], representing the number of wavelet
%             coefficients one would like to keep.
% wave_name - Name of the sparsifying wavelet
% 
% OUTPUT
% im_sparse - Image with a sparse wavelet representation.
% wave_coef - The sparse wavelet coefficents
%
% Edvard Aksnes, 2017
function [im_sparse, wave_coef,S]=wavelet_sparsify2d(X, p, wave_name)
    
    N = wmaxlev(size(X), wave_name);
    
    [c,S] = wavedec2(X,N,wave_name);
    
    [o,n] = size(c);
    [sorted, sorted_indices] = sort(-abs(c));
    
    b = zeros(size(c));
    b(sorted_indices(1:round(n*p))) = c(sorted_indices(1:round(n*p)));
    
    im_sparse = waverec2(b, S, wave_name);
    wave_coef = b;
end
