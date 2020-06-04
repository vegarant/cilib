

function [idx, str_id] = cil_sph2_DAS_randy(N, nbr_samples, sValues)
    str_id = 'DAS_randy';
 
    nres = size(sValues, 1);
    r = round(log2(N));
    j0 = r - nres;
    M = samples_DAS_walsh(sValues, nbr_samples, j0);
    idx = sampling_matrix_DAS_walsh(M, j0);

end


function M = samples_DAS_walsh(sValues, nbr_samples, j0)
    %% Calculate how many samples to put in each dyadic rectangle.
    
    r = size(sValues, 1);
    n = round(sqrt(size(sValues, 2)));
    dyadicLengths = 2.^[j0+1, j0+1:j0+r-1];
    W = dyadicLengths.*dyadicLengths';
    
    %% Find the largest value of s that gives at most m samples, by bisection.
    upperBound = n^2;
    lowerBound = 1;
    
    f_lower = zeros(r, r);
    f_upper = W;
    
    sIndex = round((n^2+1)/2);
    
    for t = 1:2*log2(n) + 2
        s = sValues(:, sIndex);
        M = zeros(r, r);
        
        % Calculate script M
        for k1 = 1:r
            for k2 = k1:r
                for l=1:r
                    M(k1, k2) = M(k1, k2) + s(l)*2^(-abs(k1-l)-abs(k2-l));
                end
                              
                M(k2, k1) = M(k1, k2);
            end
        end
        
        I = eye(r);
        delta_k1 = I(:, 1);
        delta_k2 = I(1, :);
        
        f = min(W, 2.^(delta_k1 + delta_k2).*M);
            
        if sum(sum(f)) <= nbr_samples
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
    m_lower = sum(sum(f_lower));
    m_upper = sum(sum(f_upper));
    
    if m_lower ~= m_upper
        f = ((m_upper - nbr_samples)*f_lower + (nbr_samples - m_lower)*f_upper)/(m_upper - m_lower);
    else
        f = f_lower;
    end
    
    %% Round up enough entries to keep sum(f_{k1, k2}) = m
    f_frac = f - floor(f);
    m_frac = round(sum(sum(f_frac)));
    
    f_frac = reshape(f_frac, [r^2, 1]);
    [~, maxFracIndices] = sort(f_frac, 'desc');
    roundUpIndices = maxFracIndices(1:m_frac);
    
    M = floor(f);
    M(roundUpIndices) = M(roundUpIndices) + 1;
end


function idx = sampling_matrix_DAS_walsh(M, j0)
    % M(k1, k2) samples are chosen uniformly from the dyadic rectangle W_{k1, k2}.
    % Returns the sampling matrix and the indices of the chosen samples.
    
    r = size(M, 1);
    n = round(2^(j0+r));
    R = zeros(n, n);
    
    yStart = 0;
    for k1 = 1:r
        yEnd = 2^(j0+k1);
        yEnd = round(yEnd)-1;
        
        xStart = 0;
        for k2 = 1:r
            xEnd = 2^(j0+k2);
            xEnd = round(xEnd);
            
            % define W_{k1, k2} in the fourth quadrant
            Q = zeros(2*n,2*n);
            box = ones(yEnd-yStart+1, xEnd-xStart+1); 
            Q((n-yStart):-1:(n-yEnd), n+xStart:n+xEnd) = box; 
    
            % mirror to other quandrants
            Q = Q(1:n, n+1:2*n);
            
            % take samples
            samplingRegion = find(Q >= 1);
            
            sampleCount = min(M(k1, k2), size(samplingRegion, 1));
            selectedSamples = randsample(samplingRegion, sampleCount);
            R(selectedSamples) = 1;
        
            xStart = xEnd+1;
        end
        
        yStart = yEnd+1;
    end
    
    % Pattern originally constructed in the wrong orientation 
    % IMPROVE: Change code to construct correctly, remove hack.
    R = imrotate(R, 270);
    idx = find(R == 1);

end


