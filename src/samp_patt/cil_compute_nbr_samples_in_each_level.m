% Computes the number of samples in each level
function nbr_samples_in_levels = cil_compute_nbr_samples_in_each_level(nbr_samples, density, bv, bh)
    
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
    
    rv = length(bv);
    rh = length(bh);

    a = bv(1:end)- [0; bv(1:end-1)];
    b = bh(1:end)- [0; bh(1:end-1)];
    max_level_size = a*b';
    
    g = @(c) func_for_bisection_method(c, density, max_level_size, nbr_samples);

    % Apply the bisection method to find the optimal constant for scaling.
    xl = nbr_samples/32;
    xh = nbr_samples*32;
    m = cil_bisection(g, xl, xh); 

    nbr_samples_in_levels = round(m*density);
    leagal_levels = nbr_samples_in_levels <= max_level_size;
    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);



    curr_nbr_of_samples = sum(nbr_samples_in_levels(:));


    if (curr_nbr_of_samples > nbr_samples) % Have to many samples 
    
        nbr_of_extra_samples = curr_nbr_of_samples - nbr_samples;
        [sorted, idx] = sort(leagal_levels(:), 'descend');
        idx1 = idx(1:nbr_of_extra_samples);
        nbr_samples_in_levels(idx1) = nbr_samples_in_levels(idx1) - 1; 
    
    end
    
    if (curr_nbr_of_samples < nbr_samples) % Have too few samples
        
        nbr_of_missing_samples = nbr_samples - curr_nbr_of_samples;
        [sorted, idx] = sort(leagal_levels(:), 'descend');
        idx1 = idx(1:nbr_of_missing_samples);
        nbr_samples_in_levels(idx1) = nbr_samples_in_levels(idx1) + 1; 
    
    end

end

% Computes the number of samples in each level, and subtracts the 
% desired number of samples i.e. it is only zero for the perfect constant c.
function s = func_for_bisection_method(c, density, max_level_size, nbr_samples) 

    nbr_samples_in_levels = round(c*density);
    leagal_levels = nbr_samples_in_levels <= max_level_size;
    nbr_samples_in_levels(~leagal_levels) = max_level_size(~leagal_levels);
    s = sum(nbr_samples_in_levels(:)) - nbr_samples;

end

