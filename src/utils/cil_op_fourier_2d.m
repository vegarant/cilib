% Two-dimensional Fourier operator with subsampling. 
%
% INPUT
% x    - One dimensional representation of an N × N matrix
% mode - Boolean. If mode == 1, the subsampled Fourier transform is applied,
%        otherwise the conjugate transpose will be used
% N    - Size of the original N × N image
% idx       - The matrix indices one would like to sample, given in an linear
%             order (see sub2ind(..) for conversion to linear order)
%
% OUTPUT
% The result of the operator applied to x.  
%
function y=cil_op_fourier_2d(x, mode, N, idx)

    if (~isvector(x))
        error('Input is not a vector');
    end

    if (mode == 1) 

        z = fftshift(fft2(reshape(x, [N, N])))/N;
        y = z(idx);
        y = y(:);

    else % Transpose

        z = zeros([N, N]);
        z(idx) = x;
        z = ifft2(ifftshift(z))*N;
        y = reshape(z, [N*N, 1]); 

    end
end

