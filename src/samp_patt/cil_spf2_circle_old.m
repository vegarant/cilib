% cil_spf2_circle creates a sampling pattern consisting of  circles. Each
% circle should have approximately the same number of samples. The vector `b`
% defines the radius of each circle. If the `include_border` is true, samples
% outside the outer circle will be included as an extra layer. `full_levels`
% defines how many of the first levels which should be fully sampled. 
% 
% INPUT:
% N              - Image size i.e. N × N
% M              - Number of samples.
% b              - Boundary between the different sampling layers.
% full_levels    - Number of fully sampled levels (Optional. Default: 0).
% include_border - Boolean (optional). If the outer circle should be included 
%                  (Default: 0) 
%
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
%
% NOTE: This function is rather old, and it's syntax may not correspond to the 
%       syntax found in the other files. 
function [idx, str_id] = cil_spf2_circle(N, M, b, full_levels, include_border)
    str_id = 'circle';
    
    if (nargin < 4) 
        full_levels = 0;
        include_border = 0;
    end
     
    if (nargin < 5)
        include_border = 0;
    end 
    
    sy = N/2;          % Center of circle vertically 
    sx = N/2;          % Center of circle horizontally 
    n = length(b);     % Number of bins 
    s = 1;             % Number of samples obtained so far
    pos = zeros(M,2);  % Samples
    k = 1;             % Current circle level
    
    if (full_levels & pi*b(full_levels)^2 > M) 
        disp('Error: full_levels requier more that total amount of samples');
        return;
    end
    
    
    Y = zeros([N,N], 'uint8'); 
    k = 1;
    if (full_levels)
         
        r1 = 0;
        r2 = b(full_levels);
         
        l = round((sqrt(2)/2)*r1);
        r1sq = floor(r1^2);
        r2sq = ceil(r2^2);
         
        for x = l:r2
            for y = l:r2
                 
                if ((x^2 + y^2) >= r1sq && (x^2 + y^2 <= r2sq) ) 
                    
                    i = sy + y; j = sx + x;
                    if (Y(i,j) == 0)
                        pos(s,:) = [i, j];
                        s = s + 1;
                        Y(i,j) = 1;
                    end
                    
                    i = sy + y; j = sx - x;
                    if (Y(i,j) == 0)
                        pos(s,:) = [i, j];
                        s = s + 1;
                        Y(i,j) = 1;
                    end
                    
                    i = sy - y; j = sx + x;
                    if (Y(i,j) == 0)
                        pos(s,:) = [i, j];
                        s = s + 1;
                        Y(i,j) = 1;
                    end

                    i = sy - y; j = sx - x;
                    if (Y(i,j) == 0)
                        pos(s,:) = [i, j];
                        s = s + 1;
                        Y(i,j) = 1;
                    end

                end
            end
        end
        k = k + full_levels;
    end

    if include_border
        l = n-k+2;
        bins = round(((M-s)/l)*ones(l,1)) - 1; 
        bins(end) = bins(end)/5;
    else 
        l = n-k+1;
        bins = round(((M-s)/l)*ones(l,1)) - 1; 
    end



    % Find number of samples within each level
    cnt = 0;
    while (s + sum(bins) <= M)  
        idx = 1 + mod(cnt,l);
        bins(idx) = bins(idx) + 1;
        cnt = cnt + 1;
    end 

    k1 = k;
    while(k <= n)    

        level = k - k1+1; 

        if (k == 1)
            r1 = 0;
            r2 = b(k);
        else 
            r1 = b(k-1);
            r2 = b(k);
        end 

        s_begin = s;
        failed = 1;
        while(s < s_begin + bins(level)); 
            r = r1 + (r2-r1)*rand(1)-1;
            theta = 2*pi*rand(1); 

            x = round(r*cos(theta));
            y = round(r*sin(theta));
            if (failed > 100)
                failed = 1;
                 
                bins(level) = bins(level) - 1;
                bins(level+1) = bins(level+1) + 1;
            end
            if (Y(sy + y,sx + x) == 0)
                pos(s,:) = [sy+y, sx+x];
                s = s + 1;
                Y(sy + y,sx + x) = 1;
                failed = 1;
                %fprintf('s: %d, k: %d\n', s, k);
            else 
                failed = failed + 1;
            end

        end
        k = k + 1;
    end

    if include_border
        r1 = b(end);
        r2 = sqrt(N^2 + N^2);
         
        while(s <= M)
            r = r1 + (r2-r1)*rand(1);
            theta = 2*pi*rand(1); 
             
            x = round(r*cos(theta));
            y = round(r*sin(theta));
            if (abs(y) < N/2 && abs(x) < N/2)
                if (Y(sy + y,sx + x) == 0)
                    pos(s,:) = [sy+y, sx+x];
                    s = s + 1;
                    Y(sy + y,sx + x) = 1;
                end
            end
        end 
    end
    idx = sub2ind([N, N], pos(:,1), pos(:,2));
end 

