% The FISTA solver
%
% Perform `nbr_of_itr` iterations of FISTA solver for the optimization problem 
%     minimize_{z ∈ ℝ^{N}} lambda*||z||_1 + ||measurements - A*z||_{2}^{2}
% where A is the funciton handle `opA`.
%
% INPUT
% measurements - measurements = A*x where x is the unknown signal.
% opA - Function handle opA(z, mode), where z is the input vector and 
%       mode is 1 for the forward transform and 0 for the backward (transpose)
%       transform.
% nbr_of_itr - Number of iterations to run the FISTA algorithm.
% L          - Let la_max be the maximum eigenvalue of A'*A. then L = 2*la_max.
% lambda     - Regularization parameter.
%
% OUTPUT
% The computed solution after `nbr_of_itr`.
%
function sol = cil_FISTA_solver(measurements, opA, nbr_of_itr, L, lambda)

    B = opA(measurements, 0); % transpose
    xp = B; 
    yp = xp;
    tp = 1;
    
    % FISTA
    for i = 1:nbr_of_itr
        cil_progressbar(i, nbr_of_itr);
        z = yp - (2/L)*( opA(opA(yp,1), 0) - B );
        x = sign(z).*max(abs(z) - (lambda/L), 0);
        t = (1 + sqrt(1+4*tp^2))/2;
        y = x + ((tp - 1)/t)*(x - xp);
        tp = t;
        yp = y;
        xp = x;
    end
    
    sol = x;    
    
end

