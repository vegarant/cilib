
function [idx, str_id] = cil_sph2_DIS(N, nbr_samples, sValues)
    str_id = 'DIS';
 
    nres = size(sValues, 1);
    r = round(log2(N));
    j0 = r - nres;
    M = samples_DIS_walsh(N, sValues, nbr_samples);
    idx = sampling_matrix_DIS_walsh(M, j0);

end


function M = samples_DIS_walsh(n, sValues, nbr_samples)
    %% Calculate how many samples to put in each dyadic rectangle.
    j0 = log2(n) - size(sValues, 1);
    W_base = 2.^(2*[j0+11, j0+1:log2(n)-1]');
    I = eye(log2(n)-j0);

    W = W_base*3-2*I(:,1).*W_base;    

    sValues = min(sValues, W);
    sIndex = find(sum(sValues) > nbr_samples, 1) - 1;
    M = sValues(:, sIndex);
    M_frac = M - floor(M);
    m_frac = round(sum(sum(M_frac)));
    
    [~, maxFracIndices] = sort(M_frac, 'desc');
    roundUpIndices = maxFracIndices(1:m_frac);
    
    M = floor(M);
    M(roundUpIndices) = M(roundUpIndices) + 1;
end


function idx = sampling_matrix_DIS_walsh(M, j0)
    %Generates an n-by-n sampling, where n=2^(j0+r).
    %Samples are chosen from the the wavelet regions as weighted by M.
    
    r = size(M, 1);
    n = round(2^(j0+r));
    R = zeros(n,n);
    
    start = 0;
    
    for k = 1:r
        finish = 2^(j0+k);
        finish = round(finish);
        Q = zeros(2*n,2*n);
        %define W_{k, t} in the fourth quadrant
        Q(n+start:n+finish, n+1:n+start-1) = 1; 
        Q(n+1:n+start-1, n+start:n+finish) = 1; 
        Q(n+start:n+finish, n+start:n+finish) = 1; 
    
        Q = flipud(Q);
        Q = Q(1:n, n+1:2*n);
        
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
    
    % Pattern originally constructed in the wrong orientation 
    % TODO: Change code to construct correctly, remove hack.
    R = imrotate(R, 270);
    idx = find(R == 1);
    
end





