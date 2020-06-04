% cil_spf2_map creates a two-dimensionala sampling pattern centered (N/2, N/2)
% with the same form as the map f[0,1] -> [0,1]. 2M samples are drawn from a
% uniform distribution on [0,1]. These samples are then transformed into
% two-dimensional indices by the map `N/2 + 1 r*(N-2)f(x)/2` where r ∈ {+1,-1} is
% a number drawn at random. 
% 
% INPUT
% N - Image size i.e. N × N
% M - Number of samples
% f - Function f:[0,1] -> [0,1] which describe the form of the samplin pattern
% 
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
%
% Example:
% ```
% N = 2^8; M = (N^2)/8;
% f = @(x) 1 - x.^(0.33);
% s = cil_spf2_map(N, M, f);
% X = zeros([N,N], 'uint8');
% X(s) = 1;
% imagesc(X);
% colormap('gray');
% colorbar();
% ``` 
%    
% SEE ALSO   
% cil_spf2_pdf
%    
function [idx, str_id] = cil_spf2_map(N,M, f)
    str_id = 'map';
    Y = zeros([N,N], 'uint8');
    c = floor(N/2)+1;

    s = M;
    k = 1;
    pos = zeros(M, 2);
    while (s > 0)

        r1 = 2*binornd(1, 0.5, [s,1])-1;
        r2 = 2*binornd(1, 0.5, [s,1])-1;
        x1 = rand([s,1]);
        x2 = rand([s,1]);

        h = c + r1.*round( (N - 2)*(f(x1))/2 );
        v = c + r2.*round( (N - 2)*(f(x2))/2 );
        
        for i=1:s
            if ( Y(h(i), v(i)) == 0 )
                pos(k,:) = [h(i), v(i)]; 
                Y(h(i), v(i)) = 1;
                k = k + 1;
            end
        end
        s = M - sum(Y(:));

    end
    
    idx = sub2ind([N, N], pos(:,1), pos(:,2));

end
    
