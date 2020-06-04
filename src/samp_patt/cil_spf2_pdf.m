% cil_spf2_pdf sample from the probability distribution specified by the
% function handle `pdf`. It is assumed that supp(pdf) ⊂ [0,1]. We sample 2M
% samples from the `pdf`-distribution. For each sample 's' we then apply the
% transform `N/2 + r*(N/2)*s` where `r` ∈ {+1,-1} is a random number drawn with
% equal probability. M of these samples are used as the x-coordinate, and M
% samples are used as the y-coordinate.  
% 
% This function can be slow for large amount of samples. For a faster method see
% `cil_spf2_map.m`.
%
% INPUT
% N   - Image size i.e. N × N
% M   - Number of samples
% pdf - pdf of a probability distribution supported on [0,1]. The `pdf` need
%       not be normalized.  
% 
% OUTPUT
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N. The samples from the `pdf` close to 0 will be close to the
%         image center, while the samples close to 1 will found along the boarder of
%         the image
% str_id - String identifyer, describing which type of sampling pattern this is.  
% Example:
% ```
% N = 2^8; M = (N^2)/8;
% pdf = @(x) (0 <= x).*(1-x).*(x <= 1);
% s = cil_spf2_pdf(N, M, pdf);
% X = zeros([N,N], 'uint8');
% X(s) = 1;
% imagesc(X);
% colormap('gray');
% colorbar();
% ``` 
%
% SEE ALSO   
% cil_spf2_map
function [idx, str_id] = cil_spf2_pdf(N, M, pdf)
    str_id = 'pdf';
    X = zeros([N,N]);
    c = floor(N/2);
    
    q = integral(pdf, 0, 1);
    q_tail = integral(pdf, 0.6, 1);
    
    proprnd = @(x) rand(1,1);
    %if (q_tail/q < 0.11)
    %    proprnd = @(x) rand(1,1);
    %else
    %    fprintf('Using beta distribution\n');
    %    proprnd = @(x) betarnd(1, 2.5);
    %end
     
    proppdf = @(x,y) (0 <= x).*(x <= 1);
    
    s = M;
    while (s > 0)
        samp1 = mhsample(0.5, s,'pdf',pdf, 'proppdf', proppdf, 'proprnd', proprnd);
        samp2 = mhsample(0.5, s,'pdf',pdf, 'proppdf', proppdf, 'proprnd', proprnd);
        r1 = 2*binornd(1, 0.5, [s,1])-1;
        r2 = 2*binornd(1, 0.5, [s,1])-1;
        
        h = c + r1.*round( N*samp1/2 );
        v = c + r2.*round( N*samp2/2 );
        
        if (s == M) 
            h1 = h; 
            v1 = v;
        else  
            h1 = [h1; h];
            v1 = [v1; v];
        end
        
        sampl = sub2ind([N, N], h, v);
            
        X(sampl) = 1;
        s = M - sum(X(:));
    end
    idx = sub2ind([N, N], h1, v1);
end




