% get_waverec_s(dim, nres) creates the `S` matrix return by wavedec for the
% special case where `dwtmode('per')` is used in combination with a Daubechies
% wavelet, and a signal of size 2^dim
%
% INPUT:
% dim  - 2^dim should be the dimension of the original signal
% nres - Number of wavelet decomposition levels
%
% OUTPUT:
% S - The bookkeeping matrix S return by wavedec
%
function s = cil_get_wavedec_s(dim, nres) 
    s = 2.^[dim-nres, (dim-nres):dim]';
end

