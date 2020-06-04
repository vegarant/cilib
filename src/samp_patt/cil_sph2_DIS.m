function [idx, str_id] = cil_sph2_DIS(N, nbr_samples, sparsity)

    str_id = 'DIS';

    r = round(log2(N));
    nres = numel(sparsity);
    J0 = r - nres;

    bv = [];
    for i = 1:nres
        bv =[bv, 2^(J0+i)];
    end

    density = compute_density(N, sparsity);
    max_level_size = [2^(2*(J0+1))];
    for i = 2:nres;
        new_size = 3*2^(2*(J0+i-1));
        max_level_size = [max_level_size, new_size];
    end

    f = @(c) func_for_bisection_method(c, density, max_level_size, nbr_samples); 

    % Apply the bisection method to find the optimal constant for scaling.
    xl = nbr_samples/8;
    xh = nbr_samples*8;
    m = cil_bisection(f, xl, xh); 

    nbr_samples_in_levels = round(m*density);
    leagal_levels = nbr_samples_in_levels <= max_level_size;
    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
    if (sum(nbr_samples_in_levels) ~= nbr_samples)    
        fprintf('Error cil_sph2_DIS: Wrong number of samples\n');
    end

    idx = sample_in_levels(N, nbr_samples_in_levels);

end

function idx = sample_in_levels(N, nbr_samples_in_levels);
    r = round(log2(N));
    nres = length(nbr_samples_in_levels);
    j0 = r - nres;    
    
    c = [0,0];
    radius = 1;
    p_norm = inf;
    shapef = cil_shape_ball(c, radius, p_norm);
    level_sizes = 2.^(j0 + (1:nres));
    idx = cil_sp_from_shape(N, shapef, level_sizes, nbr_samples_in_levels);
end

function density = compute_density(N, sparsity)

    r = round(log2(N));
    nres = numel(sparsity);
    J_0 = r - nres;

    bv = [];
    for i = 1:nres
        bv =[bv, 2^(J_0+i)];
    end
    bh = bv;

    m_mat = zeros([1, nres]);
    
    for k=1:nres
        m = sum(sparsity(1:k));
        for  l = k+1:nres
            m = m + 2^(-2*(l-k))*sparsity(l);
        end 
        m_mat(k) = m;
    end
    density = m_mat./sum(m_mat(:));
%    density = density/sum(m_mat(:));
end


function s = func_for_bisection_method(c, density, max_level_size, nbr_samples) 

    nbr_samples_in_levels = round(c*density);
    leagal_levels = nbr_samples_in_levels <= max_level_size;
    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
    s = sum(nbr_samples_in_levels(:)) - nbr_samples;

end















