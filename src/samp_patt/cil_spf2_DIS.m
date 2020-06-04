% OPS: This function is under construction, do not use it  

function [idx, str_id] = cil_spf2_DIS(N, nbr_samples, sparsity, vm)

    str_id = 'DIS';

    r = round(log2(N));
    nres = numel(sparsity);
    J0 = r - nres;

    % Compute 
    % m_k = s_k + sum_{l=1}^{k-1} 2^{-2q(k-l)} s_l  + sum_{l=k+1}^{r}  2^{-2(p+1)(l-k)} 
    % and make all the m_k's sum to 1. We call this the density
    density = compute_density(N, sparsity, vm);
    
    % Compute sampling level boundaries 
    max_level_size = [2^(2*(J0+1))];
    for i = 2:nres;
        new_size = 3*2^(2*(J0+i-1));
        max_level_size = [max_level_size, new_size];
    end
    % to be able to reuse some old code we have to hac a little bit with some 
    % of level sizes
    for i = 1:nres-1
        max_level_size(i) = max_level_size(i) + 2^(J0 +i+1);
        max_level_size(i+1) = max_level_size(i+1) - 2^(J0 +i+1);
    end
    max_level_size(1) = max_level_size(1) + 1;
    max_level_size(end) = max_level_size(end) - 1;
    %max_level_size
    f = @(c) func_for_bisection_method(c, density, max_level_size, nbr_samples); 
    
    % Apply the bisection method to find the optimal constant for scaling.
    xl = nbr_samples/8;
    xh = nbr_samples*8;
    m = cil_bisection(f, xl, xh); 

    nbr_samples_in_levels = round(m*density);
    leagal_levels = nbr_samples_in_levels <= max_level_size;
    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
    if (sum(nbr_samples_in_levels) ~= nbr_samples)    
        fprintf('Error cil_spf2_DIS: Wrong number of samples\n');
    end
    
    %nbr_samples_in_levels
    idx = sample_in_levels(N, nbr_samples_in_levels);


end

% This function is where the bug lies
function idx = sample_in_levels(N, nbr_samples_in_levels);
    r = round(log2(N));
    nres = length(nbr_samples_in_levels);
    j0 = r - nres;    
    
    c = [N/2,N/2];
    radius = 1;
    p_norm = inf;
    shapef = cil_shape_ball(c, radius, p_norm);
    level_sizes = 2.^(1*(j0 + (0:nres-1)));
    idx = cil_sp_from_shape(N, shapef, level_sizes, nbr_samples_in_levels);
end

function density = compute_density(N, sparsity, vm)
    qValues = [0, 0.339, 0.636, 0.913, 1.177, 1.432, 1.682, 1.927, 2.168, 2.406];
    q = qValues(vm);    

    r = round(log2(N));
    nres = numel(sparsity);
    J_0 = r - nres;

    m_mat = zeros([1, nres]);
    
    for k=1:nres
        
        m = sparsity(k);
        for l = 1:k-1
            m = m + 2^(-2*q*(k-l))*sparsity(l);
        end
        for l = k+1:nres
            m = m + 2^(-2*(vm+1)*(l-k))*sparsity(l);
        end 
        m_mat(k) = m;
    end
    density = m_mat./sum(m_mat(:));
end


function s = func_for_bisection_method(c, density, max_level_size, nbr_samples) 

    nbr_samples_in_levels = round(c*density);
    leagal_levels = nbr_samples_in_levels <= max_level_size;
    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
    s = sum(nbr_samples_in_levels(:)) - nbr_samples;

end

