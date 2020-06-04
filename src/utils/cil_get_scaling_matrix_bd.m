% Creates a matrix where each column contain the coefficients of exactly one
% scaling function. All, except the `vm` first and last columns, contains
% translated versions of the same scaling function. The returned matrix have
% size [N, M]. Thus this function is ideal if you need to plot a wavelet
% approximation to a function, given some wavelet coefficients
%
% INPUT
% vm - Number of vanishing moments for a Daubechies wavelet
% N - Number of row in output the matrix
% M - Number of columns in the output matrix
% It is assumed that M = 2^r and N = 2^(r+q) for positive integers r and q
%
% OUTPUT
% A N × M matrix
function A = cil_get_scaling_matrix_bd(vm, N, M)
    is_per = 1;
    if (2*M > N)
        disp('Error: N should satisfy N >= 2*M');
    end
    
    log2M = floor(log2(M));
    log2N = floor(log2(N));
    
    nres = log2N - log2M;
    wname = sprintf('db%d', vm);

    % Generate scaling function
    j0 = cil_compute_j0(vm);
    r = j0 + nres;
    N_inner = 2^r;
    a = 2^nres;
    
    phi = zeros([N_inner,1]);
    phi(vm+1) = 2^(nres/2);
    phi = idwt_impl(phi, nres, wname, 'bd');
    phi = phi';
    ub = a*(2*vm);
    phi = phi(a+1:ub);
    
    
    x = zeros([N,1]);
    x(1:vm*a) = phi(a*(vm-1)+1:a*(2*vm-1));
    x(N-a*(vm-1)+1:N) = phi(1:a*(vm-1));

    A = zeros([N,M]);

    % Generate the inner matrix first
    for i = vm+1:M-vm
        A(:,i) = circshift(x, a*(i-1));
    end

    % Generate left edge boundary functions
    for k = 1:vm
        phi = zeros([N_inner,1]);
        phi(k) = 2^(nres/2);
        phi = idwt_impl(phi, nres, wname, 'bd', 'bd_pre');
        phi = phi;
        ub = a*(vm+k-1);
        phi = phi(1:ub);
        A(1:ub, k) = phi;
    end

    % Generate right edge boundary functions
    for k = 1:vm
        phi = zeros([N_inner,1]);
        phi(2^(j0)-k+1) = 2^(nres/2);
        phi = idwt_impl(phi, nres, wname, 'bd', 'bd_pre');
        phi = phi;
        phi = phi(N_inner-a*(vm+k-1)+1:N_inner);
        A(N-a*(vm+k-1)+1:N, M-k+1) = phi;
    end

    A = 2^(log2M/2)*A;
end

