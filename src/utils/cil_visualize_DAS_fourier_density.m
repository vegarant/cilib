function image = cil_visualize_DAS_fourier_density(N, density);

    r = round(log2(N));
    nres = size(density,1);
    j0 = r-nres;
    
    log_density = log(density);
    
    Nh = N/2;
    Z = zeros(N,N);
    
    % Set center density
    lb = -2^j0+1;
    ub = 2^j0;
    range1 = Nh+lb:Nh+ub;
    Z(range1,range1) = log_density(1,1);
    
    for k1 = 2:nres
        for k2 = 2:nres
            
            nlbk1 = -2^(j0+k1-1)+1;
            nubk1 = -2^(j0+k1-2);
            plbk1 = 2^(j0+k1-2)+1;
            pubk1 = 2^(j0+k1-1);
            nlbk2 = -2^(j0+k2-1)+1;
            nubk2 = -2^(j0+k2-2);
            plbk2 =  2^(j0+k2-2)+1;
            pubk2 =  2^(j0+k2-1);
            Z(Nh+nlbk1:Nh+nubk1, Nh+nlbk2:Nh+nubk2) = log_density(k1,k2);
            Z(Nh+plbk1:Nh+pubk1, Nh+nlbk2:Nh+nubk2) = log_density(k1,k2);
            Z(Nh+plbk1:Nh+pubk1, Nh+plbk2:Nh+pubk2) = log_density(k1,k2);
            Z(Nh+nlbk1:Nh+nubk1, Nh+plbk2:Nh+pubk2) = log_density(k1,k2);
        end 
    end
    
    for k1 = 2:nres
        k2 = 1;
        lbk2 = -2^j0+1;
        ubk2 = 2^j0;
        nlbk1 = -2^(j0+k1-1)+1;
        nubk1 = -2^(j0+k1-2);
        plbk1 = 2^(j0+k1-2)+1;
        pubk1 = 2^(j0+k1-1);
        Z(Nh+nlbk1:Nh+nubk1, Nh+lbk2:Nh+ubk2) = log_density(k1,k2);
        Z(Nh+plbk1:Nh+pubk1, Nh+lbk2:Nh+ubk2) = log_density(k1,k2);
        Z(Nh+lbk2:Nh+ubk2, Nh+plbk1:Nh+pubk1) = log_density(k2,k1);
        Z(Nh+lbk2:Nh+ubk2, Nh+nlbk1:Nh+nubk1) = log_density(k2,k1);
    end
    image=Z;

end
