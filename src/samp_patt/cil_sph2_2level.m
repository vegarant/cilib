% Computes a two level sampling pattern where the first level is fully sampled 
% and the secound levle is subsampled. 
% 
% INPUT
% N           - Size of the N × N sampling pattern
% nbr_samples - Number of samples
% p_norm      - The shape of the first level will be a the unit l_p ball.
%               Currently only p_norm = inf is supported
% r_factor    - The algorithm will stive to include nbr_samples/f_factor 
%               samples in the first level. 
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
% 
% Vegard Antun, 2019.
function [idx, str_id] = cil_sph2_2level(N, nbr_samples, p_norm, r_factor)
    if nargin < 3
        p_norm = inf;
    end

    half_nbr_samples = round(nbr_samples/r_factor);
    if (p_norm == inf)
        r = round(sqrt(half_nbr_samples));
        Z = zeros([N,N], 'uint8');
        Z(1:r, 1:r) = uint8(1);
        str_id = '2level_l_inf';    
    elseif p_norm == 2
        r_init = sqrt(4*half_nbr_samples/pi);
        shapef = cil_shape_ball([0, 0], r_init, p_norm); 
        Z = uint8(cil_shape(shapef, N, 1));
        str_id = '2level_l_2';    
    elseif p_norm == 1
        r_init = sqrt(half_nbr_samples);
        shapef = cil_shape_ball([0, 0], r_init, p_norm); 
        Z = uint8(cil_shape(shapef, N, 1));
        str_id = '2level_l_1';    
    else
        error('norm not implemented');
    end
    
    current_nbr_samples = sum(Z(:));
    
    a = nbr_samples-current_nbr_samples;
    s = 0;
    while  s < a
        i = round(1 + (N-1)*rand(1));
        j = round(1 + (N-1)*rand(1));
        if (~Z(i,j))
            s = s + 1;
            Z(i,j) = uint8(1);
        end
    end
    idx = find(Z);
end


