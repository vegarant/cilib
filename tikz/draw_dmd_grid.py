"""
Creates tikz code for a DMD grid.
"""

from math import pi, sin, cos, tan, asin,acos, atan, sqrt;
import numpy as np;
from os.path import join;

dest = 'figure_tex_files';

N  = 8;
gs = 40; # Grid size (number of grid squares along each axis) 

ds = N/gs; # The spacing between the grid points

with open(join(dest, 'dmd_grid.tex'), 'w') as f:
    l1 = r'\draw (0,0) rectangle (%g,%g);' % (N,N);
    f.write(l1+'\n');
    
    for i in range(1, gs):
        l2 = r'\draw (%g,%g) -- (%g, %g);' % (i*ds, 0, i*ds, N);
        l3 = r'\draw (%g,%g) -- (%g, %g);' % (0, i*ds, N, i*ds);
        f.write(l2+'\n');
        f.write(l3+'\n');

    X = np.random.binomial(1, 0.5, size=[gs,gs]); # Creates a matrix with zeros 
                                                  # and ones, stored as
                                                  # integers
    
    for i in range(gs):
        for j in range(gs):
            val = X[i,j];
            if val: # Value is non-zero
                l4 = r'\filldraw[black] (%g, %g) rectangle (%g, %g);' % \
                       (i*ds,j*ds, (i+1)*ds, (j+1)*ds);
                f.write(l4+'\n');
    l5 = r'\draw (%g, 0) node[below] {DMD};' % (N/2);
    f.write(l5+'\n');
    
    wid = 0.02*N;
    l6 = r'\draw (%g,%g) -- (%g, %g) -- (%g,%g) -- (%g, %g) -- (%g, %g);' \
         % (0,N, wid,N+wid, N+wid, N+wid, N+wid, wid, N, 0);
    l7 = r'\draw (%g,%g) -- (%g,%g);' % (N,N, N+wid, N+wid)
    f.write(l6+'\n');
    f.write(l7+'\n');
    
