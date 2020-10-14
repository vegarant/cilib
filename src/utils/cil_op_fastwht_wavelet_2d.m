% This function acts as a matrix product between a hadamard matrix and a
% inverse daubechies wavelet matrix, both in two dimensions. the resulting
% matrix is subsampled by the linear indices specified by `idx`. 
%
% INPUT:
% x    - Column vector. The vector will be reshaped to the two dimensional
%        matrix X.
% mode - If mode is not equal to 1, the transpose matrix product will be applied. 
%        Otherwise the usual matrix product will be applied.
% N    - Size of x as a N×N-matrix.
% idx  - Linear indices of the samples one would like to obtain.  
% nres - Number of wavelet resolution spaces.
% wave_name - Name of the wavelet
% hadamard_order - The order of the Hadamard matrix. 
%           * 'sequency' (default)
%           * 'hadamard' 
%           * 'dyadic'
%
% OUTPUT:
% y - The two dimensional signal, reshaped into a vector.
%
% SEE ALSO:
% `sub2ind`, `fastwht`, `cil_op_fastwht_2dd`, `DWT2Impl` and `IDWT2Impl`.
%
function y=cil_op_fastwht_wavelet_2d(x, mode, N, idx, nres, wave_name, hadamard_order)
    
    if (nargin < 7)
        hadamard_order = 'sequency';
    end

    if mode == 1 
        S = cil_get_wavedec2_s(round(log2(N)), nres); 
        z = waverec2(x, S, wave_name);
        z = cil_op_fastwht_2d(z, hadamard_order);
        y = z(idx);

    else % Transpose

        z = zeros(N, N);
        z(idx) = x;
        z = cil_op_fastwht_2d(z, hadamard_order);
        [y, S] = wavedec2(z, nres, wave_name);
        y = y';
    end
end
