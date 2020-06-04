% cil_spf2_square sample in a square formation from the center of the image.
% The size of the image is assumed to be N × N. The size of each of the 
% sampled squares are given by its radius from the center of the image. The 
% vector b contain the radius of each square. The first square will
% be fully sampled. Next each of the remaining squares will receive an equal 
% amount of the remaining samples. If a square is not large enough to contain
% all of its samples, the spare samples will be divided among the other 
% squares. For square i, each of the samples are drawn uniformly at random 
% among all indices, which do not intersect square i-1.
%
% INPUT
% N - Image size i.e. N × N
% M - Number of samples
% b - Radius of each of the sampled squares
%
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
%
function [idx, str_id] = cil_spf2_square(N, M, b)
    str_id = 'square';
    c = floor(N/2);              % Center pixel in matrix
    n = length(b);               % Number of bins 
    pos = zeros([M,2]);          % Samples
    Y   = zeros([N,N], 'uint8'); % Bookkeeping matrix
    s = 0;                       % Number of samples obtained so far
    
    % Fully sample the first layer
    for i = (c-b(1)+1:c+b(1))
        for j = (c-b(1)+1:c+b(1))
            Y(i,j) = 1;
            s = s + 1;
            pos(s,:) = [i, j]; 
        end
    end 
    
    number_of_samples_in_bin = @(b1, b2) 4*(b1^2 - b2^2);

    % Calculate the number of samples in the next layers
    sampl = zeros([n-1,1])+floor((M-s)/n);
    sampl_full = zeros([n-1, 1]);
     
    % If some of the bins are full, we need to move samples to other bins 
    for l = 2:n
        k = 0;
        
        while (number_of_samples_in_bin(b(l), b(l-1)) < sampl(l-1))
            sampl(l-1) = sampl(l-1) - 1;
            sampl(l+k) = sampl(l+k) + 1;
            k = mod(k+1, n-l);
            sampl_full(l-1) = 1;
        end 
    end    
    
    % Fill the last bins
    % This construction ain't pretty, but it works. The loop will typically 
    % only run a few times.
    
    k = 1;
    while (sum(sampl) < (M-s)) 
        
        if (sampl_full(k) ~= 1)
            sampl(k) = sampl(k) + 1;
        end
        
        k = mod(k+1, n);
        if (k==0)
            k = k + 1;
        end
    end
    
    % Finally the number of samples in each bin have been decided
    % Sample all full bins
    
    for l = 2:n
        if (sampl_full(l-1) == 1) 
            for i = c+b(l-1)+1:c+b(l)
                for j = c-b(l)+1:c+b(l) 
                    Y(i,j) = 1;
                    s = s + 1;
                    pos(s,:) = [i, j]; 
                end
            end
            for i = c-b(l)+1:c-b(l-1)
                for j = c-b(l)+1:c+b(l) 
                    Y(i,j) = 1;
                    s = s + 1;
                    pos(s,:) = [i, j]; 
                end
            end
            for i = c-b(l-1)+1:c+b(l-1)
                for j = c-b(l)+1:c-b(l-1)
                    Y(i,j) = 1;
                    s = s + 1;
                    pos(s,:) = [i, j]; 
                end
                for j = c+b(l-1)+1:c+b(l)
                    Y(i,j) = 1;
                    s = s + 1;
                    pos(s,:) = [i, j]; 
                end
            end
        end
    end
    
    
    for l = 2:n
        
        displacement = round((N-2*b(l))/2) + 1;
        if (sampl_full(l-1) == 0)
            k = 0;
            
            while (k < sampl(l-1))
                k = k + 1;
                
                % Any sample between c-b(l)+1 and c+b(l) is valid
                si = round((2*b(l)-1)*rand(1)) + displacement;
                sj = round((2*b(l)-1)*rand(1)) + displacement;
                
                % Test that it is a valid sample
                failed = 0;
                while ( ( c-b(l-1) < si && si <= c+b(l-1) ...
                          && c-b(l-1) < sj && sj <= c+b(l-1) ) ...
                        || Y(si,sj) == 1)
                    failed = failed + 1;
                    si = round((2*b(l)-1)*rand(1)) + displacement;
                    sj = round((2*b(l)-1)*rand(1)) + displacement;
                    
                    if (mod(failed, 100) == 0)
                        sampl(l-1) = sampl(l-1) - 1;
                        sampl(l) = sampl(l) + 1;
                    end
                end 
                
                % Insert the new sample
                Y(si,sj) = 1;
                s = s + 1;
                pos(s,:) = [si, sj]; 
            end
        end
    end
    idx = sub2ind([N, N], pos(:,1), pos(:,2));
end


