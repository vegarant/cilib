% Creates a matrix where each column contain the coefficients of exactly one
% scaling function. All, except the `vm` first and last columns, contains
% translated versions of the same scaling function. The returned matrix have
% size [N, M]. Thus this function is ideal if you need to plot a wavelet
% approximation to a function, given some wavelet coefficents
%
% INPUT
% vm - Number of vanishing moments for a Daubechies wavelet
% N - Number of row in output the matrix
% M - Number of columns in the output matrix
% It is assumed that M = 2^r and N = 2^(r+q) for positive integers r and q
%
% OUTPUT
% A N × M matrix
function A = cil_get_scaling_matrix_per(vm, N, M)
    is_per = 1;
    if (2*M > N)
        disp('Error: N >= 2*M');
    end
    
    j     = floor(log2(M));
    log2N = floor(log2(N));
    
    L = log2N - j;
    
    [~, phi] = get_scaling_fn(vm, L, is_per);
    
    x = zeros([N,1]);
    x(1:2^L * vm) = phi(2^L*(vm-1)+1:2^L*(2*vm-1));
    x(N-2^L*(vm-1)+1:N) = phi(1:2^L*(vm-1));

    A = zeros([N,M]);
    
    for i = 1:M
        A(:,i) = circshift(x, 2^L*(i-1));
    end
    A = 2^(j/2)*A;
end

