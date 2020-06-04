# Plot the Walsh functions
# Note that you need to install the fastwht python package to make this script work.

from numpy import *;
from hadamard import fastwht;
import os;
from os.path import join;

"""
This file produce a tikz code which will draw the first 16 Walsh functions. 
"""

set_printoptions(linewidth=170, precision=5);

def seqmat(N):
    """
    Return the sequency Hadamard matrix as a two dimensional array
    """
    nu = int(round(log2(N))); 
    if (N != 2**nu):
        print("Error: %d is non-dyadic" % (N));
        N = 2**nu;
    U = zeros([N,N]);
    for i in range(N):
        ei = zeros(N);
        ei[i] = 1;
        ei = N*fastwht(ei);
        U[:,i] = ei;
    return U;

def palmat(N):
    """
    Return the sequency Hadamard matrix as a two dimensional array
    """
    nu = int(round(log2(N))); 
    if (N != 2**nu):
        print("Error: %d is non-dyadic" % (N));
        N = 2**nu;
    U = zeros([N,N]);
    for i in range(N):
        ei = zeros(N);
        ei[i] = 1;
        ei = N*fastwht(ei,order='dyadic');
        U[:,i] = ei;
    return U;

def signChanges(x):
    """
    This function does only work for {-1, 1} arrays
    """
    
    N = len(x);
    signChange = 0;
    for i in range(N-1):
        if( x[i] != x[i+1]):
            signChange += 1;
    return signChange;

def createTikzString(x, had_height, width, y, numb, paley):
    N = len(x);
    had_width = width/float(N);
    walFreq = signChanges(x);
    cur_width = 0;
    drawline = r"\draw[very thick]  (%g, %g) -- (%g, %g)"  % (cur_width, y, cur_width + had_width, y);
    cur_width += had_width;
    for i in range(1, N):
        cur_width += had_width;
        if x[i-1] == x[i]: 
            tmp_line = " -- (%g, %g) " % (cur_width, (-0.5*(1 - x[i])*had_height + y));
        else:
            tmp_line = " -- (%g, %g) -- (%g, %g)" % (cur_width-had_height, -0.5*(1 - x[i])*had_height + y, cur_width, -0.5*(1 - x[i])*had_height + y);
            
        drawline += tmp_line;
    if (paley):
        drawline += r""";
        \draw (-0.4, %g) node {$v_{%d}^{P}$};
        \draw (%g, %g) node[right]  {$v_{%d}^{S}$};
        """ % (y - 0.2*had_height, numb, width, y - 0.2*had_height, walFreq);
    else:
        drawline += r""";
        \draw (-0.3, %g) node {$v_{%d}^{S}$};
        \draw (%g, %g) node[right]  {$v_{%d}^{P}$};
        """ % (y, numb, width, y, 5);
    return drawline;

def createTikzStringV2(x, had_height, total_width, y, numb, paley):
    N = len(x);
    had_width = width/float(N);
    walFreq = signChanges(x);
    cur_width = 0;
    drawline = r"\draw[very thick]  (%g, %g) -- (%g, %g)"  % (cur_width, y, cur_width + had_width, y);
    for i in range(1, N):
        cur_width += had_width;
        if x[i-1] != x[i] or i == N-1: 
            tmp_line = " -- (%g, %g) -- (%g, %g)" % (cur_width, -0.5*(1 - x[i-1])*had_height + y, cur_width, -0.5*(1 - x[i])*had_height + y);
        else:
            tmp_line = '';
        drawline += tmp_line;
    
     
    tmp_line_end = "-- (%g, %g) -- (%g, %g)" % (cur_width, -0.5*(1 - x[N-1])*had_height + y, cur_width+had_width, -0.5*(1 - x[N-1])*had_height + y); 
    drawline += tmp_line_end;
     
    if (paley):
        drawline += r""";
        \draw (-0.4, %g) node {$v_{%d}^{P}$};
        \draw (%g, %g) node[right]  {$v_{%d}^{S}$};
        """ % (y - 0.2*had_height, numb, width, y - 0.2*had_height, walFreq);
    else:
        drawline += r""";
        \draw (-0.3, %g) node {$v_{%d}^{S}$};
        \draw (%g, %g) node[right]  {$v_{%d}^{P}$};
        """ % (y, numb, width, y, 5);
    return drawline;



if __name__ == "__main__":
    
    dest = 'figure_tex_files';
    paley = True;
    
    nu = 4;
    vm = 2;
    nres = nu;
    N = 2**nu;
    height = 12;
    width = 14;
    vspace_percent = 60; #  
    had_height = (height*(100-vspace_percent)/100.0)/float(N);
    vspace = (height*vspace_percent/100.0)/float(N-1);

    filename = "paley.tex"; 

    os.system("rm -f %s" % filename);
    with open(join(dest,filename), 'w') as outfile:

        if (paley):
            had = palmat(N);
        else:
            had = seqmat(N);
        y = height;
        for i in range(N):
            drawline = createTikzStringV2(had[i, :], had_height, width, y, i, paley);
            y -= had_height + vspace;
            outfile.write(drawline);






