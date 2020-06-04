function m=cil_bisection(f, xl, xh)
    eps = 1e-8;
    max_itr = 150;
    
    fl = f(xl);
    fh = f(xh);
    fm = 100;
    if (abs(fl) < eps)
        m = xl;
        fm = 0;
    end
    if (abs(fh) < eps)
        m = xh;
        fm = 0;
    end
    
    if (fl*fh > 0)
        fprintf('Bisection method failed: fl = %d, fh = %d\n', fl, fh);
        assert(fl*fh <= 0);
    end
    
    i = 1;
    while (i < max_itr & abs(fm) >= eps)
        m = (xh+xl)/2;
        fm = f(m);
        if (fm*fl < 0)
            xh = m;
        else
            xl = m;
            fl = fm;
        end
        i = i + 1;
    end
end

