% Same as `cil_op_dense_wavelet_2d`, except it takes the extra arguments idx_t, which crop
% out parts of the rows of the matrix `A`. 
function y = cil_op_cont_radon_wavelet_2d(x, mode, A, idx_t, size_sinogram, wname, nres);  

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

    if (nargin < 7)
        nres = wmaxlev(N, wname);
    end
    
    views = size_sinogram(2);
    n = length(idx_t);

    s = cil_get_wavedec2_s(R, nres); 

    if or(mode == 1, strcmp(lower(mode), 'notransp')) 

        z = waverec2(x, s, wname);
        y = A*z(:);
        y = reshape(y, size_sinogram);
        y = y(idx_t, :);
        y = y(:);
    else % Transpose
        x = reshape(x, [n, views]);
        z = zeros(size_sinogram);
        z(idx_t, :) = x;
        z = z(:);
        z = A'*z;
        z = reshape(z, [N,N]);
        y = wavedec2(z, nres, wname)';

    end
end

