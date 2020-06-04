"""
Creates the tikz code for a simple example illustrating how l_1 minimisation can be unstable to tiny perturbations.
"""

from math import pi, sin, cos, tan, asin,acos, atan, sqrt;
import numpy as np;
from os.path import join;

to_radians = lambda x: pi*x/180.0;
to_degrees = lambda x: 180*x/pi;
dest = 'figure_tex_files';

#rad1 = 2.7;
#t = rad1 + 1;
#theta1 = 70;
#axis_diff = 1;
#theta_perp = theta1 + 90; 
#length_line_right = 3;
#length_line_left = 3.5;
#length_origin_line_right = 2;
#length_origin_line_left = 3;

axis_len = 1.2;
asw = 0.9;

eps = 0.3;

s1l1 = 1.0/(1+eps);
s2l1 = 1;
ln = 0.5; # length of normal vector


l1_x1 = lambda x2: 1 - (1+eps)*x2;
l1_x2 = lambda x1: (1.0-x1)/(1.+eps);

l2_x1 = lambda x2: 1 - (1-eps)*x2;
l2_x2 = lambda x1: (1.0-x1)/(1.0-eps);

with open(join(dest, 'unstable_l1.tex'), 'w') as f:

    # Draw coordinate axis
    l1 = r'\draw (%g, 0) -- (%g, 0);' % (-axis_len, axis_len) 
    l2 = r'\draw (0, %g) -- (0, %g);' % (-axis_len, axis_len) 
    f.write(l1 + '\n');
    f.write(l2 + '\n');

    # Draw l1-ball
    l3 = r'\draw[dashed] (0, -%g) -- (-%g,0) -- (0, %g) -- (%g, 0) -- (0,-%g);' % (s1l1,s1l1,s1l1,s1l1, s1l1)
    f.write(l3 + '\n');

    a = -0.3
    b = -0.2

    l4 = r'\draw (%g, %g) -- (%g, %g);' % (a, l1_x2(a), l1_x1(b), b)
    f.write(l4 + '\n');

    k1 = l1_x1(b)*0.5 # x1 coordinate normal vector
    
    l5 = r'\draw[-{Latex[length=2mm, width=1mm]}] (%g, %g)  -- (%g, %g) node[midway, right] {$A = [1,~~1+\epsilon]$};' % (k1, l1_x2(k1), k1 + ln, l1_x2(k1) + ln*(1+eps));
    f.write(l5+'\n');
    

    # Draw second example

    # Draw coordinate axis
    l1 = r'\draw (%g, 0) -- (%g, 0);' % (asw+axis_len, asw+3*axis_len) 
    l2 = r'\draw (%g, %g) -- (%g, %g);' % (asw+2*axis_len,  -axis_len, asw+2*axis_len, axis_len) 
    f.write(l1 + '\n');
    f.write(l2 + '\n');

    # Draw l1-ball
    l3 = r'\draw[dashed] (%g, -%g) -- (%g,0) -- (%g, %g) -- (%g, 0) -- (%g,-%g);' % (
            asw+2*axis_len, s2l1, asw+2*axis_len-s2l1, asw+2*axis_len, s2l1,
             asw+2*axis_len +s2l1, asw+2*axis_len, s2l1)
    f.write(l3 + '\n');

    s = l1_x2(a);
    l4 = r'\draw (%g, %g) -- (%g, %g);' % (asw + 2*axis_len + l2_x1(s), s, 
                                           asw + 2*axis_len + l2_x1(b), b )
    f.write(l4 + '\n');
    
    k1 = l2_x2(b)/4 # x1 coordinate normal vector

    l5 = r'\draw[-{Latex[length=2mm, width=1mm]}] (%g, %g)  -- (%g, %g) node[above, right] {$A = [1,~~1-\epsilon]$};' % (asw + 2*axis_len +k1, l2_x2(k1), 
                                    asw + 2*axis_len + k1 + ln, l2_x2(k1) + ln*(1-eps));
    f.write(l5+'\n');







    #x = rad1*cos(to_radians(theta1));
    #y = rad1*sin(to_radians(theta1));
    #l3 = r'\draw[-{Latex[length=5mm, width=2mm]}] (0, 0) -- (%g, %g) node[right] {$n$};' % \
    #      (x,y);
    #f.write(l3 + '\n');

    #r = 0.55*(rad1);
    #x1 = r*cos(to_radians(0));
    #y1 = r*sin(to_radians(0));
    #l4 = r'\draw[-{Latex[length=2mm, width=1mm]}] (%g,%g)  arc (%g:%g:%g) node[midway, right] {$\theta$};' % \
    #      (x1,y1, 0 , theta1, r);
    #f.write(l4+'\n');
    #
    #ang_right = atan(length_line_right/t);
    #ang_left  = atan(length_line_left/t);
    #r_right = sqrt(length_line_right**2 + t**2);
    #r_left  = sqrt(length_line_left**2 + t**2);
    #
    ## Draw line
    #xs1 =  r_right*cos(to_radians(theta1)-ang_right);
    #ys1 =  r_right*sin(to_radians(theta1)-ang_right);
    #xs2 =   r_left*cos(to_radians(theta1)+ang_left);
    #ys2 =   r_left*sin(to_radians(theta1)+ang_left);

    #l5 = r'\draw (%g,%g) node[above] {$l_{t,\theta}$} -- (%g, %g);' % (xs1,ys1, xs2,ys2);
    #f.write(l5+'\n');


    ## Draw parallel line through origin
    #xs1 =  length_origin_line_left*cos(to_radians(theta_perp));
    #ys1 =  length_origin_line_left*sin(to_radians(theta_perp));
    #xs2 = -length_origin_line_right*cos(to_radians(theta_perp));
    #ys2 = -length_origin_line_right*sin(to_radians(theta_perp));

    #l6 = r'\draw[dashed] (%g,%g) -- (%g, %g);' % (xs1,ys1, xs2,ys2);
    #f.write(l6+'\n');

    #ang = atan(displacement_t_line/t);
    #r = sqrt(displacement_t_line**2 + t**2);
    #x1 =  displacement_t_line*cos(to_radians(theta_perp));
    #y1 =  displacement_t_line*sin(to_radians(theta_perp));
    #x2 =  r*cos(to_radians(theta1)+ang);
    #y2 =  r*sin(to_radians(theta1)+ang);
    #
    #l7 = r'\draw[{Latex[length=2mm, width=1mm]}-{Latex[length=2mm, width=1mm]}] (%g,%g) -- (%g, %g) node[midway, left] {$t$};' % (x1,y1, x2,y2);
    #f.write(l7+'\n');
    



