% Sample using a subsampled 2-dimensional circulant convolution operator
%
% Samples the N×N image `x`, which we assume is given as a [N^2, 1] vector
% using a circulant convolutional operator. 
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
%            matrix of Fourier coefficients
% idx      - The matrix indices one would like to sample, given in an linear
%            order (see sub2ind(..) for conversion to linear order)
%
% OUTPUT
% y - The two dimensional signal, reshaped into a vector.
% 
function y = cil_op_binary_circulant_2d(x, mode, D, idx)

    N = size(D,1);

    if or(mode == 1, strcmp(lower(mode), 'notransp')) 
        x = reshape(x,N,N);
        z = ifft2(D.*fft2(x));
        y = z(idx);
        y = y(:);
    else
        z = zeros(N,N);
        z(idx) = x;
        z = reshape(z,N,N);
        y = ifft2(conj(D).*fft2(z));
        y = reshape(y,N*N,1);
    end
end
