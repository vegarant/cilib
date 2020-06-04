% cil_op_fourier_wavelet_2d() is a function which perform as a two-dimensional Fourier
% operator multiplied by a two-dimensional inverse Daubechies wavelet transform,
% subsampled in the indices provided by `idx`.
% 
% In one dimension it can be explained as the matrix multiplication
%                          P_Ω * V * ψ^(-1) * x
% where P_Ω is a projection matrix, projecting each of the indices j ∈ 
% Ω ⊂ {1,2, ..., N}, |Ω| = m ≤ N, onto the canonical basis e_j. Furthermore V
% is the Fourier matrix, Ψ^(-1) is the inverse wavelet transform matrix and x ∈
% ℂ^n is the signal of interest. 
% 
% INPUT
% x         - vector of length 2^(2R) for some natural number R. x should
%             represent an matrix written as a vector
% mode      - boolean. If mode == 0 the conjugate transpose operator will be
%             applied, otherwise if mode == 1 the usual operator will be used.
% N         - Using a nonzero `mode`, the length of `x` should be N*N. That is 
%             x should represent a matrix of size N × N, where N = 2^R for some 
%             natural number R. 
% idx       - The matrix indices one would like to sample, given in an linear
%             order (see sub2ind(..) for conversion to linear order)
% nres      - Number of wavelet decompositions. 
% wave_name - Name of the Daubechies wavelet one would like to use. That is 
%             'dbX' for some number X = 1,2, ..., 45. 
%
% OUTPUT
% The result of the operator applied to x.  
%
function y = cil_op_fourier_wavelet_2d(x, mode, N, idx, nres, wave_name);

    if (~isvector(x))
        error('Input is not a vector');
    end

    R = round(log2(N));

    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end

    s = cil_get_wavedec2_s(R, nres); 

    if (mode == 1)

        z = waverec2(x, s, wave_name);
        z = fftshift(fft2(z))/N;
        y = z(idx);

    else % Transpose

        z = zeros([N, N]);
        z(idx) = x;
        z = ifft2(ifftshift(z))*N;
        y = wavedec2(z, nres, wave_name)';

    end
end

