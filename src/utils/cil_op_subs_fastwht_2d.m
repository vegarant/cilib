% Two dimensional subsampled fast Walsh-Hadamard transform. The transform is
% normalized, so that the transform becomes unitary. 
%
% INPUT
% X     - Matrix to be transformed, written as a column vector.
% mode  - If mode is not equal to 1, the transpose matrix product will be applied. 
%        Otherwise the usual matrix product will be applied.
% N     - The size of X as a N×N-matrix.
% idx   - Linear indices of the samples one would like to obtain.  
% order - The order of the Walsh-Hadamard transform. 
%           * 'sequency' (default)
%           * 'hadamard' 
%           * 'dyadic'
%
% OUTPUT
% Y - The transformed matrix
% 
function Y = cil_op_subs_fastwht_2d(X, mode, N, idx, order)

    if (nargin < 5)
        order = 'sequency';
    end

    if (~isvector(X))
        error('Input is not a vector');
    end

    if (mode == 1) 

        X = reshape(X, [N, N]);
        Z = cil_op_fastwht_2d(X, order);
        Y = Z(idx);
        Y = reshape(Y, [length(idx), 1]);

    else % Transpose

        Z = zeros([N, N]);
        Z(idx) = X;
        Z = cil_op_fastwht_2d(Z, order);
        Y = reshape(Z, [N*N, 1]); 

    end
end





