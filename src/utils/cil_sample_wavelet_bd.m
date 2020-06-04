% This function is not working yet
% 
% Samples the function f in the wavelet domain.
%
% INPUT
% f - Function handle f: R -> R.
% p - Number of vanishing moments.
% r - Scaling function resolution space V_{r}^{per} where |V_r| = 2^r.
%
% OUTPUT
% c - Scaling function coefficents in V_{r}^{per}. 
% 
function c=cil_sample_wavelet(f, p, r);

    wname = sprintf('db%d', p);
    j0 = cil_compute_j0(p);
    nres = r - j0;
    N = 2^r;
    a = 2^nres % 
    c = zeros([N,1]);
    j0
    nres

    % Compute psi vector
    psi = zeros([N,1]);
    psi(p) = 2^(nres/2);
    psi = idwt_impl(psi, nres, wname, 'bd');
    psi = psi';
    ub = 2^(nres)*(2*p - 1);
    psi = psi(1:ub);
    psi = 2^(r/2)*psi;
    
    %plot(psi)
    dt = 2^(-r)

    
    % Center coefficents
    % Compute psi vector
    psi = zeros([N,1]);
    psi(p+1) = 2^(nres/2);
    psi = idwt_impl(psi, nres, wname, 'bd');
    psi = psi';
    lb = 2^(nres)
    ub = 2^(nres)*(2*p);
    psi = psi(lb+1:ub);
    psi = 2^(r/2)*psi;

    for k = p+1:N-p
        t = linspace(dt*(k-p), dt*(p + k-1), (2*p-1)*a);
        s1 = dt*sum(psi.*psi)/a;
        s3 = s1
        c(k) = dt*sum(psi.*f(t))/a;
    end
    fprintf('Computing left edge\n')
    % Left edge    
    for k = 1:(p)
        psi = zeros([N,1]);
        psi(k) = 2^(nres/2);
        psi = idwt_impl(psi, nres, wname, 'bd', 'none');
        psi = psi';
        ub = 2^(nres)*(p + k -1);
        psi = psi(1:ub);
        psi = 2^(r/2)*psi;
%        fig = figure();    
%        plot(psi); title(sprintf('vm: %d, psi_{%d, %d}', p, r, k-1));
        t_left    = linspace(0, dt*(p + k-1), (p+k-1)*a);
        psi_left  = psi(1:(p+k-1)*a);
        fprintf('norm: %g\n', norm(psi((p+k-1)*a +1:end)));
        
        s1 = sum(psi_left.*f(t_left));
        s2 = sum(psi_left.*psi_left);
        s3 = dt*s2/a
        c(k) = (dt*s1/a)/ (dt*s2/a);
        
    end
    %t_left

    % Right edge coefficents
    fprintf('Computing right edge\n')
    for k = 1:p % = N-p+1:N
        psi = zeros([N,1]);
        psi(2^(j0)-k+1) = 2^(nres/2);
        psi = idwt_impl(psi, nres, wname, 'bd', 'none');
        psi = psi';
        psi = 2^(r/2)*psi;
        
        t_right = linspace(1-dt*(p+k-1), 1, (p+k-1)*a);
        fprintf('norm: %g\n', norm(psi(1:N-(p+k-1)*a)));
        psi_right = psi(N-(p+k-1)*a+1:N);
        %figure(); plot(psi_right);
        s1 = sum(psi_right.*f(t_right));
        s2 = sum(psi_right.*psi_right)
        s3 = (dt*s2/a)
        c(N-k+1) = (dt*s1/a)/ (dt*s2/a);
    end

end
