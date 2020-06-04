% fourier2cuvelet2d() is a function which perform as a two-dimensional Fourier
% operator multiplied by a two-dimensional inverse cuvelet transform,
% subsampled in the indices provided by `idx`.
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
% cuvelet_system - Cell-array of cell arrays containing the size of the
%                  cell-array and matrices returned by fdct_wrapping.
% n         - Number of cuvelet coefficents 
% is_real   - Type of transform, 
%                0: complex-valued curvelets
%                1: real-valued curvelets
%
% OUTPUT
% The result of the operator applied to x.  
%
function y = cil_op_fourier_curvelet_2d(x, mode, N, idx, curvelet_system, n, is_real);

    if (~isvector(x))
        error('Input is not a vector');
    end

    R = round(log2(N));

    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end

    if (mode == 1)
        
        %x = reshape(x, [N, N, dim3]);
        C = fdct_wrapping_vector2cell(x, curvelet_system);
        z = ifdct_wrapping(C, is_real, N,N);
        z = fftshift(fft2(z))/N;
        y = z(idx);

    else % Transpose

        z = zeros([N, N]);
        z(idx) = x;
        z = ifft2(ifftshift(z))*N;
        C = fdct_wrapping(z, is_real, 2);
        y = fdct_wrapping_create_vector(C, n);
    
    end
    
end

