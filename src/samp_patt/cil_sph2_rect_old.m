% IMPROVE Need documentation
%
% cil_sph2_rect creates a rectangular sampling pattern for an image of size N = 2^R
%  +-----------------------------------+
%  |  |    |        |                  |
%  |--+    |        |                  |
%  |       |        |                  |
%  |-------+        |                  |
%  |                |                  |
%  |                |                  | 
%  |                |                  | 
%  |----------------+                  |   
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  +-----------------------------------+
% where the boundaries between the different sampling patters equals to 2^(0:R)
% This function will distribute the samples uniformly in a one dimensional
% vector `m` whose `sum(3*m.^2) == nbr_samples`. In cases where the number of samples nbr_samples
% can not be written in this form, the necessary number of samples is added to
% `scheme`, to ensure `sum(scheme) == nbr_samples`.   
%
function [idx, scales] = cil_sph2_rect(N, nbr_samples)
    
    scheme = rect_samp_scheme(N, nbr_samples);
    pos = 0;
    
    nu = max(size(scheme));
    b = 2.^(0:nu);
    pos = zeros(nbr_samples,2);
    
    Y = zeros([N,N], 'uint8');
    if (scheme(1) == 4)
        pos(1,:) = [1,1]; Y(1,1) = 1;
        pos(2,:) = [1,2]; Y(1,2) = 1;
        pos(3,:) = [2,1]; Y(2,1) = 1;
        pos(4,:) = [2,2]; Y(2,2) = 1;
    else
        disp('First scheme element must be 4');
    end
    
    s = 5;
    k = 2;

    while ( (b(k+1)^2 - b(k)^2) == scheme(k) )

        l = b(k);
        h = b(k+1);

        for i = l+1:h
            for j = 1:h
                pos(s,:) = [i,j];
                Y(i,j) = 1;
                s = s + 1;
            end
            for j = 1:l
                pos(s,:) = [j,i];
                Y(j,i) = 1;
                s = s + 1;
            end
        end

        k = k + 1;
    end

    while( k <= nu)

        l = b(k);
        h = b(k+1);
        
        t = 1;
        while(t <= scheme(k))

            elem = round((h-1)*rand(1,2)+1);

            while( max(elem) <= l || Y(elem(1), elem(2)) == 1)
                elem = round((h-1)*rand(1,2)+1);
            end

            if (Y(elem(1), elem(2)) == 0)
                pos(s,:) = elem;
                Y(elem(1), elem(2)) = 1;
                s = s + 1;
                t = t + 1;
            end

        end
        k = k + 1;
    end

    idx = sub2ind([N, N], pos(:,1), pos(:,2));
    
    scales = sch2_rect(N, scheme);

end

function Y = sch2_rect(N, scheme)

    n = length(scheme);
     
    Y = zeros(N,N);
     
    for i = n:-1:2
        level_size = 3*((N/2^(n-i+1))*(N/2^(n-i+1)));
        Y(1:round(N/2^(n-i)), 1:round(N/2^(n-i))) = sqrt(level_size/scheme(i));
    end 
    Y(1:2, 1:2) = 1;
     
    Y = reshape(Y, [N*N, 1]); 
     
end

% This is a support function for `cil_sph2_rect` and `sch2_rect`.
% It computes how one should distribute the nbr_samples samples in each level in an N×N
% array where each level is a square where each side is twice as large as the 
% previous. 
% 
% INPUT:
% N - Size of N × N array, assumes N = 2^R
% nbr_samples - Number of samples
% 
% OUTPUT:
% scheme - Number of samples in each level. 
%
function scheme = rect_samp_scheme(N, nbr_samples)
    
    % test that size is a power of 2
    nu = round(log2(N));
    
    if (2^nu ~= N)
        error('cilib:value_error', 'Image size must be power of 2');
    end 
    m = ones(nu,1); 
    i=2;
    while(sum(m.^2) <= nbr_samples/3) 
        m(i:nu) = m(i:nu) + 2^(i-1) - 2^(i-2);
        i = i + 1;
    end 
    i = i - 1;
    m(i:nu) = 2^(i-2);
    
    while(sum(3*m.^2) <= nbr_samples)
        m(i:nu) = m(i:nu) + 1; 
    end
    m(i:nu) = m(i:nu) - 1;
    m = 3*m.^2;
    m(1) = 4;
    
    k = 0;
    while(sum(m) < nbr_samples)
         s = i + mod(k,nu-i+1);
         m(s) = m(s) + 1;
         k = k + 1;
    end

    scheme = m;
end


