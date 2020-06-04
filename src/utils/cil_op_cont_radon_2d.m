% Same as `cil_op_dense`, except it takes the extra arguments idx_t, which crop
% out parts of the rows of the matrix `A`. 
function y = cil_op_cont_radon_2d(x, mode, A, idx_t, size_sinogram);  

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

    views = size_sinogram(2);
    n = length(idx_t);


    if or(mode == 1, strcmp(lower(mode), 'notransp')) 


        y = A*x(:);
        y = reshape(y, size_sinogram);
        y = y(idx_t, :);
        y = y(:);
    else % Transpose
        x = reshape(x, [n, views]);
        z = zeros(size_sinogram);
        z(idx_t, :) = x;
        z = z(:);
        y = A'*z;

    end
end

