%  
%  +----bh(1)------bh(2)--------------bh(3)-------------bh(4)
%  |     |          |                  |                 |
% bv(1) -+----------+------------------+-----------------+
%  |     |          |                  |                 |
% bv(2)--+----------+------------------+-----------------+
%  |     |          |                  |                 |
%  |     |          |                  |                 |
% bv(3)--+----------+------------------+-----------------+
%  |     |          |                  |                 |
%  |     |          |                  |                 |
%  |     |          |                  |                 |
%  |     |          |                  |                 |
% bv(4)--+----------+------------------+-----------------+
% 
% INPUT:
% nbr_samples - Number of samples in total
% density     - Density matrix 
% bv          - Vertical bounds
% bh          - Horizontal bounds
%
% OUTPUT
% idx - linear indices of the chosen samples
%
function idx = cil_sph2_multi(nbr_samples, density, bv, bh)
    
    if (isrow(bv) & ~iscolumn(bv))
        bv = bv';
    elseif (~iscolumn(bv))
        error('Vertical bounds must be vector');
    end
    
    if (isrow(bh) & ~iscolumn(bh))
        bh = bh';
    elseif( ~iscolumn(bh))
        error('Horizontal bounds must be vector');
    end
    
    density = density/sum(density(:));

    nbr_samples_in_levels = cil_compute_nbr_samples_in_each_level(nbr_samples, ...
                                                              density, ...
                                                              bv, bh);    

    idx = sample_in_levels(nbr_samples_in_levels, bv, bh);    
    idx = sort(idx);

end

% This function performs the actual sampling
%
% INPUT: 
% nbr_samples_in_levels - Number of samples in each level
% bv - Vertical sampling bounds
% bh - Horizontal sampling bounds
%
% OUTPUT:
% idx - linear indices of the samples
function idx = sample_in_levels(nbr_samples_in_levels, bv, bh)  

    bv = [0; bv];
    bh = [0; bh];

    idx = [];

    for k = 1:length(bh)-1
        for l = 1:length(bv)-1
            lbv = bv(l); 
            lbh = bh(k); 
            ubv = bv(l+1);
            ubh = bh(k+1);

            m = ubv - lbv;
            n = ubh - lbh; % m × n
            new_lin_idx = randsample(m*n, nbr_samples_in_levels(l, k));

            [rows, cols] = ind2sub([m, n], new_lin_idx);

            idx1 = sub2ind([bv(end), bh(end)], lbv + rows, lbh + cols);
            idx = [idx; idx1];

        end
    end
    
end


%% Computes the number of samples in each level
%function nbr_samples_in_levels = compute_nbr_samples_in_each_level(nbr_samples, density, bv, bh)
%    rv = length(bv);
%    rh = length(bh);
%
%    a = bv(1:end)- [0; bv(1:end-1)];
%    b = bh(1:end)- [0; bh(1:end-1)];
%    max_level_size = a*b';
%    
%    g = @(c) func_for_bisection_method(c, density, max_level_size, nbr_samples);
%    
%    % Apply the bisection method to find the optimal constant for scaling.
%    a = nbr_samples/2;
%    b = nbr_samples*2;
%    
%    m = (a+b)/2;
%    %g = @(c) f(c, density, max_level_size, nbr_samples);
%    i = 0;
%    while (g(a) > 0)
%        a = a/2;
%    end
%    while(g(b)< 0)
%        b = 2*b;
%    end
%    
%    abserr = (b-a)/2;
%    max_itr = round(log2(b-a)+8);
%    
%    while (i < max_itr & abserr > 1e-12*abs(m))
%    
%        if (g(m) == 0)
%            a = m;
%            b = m;
%        end
%        if (g(a)*g(m) < 0)
%            b = m;
%        else
%            a = m;
%        end
%        i = i + 1;
%        m = (a+b)/2;
%        abserr = (b-a)/2;
%    
%    end
%    
%    nbr_samples_in_levels = round(m*density);
%    leagal_levels = nbr_samples_in_levels <= max_level_size;
%    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
%
%
%
%    curr_nbr_of_samples = sum(nbr_samples_in_levels(:));
%
%
%    if (curr_nbr_of_samples > nbr_samples) % Have to many samples 
%    
%        nbr_of_extra_samples = curr_nbr_of_samples - nbr_samples;
%        [sorted, idx] = sort(leagal_levels(:), 'descend');
%        idx1 = idx(1:nbr_of_extra_samples);
%        nbr_samples_in_levels(idx1) = nbr_samples_in_levels(idx1) - 1; 
%    
%    end
%    
%    if (curr_nbr_of_samples < nbr_samples) % Have too few samples
%        
%        nbr_of_missing_samples = nbr_samples - curr_nbr_of_samples;
%        [sorted, idx] = sort(leagal_levels(:), 'descend');
%        idx1 = idx(1:nbr_of_missing_samples);
%        nbr_samples_in_levels(idx1) = nbr_samples_in_levels(idx1) + 1; 
%    
%    end
%
%end
%
%% Computes the number of samples in each level, and subtracts the 
%% desired number of samples i.e. it is only zero for the perfect constant c.
%function s = func_for_bisection_method(c, density, max_level_size, nbr_samples) 
%
%    nbr_samples_in_levels = round(c*density);
%    leagal_levels = nbr_samples_in_levels <= max_level_size;
%    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
%    s = sum(nbr_samples_in_levels(:)) - nbr_samples;
%
%end



