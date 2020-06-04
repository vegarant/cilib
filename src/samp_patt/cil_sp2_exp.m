% Creates a multi-level sampling pattern where each sampling level has the 
% shape indicated by shapef. 
% 
% INPUT
% N           - Size of image is N x N
% nbr_samples - Number of samples
% shapef      - Function handle shape(x,y,scale), telling whether or not the
%               coordinates x and y is contained in the scale. 
% a           - Decay parameter
% r0          - Fully sample the r_0 first levels
% nbr_levels  - Number of sampling levels (we denote the quantity by 'r').
% 
% Suppose the sets B_k, k=1,2,...,r is a partition of [1,2,...,N]^2. This
% function strives to find local sampling densities p_k = m_k / |B_k|, 
% such that p_k = 1 for k=1,...,r0 and
% 
% p_k = exp( -(b(k-r_0)/(r-r0))^a )      for k = r_0+1,...,r.
%
% This is achived by adjusting b, so that m_1 + m_2 + ... + m_r = nbr_samples.
% Sometimes we are not able to find such a b, then the function fails.
%
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
%
% Vegard Antun, 2017.
%
function [idx, str_id] = cil_sp2_exp(N, nbr_samples, shapef, a, r0, nbr_levels)
    str_id = 'exp';

    n = nbr_levels;

    scales = round((1:n)*N/n);
    level_idx = 0:n;
    level_idx(1:r0) = 0;
    level_idx(r0+1:n+1) = 0:(n-r0);
    bin_sizes = cil_compute_bin_sizes(N, shapef, scales);
    if (bin_sizes(1) >= nbr_samples) 
        warning('cilib:samp_patt:to_few_levels', ...
        'cil_sp2_exp: The first level will be fully sampled, and this level is larger that the total number of samples');
    end

    level_idx = 0:n;
    level_idx(1:r0) = 0;
    level_idx(r0+1:n+1) = 0:(n-r0);

    f = @(b) sum(sum(round(exp(-( (b.*level_idx/(n-r0)).^a )).*bin_sizes))) - nbr_samples;
    b = cil_bisection(f, 1e-5, 2000);
    
    level_size = round(exp(-((b.*level_idx/(n-r0)).^a)).*bin_sizes);
    
    idx = cil_sp_from_shape(N, shapef, scales, level_size);
    if (length(idx) ~= nbr_samples)
        fprintf('Warning: cil_sp2_exp was supposed to create %d samples, but sampled %d entries\n', ...
                 nbr_samples, length(idx));
    end
end




