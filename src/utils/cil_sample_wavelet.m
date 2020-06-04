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
    a = 2^nres; % 
    c = zeros([N,1]);

    S = cil_get_wavedec_s(r,nres);
    % Compute psi vector
    psi = zeros([1,N]);
    psi(p) = 2^(nres/2);
    psi = waverec(psi, S, wname);
    ub = 2^(nres)*(2*p - 1);
    psi = psi(1:ub);
    psi = 2^(r/2)*psi;
    %plot(psi)
    dt = 2^(-r);
    for k = 1:(p-1)
        
        t_left    = linspace(0, dt*(p + k-1), (p+k-1)*a);
        t_right   = linspace(1-dt*(p-k), 1, (p-k)*a);
        psi_left  = psi((p-k)*a+1:(2*p-1)*a);
        psi_right = psi(1:(p-k)*a);
        
        s1 = sum(psi_left.*f(t_left));
        s2 = sum(psi_right.*f(t_right));
        c(k) = dt*(s1 + s2)/a;
        
    end
    for k = p:N-p
        t = linspace(dt*(k-p), dt*(p + k-1), (2*p-1)*a);
        c(k) = dt*sum(psi.*f(t))/a;
    end
    
    
    k = 1;
    for i = N-p+1:N
        t_left = linspace(0, dt*k, k*a);
        t_right = linspace(1-dt*(2*p-1 +(k-1)), 1, (2*p - 1 - k)*a);
        psi_left = psi((2*p-1-k)*a+1:end);
        psi_right = psi(1:(2*p-1-k)*a);
        s1 = sum(psi_left.*f(t_left));
        s2 = sum(psi_right.*f(t_right));
        c(i) = dt*(s1 + s2)/a;
        k = k + 1;
    end
    
    if (p==1) % Special case, need to compute the last sample correctly.
        k = N;
        t = linspace(dt*(k-p), dt*(p + k-1), (2*p-1)*a);
        c(k) = dt*sum(psi.*f(t))/a;
    end

end
