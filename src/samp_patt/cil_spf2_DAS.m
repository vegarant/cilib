% Computes the DAS sampling pattern 
%
% INPUT
% N - Size of sampling patter N × N
% nbr_samples - Number of samples
% sparsity - vector with local sparsities in each level. The first level is the
%            coarsest scale
% vm - Number of vanishing moments
%
% OUTPUT
% idx - linear indices of the chosen samples
% str_id - String identifyer, describing which type of sampling pattern this is.  
function [idx, str_id] = cil_spf2_DAS(N, nbr_samples, sparsity, vm)
    str_id = 'DAS';

    nres = numel(sparsity);
    r = round(log2(N));
    j0 = r - nres;

    % Compute the boundaries between the sampling levels.
    bv = [];
    for i = 1:nres
        bv =[bv, 2^(j0+i)];
    end
    bh = bv;
    
    % Computes the function M(s, k_1, k_2) 
    density = cil_compute_density_DAS_fourier(N, sparsity, vm);
    density = density./sum(density(:));
    
    nbr_samples_in_levels = cil_compute_nbr_samples_in_each_level(nbr_samples, ...
                                                              density, ...
                                                              bv, bh);    
    idx = sample_in_fourier_levels(nbr_samples_in_levels, N, j0);    
    idx = sort(idx);

end


% Samples in the levels B_(k1,k2)^(2) 
function idx = sample_in_fourier_levels(nbr_samples_in_levels, N, j0)  

    nres = size(nbr_samples_in_levels);
    r = nres + j0;
    c = [(N/2)+1, (N/2)+1];

    idx = [];

    for k = 1:nres % m

        if (k == 1)
            m  = 2^(j0+1);
            cd = 0;
        else
            m  = 2^(j0+k-1);
            cd = 2^(j0+k-2);
        end
        
        for l = 1:nres % n

            if (l == 1)
                n  = 2^(j0+1);
                rd = 0; 
            else
                n = 2^(j0+l-1);
                rd = 2^(j0+l-2);
            end

            % +----------------+
            % |        |       |
            % |    1   |    2  |
            % +----------------+
            % |        |       |
            % |    3   |    4  |
            % +----------------+

            nbr_samples_kl = nbr_samples_in_levels(l, k);
            new_lin_idx = randsample(m*n, nbr_samples_in_levels(l, k));

            [rows, cols] = ind2sub([n, m], new_lin_idx);
            id_r1 = rows <= round(n/2);
            id_c1 = cols <= round(m/2);            

            rows1 = rows(and(id_r1, id_c1)); % 1 <= rows1 <= n/2
            cols1 = cols(and(id_r1, id_c1)); % 1 <= cols1 <= n/2

            rows2 = rows(and(id_r1, ~id_c1)); % 1 <= rows1
            cols2 = cols(and(id_r1, ~id_c1)) - m/2;

            rows3 = rows(and(~id_r1, id_c1)) - n/2;
            cols3 = cols(and(~id_r1, id_c1));

            rows4 = rows(and(~id_r1, ~id_c1)) - n/2;
            cols4 = cols(and(~id_r1, ~id_c1)) - m/2;
            %fprintf('k: %d, l: %d\n', k,l);

            %if (l == 1 && k == 9)
            %    max(rows1(:))
            %    min(rows1(:))
            %end

            idx1 = sub2ind([N, N], N/2+1 - rd - rows1, N/2 + 1 - cd - cols1);
            idx2 = sub2ind([N, N], N/2+1 - rd - rows2, N/2 - 0 + cd + cols2);
            idx3 = sub2ind([N, N], N/2-0 + rd + rows3, N/2 + 1 - cd - cols3);
            idx4 = sub2ind([N, N], N/2-0 + rd + rows4, N/2 - 0 + cd + cols4);
            idx = [idx; idx1; idx2; idx3; idx4];

        end
    end

end


