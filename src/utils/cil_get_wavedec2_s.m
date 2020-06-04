% get_waverec2_s(dim, nres) creates the `S` matrix return by wavedec2 for the
% special case where `dwtmode('per')` is used in combination with a Daubechies
% wavelet, and a signal of dimension [2^dim, 2^dim]
%
% INPUT:
% dim  - [2^dim, 2^dim] should be the dimension of the original image
% nres - Number of wavelet decomposition levels
%
% OUTPUT:
% S - The bookkeeping matrix S return by wavedec2
%
function S = cil_get_wavedec2_s(dim, nres) 

    S = 2.^[dim-nres, (dim-nres):dim;...
            dim-nres, (dim-nres):dim ]';
end
