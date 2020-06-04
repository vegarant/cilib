% Creates a multi-level sampling pattern where each sampling level has the 
% shape indicated by shapef. The first sampling level is always fully sampled.
% 
% INPUT
% N           - Size of image is N x N
% nbr_samples - Number of samples
% shapef      - Function handle shape(x,y,scale), telling whether or not the
%               coordinates x and y is contained in the scale. 
% 0 < m < 1   - Faction of N we would like to fully sample.
% nbr_levels  - Number of sampling levels
% 
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
%
% Vegard Antun, 2017.
%
function [idx, str_id] = cil_sp2_exp(N, nbr_samples, shapef, m, nbr_levels)
    str_id = 'exp';
    
    n = nbr_levels;
    
    scales = round((1:n)*N/n);
    bin_sizes = cil_compute_bin_sizes(N, shapef, scales);
    if (bin_sizes(1) >= nbr_samples) 
        warning('cilib:samp_patt:to_few_levels', ...
        'cil_sp2_exp: The first level will be fully sampled, and this level is larger that the total number of samples');
    end

    f = @(a) sum(sum(round(exp(log(0.95)/(m.^a).*((0:n)/n).^a).*bin_sizes))) - nbr_samples;
    a = bisection(f, 1e-5, 149);
    level_size = round(exp((log(0.95)/m^a).*((0:n)/n).^a).*bin_sizes);
    
    idx = cil_sp_from_shape(N, shapef, scales, level_size);
    if (length(idx) ~= nbr_samples)
        fprintf('Warning: cil_sp2_exp was supposed to create %d samples, but sampled %d entries\n', ...
                 nbr_samples, length(idx));
    end
end

function m=bisection(f, xl, xh)
    eps = 1e-8;
    max_itr = 1000;
    
    fl = f(xl);
    fh = f(xh);
    fm = 100;
    if (abs(fl) < eps)
        m = xl;
        fm = 0;
    end
    if (abs(fh) < eps)
        m = xh;
        fm = 0;
    end
    
    if (fl*fh > 0)
        print('Bisection method failed: fl = %d, fh = %d\n', fl, fh);
        assert(fl*fh <= 0);
    end
    
    i = 1;
    while (i < max_itr & abs(fm) >= eps)
        m = (xh+xl)/2;
        fm = f(m);
        if (fm*fl < 0)
            xh = m;
        else
            xl = m;
            fl = fm;
        end
        i = i + 1;
    end
end


