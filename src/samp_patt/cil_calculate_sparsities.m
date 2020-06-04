% Calculate sparsities of image X  
% IMPROVE: Fix documentation
%
% INPUT:
% X    - N×N grayscale image
% nres - Number of wavelet decompositions
% wname - Wavelet name, i.e. 'db4' or similar
%
% OUTPUT:
% sValues - ??  
% 
% Randall Bergman, 2019.
function sValues = cil_calculate_sparsities(X, nres, vm)
    
    % Store current boundary extension mode
    boundary_extension = dwtmode('status', 'nodisp');
    % Set the correct boundary extension for the wavelets
    dwtmode('per', 'nodisp');
    
    X = X/norm(X, 'fro');

    N = size(X, 1);
    r = round(log2(N));
    j0 = r - nres;
    
    if ~exist('vm', 'var')
        vm = 4;
    end

    wname = sprintf('db%d', vm);

    [c, S] = wavedec2(X, nres, wname);
    c = abs(c);
    c = c.*(c > 50*eps); % account for floating-point imprecision in mdwt 
                         % by zeroing tiny coefficients

    [~, I] = sort(c, 'descend');

    nnzCoefficients = nnz(c);
    I = I(1:nnzCoefficients);

    lb = 1;
    ub = 2^(2*(j0+1));
    sValues = zeros(nres, N^2);
    
    for k = 1:nres
        sValues(k, 1:nnzCoefficients) = cumsum( (lb <= I).*(I <= ub) );
        lb = ub+1;
        ub = ub + 3*2^(2*(j0+k));
    end
    
    
    W = zeros(nres, 1);
    W(1) = round(4*2.^(2*j0));
    W(2:end) = round(3*2.^(2*(j0+1:j0+nres-1)));
    
    %% If the image has less than m nonzero coefficients, rescale s 
    s = sValues(:, nnzCoefficients);
    deltaS = sValues(:, nnzCoefficients)/sum(sValues(:, nnzCoefficients));
    for m = nnzCoefficients+1:N^2
        s = s + deltaS;
        
        % Enforce s_k <= |W_k|
        while any(s > W)
            deltaS(s > W) = 0;
            deltaS = deltaS/sum(deltaS);
            
            s = min(s, W);
            s = s + deltaS * (m - sum(s)); 
        end
        
        sValues(:, m) = s;
    end
    % Restore dwtmode
    dwtmode(boundary_extension, 'nodisp')
end

