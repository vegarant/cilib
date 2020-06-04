% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
function [idx, str_id] = cil_sph2_gauss(N, M, full_levels)
    str_id = 'gauss'
    nu = log2(N);

    Y = zeros(N, N, 'uint8'); 

    bin_boundary = 2.^(0:nu); 

    pos = zeros(M,2);
    s = 1;

    for i = 1:2^full_levels
        for j = 1:2^full_levels
            Y(i,j) = 1;
            pos(s,:) = [i, j];
            s = s + 1;
        end
    end

    while s <= M
        x = round(abs(N*randn(1,1)/3));
        y = round(abs(N*randn(1,1)/3));
        if (x < 1)
            x = round(2*(rand(1,1) + 1));
        end
        if (y < 1)
            y = round(2*(rand(1,1) + 1));
        end
        if (x > N)
            x = round((bin_boundary(nu) - bin_boundary(nu-1))*rand(1,1) ...
                + bin_boundary(nu-1));
        end
        if (y > N)
            y = round((bin_boundary(nu) - bin_boundary(nu-1))*rand(1,1) ...
                + bin_boundary(nu-1));
        end
        if (Y(x,y) < 1)
            Y(x,y) = Y(x,y) + 1;
            pos(s,:) = [x, y];
            s = s + 1;
        end
    end

    idx = sub2ind([N,N], pos(:,1), pos(:,2));

end
