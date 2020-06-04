% An operator combining a subsampled 2-dimensional circulant convolution 
% and a discrete wavelet transform.
%
% Let c be an [N, N] matrix reshaped into a [N^2, 1] vector, be the filter 
% coefficients of a circular convolution. Let ** denote circular convolution.
% Let W denote a 2-dimensional discrete wavelet transform and let P denote a
% projection a subset of the canonical basis for R^N. The forward operation of
% this operator is 
%                       P (c ** (W^{-1} x))                       
% where x is an N×N matrix reshaped into a vector. 
%
% This function takes advantage of the Fourier transform in the following way. 
% Let `c` be the filter coefficients of a convolutional matrix and let **
% denote convolution. We then have the following equality for a vector `x`
%               c ** x = IFFT( FFT(c) * FFT(x) ).
% Hence circular convolution is the same as multiplication in the Fourier
% domain. We let the input argument `D = fft2(c)`, where C is an N×N matrix
% with the convolutional filter coefficients, and take advantage of this
% equality in the following implementation. 
%
% INPUT
% x        - Input vector. If mode == 1, then length(x) = N^2, otherwise 
%            length(x) = length(idx).
% mode     - Whether to apply the forward or backward transform, if mode == 1 
%            or mode == 'notransp', the forward transform is used. 
% D        - 2-dimensional Fourier transform of the filter coefficients, an N×N
%            matrix of Fourier coefficents
% idx      - The matrix indices one would like to sample, given in an linear
%            order (see sub2ind(..) for conversion to linear order)
% wname    - Wavelet name, use dwtmode('per') and let wname be the name of a
%            compactly supported orthonormal wavelet.
% nres     - Number of wavelet decompositions. This argument is optional, if
%            not specified, it will be set to the maximum number of wavelet
%            decompositions. 
%
% OUTPUT
% y - The two dimensional signal, reshaped into a vector.
% 
function y = cil_op_binary_circulant_wavelet_2d(x, mode, D, idx, wname, nres)

    N = size(D,1);
    if nargin < 6
        nres = wmaxlev(N, wname); 
    end
    if or(mode == 1, strcmp(lower(mode), 'notransp')) 
        S = cil_get_wavedec2_s(round(log2(N)), nres); 
        x = waverec2(x, S, wname);
        x = reshape(x, [N,N]);
        z = ifft2(D.*fft2(x));
        y = z(idx);
        y = y(:);
    else
        z = zeros(N,N);
        z(idx) = x;
        y = ifft2(conj(D).*fft2(z));
        [y, S] = wavedec2(y, nres, wname);
        y = reshape(y,N*N,1);
    end
end
