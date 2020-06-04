% Creates a multi-level sampling pattern with center frequency [N/2-1,N/2-1], 
% and a p_norm-ball as the the sampling level shape. 
% 
% INPUT
% N           - Size of image is N x N
% nbr_samples - Number of samples
% 0 < m < 1   - Faction of N we would like to fully sample.
% nbr_levels  - Number of sampling levels
% p_norm      - (sum |x|^p)^(1/p) where p = p_norm.
% 
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
% 
% Vegard Antun, 2017.
function [idx, str_id] = cil_spf2_exp(N, nbr_samples, m, nbr_levels, p_norm)
    str_id = sprintf('f_exp%d', p_norm);
    
    r = 1;     % Radius
    c = [N/2-1,N/2-1]; % Center frequency

    sh_ball = cil_shape_ball(c, r, p_norm);
    idx = cil_sp2_exp(N, nbr_samples, sh_ball, m, nbr_levels);

end
