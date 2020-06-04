function [idx, str_id] = cil_spf2_DIS(N, nbr_samples, sValues, vm)
    str_id = 'DIS_randy';
 
    nres = size(sValues, 1);
    r = round(log2(N));
    j0 = r - nres;
    M = samples_DIS(sValues, nbr_samples, j0, vm);
    idx = sampling_matrix_DIS(M, j0);

end

function M = samples_DIS(sValues, nbr_samples, j0, vm)
    %% Calculate how many samples to put in each dyadic rectangle.

    qValues = [0, 0.339, 0.636, 0.913, 1.177, 1.432, 1.682, 1.927, 2.168, 2.406];
    
    p = vm;
    q = qValues(vm);
    
    r = size(sValues, 1);
    n = round(sqrt(size(sValues, 2)));
    
    dyadicLengths = 2.^[j0+1, j0+1:j0+r-1];
    W = dyadicLengths.*dyadicLengths';
    
    lengths = j0 + (0:r-1)';
    W = 4.^lengths;
    W(1) = 4 * W(1);
    W(2:end) = 3 * W(2:end);
    
    %% Find the largest value of s that gives at most m samples, by bisection.
    upperBound = n^2;
    lowerBound = 1;
    
    f_lower = zeros(r, 1);
    f_upper = W;
    
    sIndex = round((n^2+1)/2);
    
    for t = 1:2*log2(n) + 2
        s = sValues(:, sIndex);
        M = zeros(r, 1);
        
        % Calculate script M
        for k = 1:r
            for l=1:k
                M(k) = M(k) + s(l)*2^(-2*q*(k-l));
            end

            for l=k+1:r
                M(k) = M(k) + s(l)*2^(-2*(p+1)*(l-k));
            end
            
            if k == 1
                M(k) = 4 * M(k);
            end
        end
        
        f = min(W, M);
            
        if sum(f) <= nbr_samples
            f_lower = f;
            lowerBound = sIndex;
            sIndex = ceil((sIndex + upperBound)/2);
        end
  
        if sum(sum(f)) >= nbr_samples
            f_upper = f;
            upperBound = sIndex;
            sIndex = floor((sIndex + lowerBound)/2);
        end
    end
    
    %% Interpolate to set sum(f_{k1, k2}) exactly equal to m
    m_lower = sum(f_lower);
    m_upper = sum(f_upper);
    
    if m_lower ~= m_upper
        f = ((m_upper - nbr_samples)*f_lower + (nbr_samples - m_lower)*f_upper)/(m_upper - m_lower);
    else
        f = f_lower;
    end
    
    %% Round up enough entries to keep sum(f_{k1, k2}) = m
    f_frac = f - floor(f);
    m_frac = round(sum(f_frac));
    
    [~, maxFracIndices] = sort(f_frac, 'desc');
    roundUpIndices = maxFracIndices(1:m_frac);
    
    M = floor(f);
    M(roundUpIndices) = M(roundUpIndices) + 1;
end


function idx = sampling_matrix_DIS(M, j0)
    %Generates an n-by-n sampling, where n=2^(j0+r).
    %Samples are chosen from the the wavelet regions as weighted by M.
    
    r = size(M, 1);
    n = round(2^(j0+r));
    R = zeros(n,n);
    
    x = (1:n) - n/2 + 1/2;
    y = x';
    
    start = 0;
    
    for k = 1:r
        finish = 2^(j0+k-1);
        finish = round(finish);
        Q = zeros(n,n);
        %define W_{k, t} in the fourth quadrant
        Q(n/2+start:n/2+finish, n/2+1:n/2+start-1) = 1; 
        Q(n/2+1:n/2+start-1, n/2+start:n/2+finish) = 1; 
        Q(n/2+start:n/2+finish, n/2+start:n/2+finish) = 1; 
    
        %mirror to other quandrants
        Q = Q+fliplr(Q);
        Q = Q+flipud(Q);
        
    %     t = max(abs(x), abs(y));
    %     T = zeros(n, n);
    %     T((t >= start) & (t <= finish)) = 1;
    
        %take samples
        samplingRegion = find(Q >= 1);
        sampleCount = min(M(k), length(samplingRegion));
        randomEntries = randsample(samplingRegion, sampleCount);
        R(randomEntries) = 1;
        
        start = finish+1;
    end
    
    idx = find(R == 1);

end

