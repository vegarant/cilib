% Sample horizontal lines according to a power law distribution.
%
% We assume N is an even integer.
%
% For w ∈ (-N/2+1, ..., N/2) the horizontal lines are chosen according to a
% distribution
%
% P(w) = C / max(1, |w|)^alpha,         C > 0 is a normalizing constant.
%
% To ensure that we allways sample the center frequencies the lies N/2-1, N/2
% and N/2+1 are always chosen. 
%
% INPUT
% N - Even integer, specifying the size of the N×N sampling pattern
% nbr_samples - Approximately the number of samples desired. Choosing an
%               integer number of lines are prioritized over the correct number
%               of samples.
% alpha - decay of the power law distribution 
function [idx, str_id] = cil_spf2_power_law_2d_hlines(N, nbr_samples, alpha)
    str_id = sprintf('fpower_law_2d_hlines_%g', alpha);
    
    valid_sample_lines = [1:N/2-2 , N/2+2:N];
    prob = abs(valid_sample_lines - N/2);
    prob = 1./prob.^alpha;
    prob = prob/(sum(prob(:)));

    nbr_lines = round(nbr_samples/N);
    
    valid_sample_lines = [1:N/2-2 , N/2+2:N];
    idx_v = datasample(valid_sample_lines, nbr_lines-3,'Replace', false, 'Weights', prob);
    idx_v = sort([idx_v, N/2-1, N/2, N/2+1]);

    idx_v_check = unique(idx_v);

    if (length(idx_v_check) ~= length(idx_v))
        fprintf('Error: Not the correct number of samples. cil_spf2_power_law_2d_hlines\n')
    end

    Z = zeros([N,N], 'logical');
    Z(idx_v, :) = logical(1);
    idx = find(Z);

end
