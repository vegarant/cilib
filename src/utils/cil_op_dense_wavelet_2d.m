% cil_op_dense_wavelet_2d computes the vector-matrix mutiplication 
%                       A*W' x                         (1)
% where A is a radon sampling matrix, corresponding to the algebraic 
% discretization, W' is the two dimensional inverse discrete wavelet 
% transform (IDWT) and x is an image (represented as a vector) which 
% we would like to apply the transforms to. See the script 
% Generate_radon_matrix.m on how to generate a sparse version of the A matrix. 
%
% INPUT
% x - vectorized version of the image one would like to apply the 
%     transform in Equation (1) to.
% mode - Whether one would like to apply the A*W' or W*A'. If mode equals 1
%        we apply A*W', else we apply W*A'.
% A - The discretization of the radon transform - See Generate_radon_matrix.m 
%     on how to generate this 
% wname - Wavelet name i.e. 'db2', 'db3', ...
% nres  - Number of wavelet decompositions.
%
% OUTPUT
% The result of the vector-matrix multiplication
%
function y = cil_op_dense_wavelet_2d(x, mode, A, wname, nres)  

    m   = size(A, 1);
    Nsq = size(A, 2);
    N = round(sqrt(Nsq));
    R = round(log2(N));

    if (~isvector(x))
        error('Input is not a vector');
    end

    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end

    if (nargin < 5)
        nres = wmaxlev(N, wname);
    end

    s = cil_get_wavedec2_s(R, nres); 

    if or(mode == 1, strcmp(lower(mode), 'notransp')) 

        z = waverec2(x, s, wname);
        y = A*z(:);

    else % Transpose
        
        z = A'*x;
        z = reshape(z, [N,N]);
        y = wavedec2(z, nres, wname)';

    end
end






