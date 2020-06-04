% Creates spiral fourier sampling pattern. 
%
% Please note that this function is extreamly fragile to change in parameter
% values and sampling rates. 
%
% INPUT
% N           - Size of the N × N sampling pattern
% nbr_samples - Number of samples
% a           - Parameter (try 0.5)
% b           - Parameter (try [0.1, 0.3])
%
% RETURN
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
function [idx, str_id] = cil_spf2_spiral(N, nbr_samples, a, b)
    str_id = 'spiral';

    f = @(s) function_for_bisection_method(N,a,b,s) - nbr_samples;

    s = cil_bisection(f, 0.001, 400);

    t = linspace(0, (log(N/2)/b)^(1/a), s*N);
    x_idx = exp(b*t.^a).*cos(t);
    y_idx = exp(b*t.^a).*sin(t);
    
    x_idx = round(x_idx + N/2);
    y_idx = round(y_idx + N/2);
    small_x = x_idx < 1;
    large_x = x_idx > N;
    small_y = y_idx < 1;
    large_y = y_idx > N;
    x_idx(small_x) = 1;
    x_idx(large_x) = N;
    y_idx(large_y) = N;
    y_idx(small_y) = 1;

    idx = sub2ind([N,N], x_idx, y_idx);
    idx = unique(idx);

end


function comp_nbr_samples= function_for_bisection_method(N, a, b, s)

    t = linspace(0, (log(N/2)/b)^(1/a), s*N);
    x_idx = exp(b*t.^a).*cos(t);
    y_idx = exp(b*t.^a).*sin(t);
    
    x_idx = round(x_idx + N/2);
    y_idx = round(y_idx + N/2);
    small_x = x_idx < 1;
    large_x = x_idx > N;
    small_y = y_idx < 1;
    large_y = y_idx > N;
    x_idx(small_x) = 1;
    x_idx(large_x) = N;
    y_idx(large_y) = N;
    y_idx(small_y) = 1;

    idx = sub2ind([N,N], x_idx, y_idx);
    idx = unique(idx);
    comp_nbr_samples = length(idx);
end

