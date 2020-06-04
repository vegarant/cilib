%
% Creates the sampling levels 
%             [2^J0, 2^(J0+1), ..., 2^(J0 + R), 2^(J0+R+q)]
% where R = floor(log2(M)). The first 2^J0 samples are fully sampled 
% Then the number of remaining samples are divided equally between the other
% sampling levels, but the number of samples in the last level will be scaled
% with 2^q where q = floor(log2(N))-R.
%
% INPUT
% N            - Sampling bandwidth
% M            - Sparsity bandwidth
% nbr_samples  - Number of samples
% J0           - 2^J0 of the first samples will be fully sampled. In the case
%                of wavelet recovery, J0 corresponds to the minimum wavelet 
%                decomposition level. 
%
% OUTPUT:
% idx    - indices in the range 1:N, with the chosen samples.
% scales - Each level is scales like sqrt(size_of_level/number_of_samples).
%          scales is a vector, where scales(k) corresponds to the scale  
%          required by idx(k). 
%
function [idx, scales] = sph1_rect2(N, M, nbr_samples, J0)

    eps = 1e-13;
    R = floor(log2(M)+eps);
    q = floor(log2(N)+eps) - R;
    r = R+2-J0;

    bin_sizes_reversed = [N - 2^(R)];

    k = R-1;
    while(k > J0)
        bin_sizes_reversed = [bin_sizes_reversed, 2^k];
        k = k - 1;
    end

    bin_sizes_reversed = [bin_sizes_reversed, 2^J0, 2^J0];


    a = floor((nbr_samples-2^J0)/(r));
    bin_samples_reversed = ones(1,r)*a;
    bin_samples_reversed(1) = a;
    bin_samples_reversed(end) = 2^J0;

    k = 1;
    for i = 1:r-1
        if(bin_samples_reversed(i) > bin_sizes_reversed(i))
            bin_samples_reversed(i) = bin_sizes_reversed(i);
        end
    end

    s = sum(bin_samples_reversed);

    i = r-1;
    while (s < nbr_samples)
        if (bin_samples_reversed(i) < bin_sizes_reversed(i))
            bin_samples_reversed(i) = bin_samples_reversed(i) + 1;
            s = s + 1;
        end

        if (i > 1)
            i = i - 1;
        else
            i = r-1;
        end
    end

    % The size and number of samples in each level is choosen 
    bin_sizes = flip(bin_sizes_reversed);
    bin_samples = flip(bin_samples_reversed);
    
    %bin_sizes
    %bin_samples
    
    % Compute scaling factors
    sk = sqrt(bin_sizes./bin_samples);
    scales = ones(nbr_samples,1);
    s = 1;
    for i = 1:r
        scales(s:s+bin_samples(i)-1) = sk(i);
        s = s + bin_samples(i);
    end

    idx = linspace(1,2^J0, 2^J0);
    s = 2.^([J0,J0+(1:R-J0), r+q]);
    for i = 2:r
        a = sort(randperm(bin_sizes(i), bin_samples(i)));
        idx = [idx , s(i-1) + a];
    end


end






