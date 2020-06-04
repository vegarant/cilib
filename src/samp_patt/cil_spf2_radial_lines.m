% cil_spf2_radial_lines creates a sampling pattern consisting of lines going through
% the center of an N × N image. The pattern consist of nbr_samples samples divided among
% `lines` number of lines.
%
% INPUT
% N           - Image size i.e. N × N
% nbr_samples - Number of samples
% lines       - Number of lines one would like to sample along 
% all_samples - Boolean (optional). If true (default), one will attempt to 
%               make the number of samples equal to nbr_samples, by increasing the
%               thickness on some of the lines. If false, all lines will have
%               approximately the same thickness. 
%
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
% 
% Known flaws:
% For a high number of lines the number of samples might become higher than nbr_samples.
% In order to make the number of samples equal nbr_samples, some of the lines can become
% thicker than the others.    
%
function [idx, str_id] = cil_spf2_radial_lines(N, nbr_samples, lines, all_samples)
    
    str_id = 'lines';
    
    if (nargin <= 3)
        all_samples = 1;
    end    
    
    c = floor(N/2);              % Center pixel in matrix
    pos = ones([nbr_samples,2]);           % Samples
    Y   = zeros([N,N]);          % Bookkeeping matrix
    s = 0;                       % Number of samples obtained so far
    
    theta = linspace(0, pi, lines+1);
    theta = theta(1:end-1); % remove the last angle 
    
    % Find the intersection of the line with the upper half of the frame 
    hx = round(N./(2*tan(theta(2:end))));
    hy = round(N*tan(theta(2:end))/2);
    
    % Array with the indices of the intersection with the upper half of the
    % frame for each lines  
    up = zeros([lines-1,2]);
    
    % Find total length of all the lines
    length_of_lines = N;
    for i = 1:(lines-1)
        if (hx(i) > (N/2))
            up(i,1) = N/2;
            up(i,2) = -hy(i);
        elseif (hx(i) < -(N/2))
            up(i,1) = -N/2;
            up(i,2) = hy(i);
        else 
            up(i,1) = hx(i);
            up(i,2) = N/2;
        end
        length_of_lines = length_of_lines ...
                          + 2*sqrt( up(i,1)^2 + up(i,2)^2 );
    end
    
    % The corresponding indices in the lower half is
    lo = -up;
    
    % Find line thickness
    lthick = max(floor(nbr_samples/length_of_lines)-1, 2);
    
    ll = 0;
    lh = 0;
    if ( mod(lthick, 2) == 1 ) % Is odd
        ll = floor(lthick/2);
        lh = floor(lthick/2);
    else % Is even
        ll = floor(-1 + lthick/2);
        lh = floor(lthick/2);    
    end
    
    % Sample the horizontal line
    for i = c-ll:c+lh
        for j = 1:N
            s = s + 1;
            pos(s,:) = [i,j];
            Y(i,j) = 1;
        end
    end
    
    % Sample all the other lines
    for k =1:lines-1
        if (abs(up(k,1)) == (N/2)) % The lines intersect the vertical axis
            
            dy = abs(up(k,2));
            x = round(2*dy*(1:N)/N);
            for r = up(k,2):lo(k,2)
                d = find(x == lo(k,2)+r);
                for i = r-ll:r+lh
                    if (~isempty(d))
                        for j = max(d(1)-ll,1):min(d(end)+lh, N)
                            if (Y(c+i,j) ~= 1)
                                s = s + 1;
                                pos(s,:) = [c+i,j];
                                Y(c+i,j) = 1;
                            end
                            if (Y(c-i,j) ~= 1)
                                s = s + 1;
                                pos(s,:) = [c-i,j];
                                Y(c-i,j) = 1;
                            end
                        end
                    end
                end
            end
        
        else % The lines intersect the vertical axis
            
            dx = abs(up(k,1));
            x = round(2*dx*(1:N)/N);
            for r = up(k,1):lo(k,1)
                d = find(x == lo(k,1)+r);
                for j = r-ll:r+lh
                    if (~isempty(d))
                        for i = max(d(1)-ll,1):min(d(end)+lh, N)
                            if (Y(i,c+j) ~= 1)
                                s = s + 1;
                                pos(s,:) = [i,c+j];
                                Y(i,c + j) = 1;
                            end
                            if (Y(i,c-j) ~= 1)
                                s = s + 1;
                                pos(s,:) = [i,c-j];
                                Y(i,c-j) = 1;
                            end
                        end
                    end
                end
            end
            
            
        end
    end
    
    
    
    if (all_samples == 1)
        while (s < nbr_samples)
            B = bwboundaries(abs(Y-1));
            k = 1;
            while (k <= length(B) && s < nbr_samples)
                Q = B{k};
                r = 1;
                while (r <= size(Q, 1) && s < nbr_samples)
                    if (Y(Q(r,1), Q(r,2)) == 0 && Q(r,1) ~= 1 && Q(r,1)~= N ...
                        && Q(r,2) ~= 1 && Q(r,2) ~= N)
                        s = s + 1;
                        pos(s,:) = [Q(r,1), Q(r,2)];
                        Y(Q(r,1), Q(r,2)) = 1;
                        s;
                    end
                    r = r + 1;
                end
                k = k + 1;
            end       
        end
    end
    
    idx = sub2ind([N, N], pos(1:s,1), pos(1:s,2));
    
end

