"""
Creates tikz code for a line parametrised by (t, theta), and writes it directly to a file.
"""

from math import pi, sin, cos, tan, asin,acos, atan, sqrt;
import numpy as np;
from os.path import join;

to_radians = lambda x: pi*x/180.0;
to_degrees = lambda x: 180*x/pi;
dest = 'figure_tex_files';



rad1 = 2.7;
t = rad1 + 1;
theta1 = 70;
axis_diff = 1;
theta_perp = theta1 + 90; 
length_line_right = 3;
length_line_left = 3.5;
length_origin_line_right = 2;
length_origin_line_left = 3;

displacement_t_line = 2;

with open(join(dest, 'line_geom.tex'), 'w') as f:
    l1 = r'\draw (%g, 0) -- (%g, 0);' % (-rad1,rad1+axis_diff);
    l2 = r'\draw (0, %g) -- (0, %g);' % (-1,rad1+axis_diff+1);
    f.write(l1 + '\n');
    f.write(l2 + '\n');

    x = rad1*cos(to_radians(theta1));
    y = rad1*sin(to_radians(theta1));
    l3 = r'\draw[-{Latex[length=5mm, width=2mm]}] (0, 0) -- (%g, %g) node[right] {$n$};' % \
          (x,y);
    f.write(l3 + '\n');

    r = 0.55*(rad1);
    x1 = r*cos(to_radians(0));
    y1 = r*sin(to_radians(0));
    l4 = r'\draw[-{Latex[length=2mm, width=1mm]}] (%g,%g)  arc (%g:%g:%g) node[midway, right] {$\theta$};' % \
          (x1,y1, 0 , theta1, r);
    f.write(l4+'\n');
    
    ang_right = atan(length_line_right/t);
    ang_left  = atan(length_line_left/t);
    r_right = sqrt(length_line_right**2 + t**2);
    r_left  = sqrt(length_line_left**2 + t**2);
    
    # Draw line
    xs1 =  r_right*cos(to_radians(theta1)-ang_right);
    ys1 =  r_right*sin(to_radians(theta1)-ang_right);
    xs2 =   r_left*cos(to_radians(theta1)+ang_left);
    ys2 =   r_left*sin(to_radians(theta1)+ang_left);

    l5 = r'\draw (%g,%g) node[above] {$l_{t,\theta}$} -- (%g, %g);' % (xs1,ys1, xs2,ys2);
    f.write(l5+'\n');


    # Draw parallel line through origin
    xs1 =  length_origin_line_left*cos(to_radians(theta_perp));
    ys1 =  length_origin_line_left*sin(to_radians(theta_perp));
    xs2 =   -length_origin_line_right*cos(to_radians(theta_perp));
    ys2 =   -length_origin_line_right*sin(to_radians(theta_perp));

    l6 = r'\draw[dashed] (%g,%g) -- (%g, %g);' % (xs1,ys1, xs2,ys2);
    f.write(l6+'\n');

    ang = atan(displacement_t_line/t);
    r = sqrt(displacement_t_line**2 + t**2);
    x1 =  displacement_t_line*cos(to_radians(theta_perp));
    y1 =  displacement_t_line*sin(to_radians(theta_perp));
    x2 =  r*cos(to_radians(theta1)+ang);
    y2 =  r*sin(to_radians(theta1)+ang);
    
    l7 = r'\draw[{Latex[length=2mm, width=1mm]}-{Latex[length=2mm, width=1mm]}] (%g,%g) -- (%g, %g) node[midway, left] {$t$};' % (x1,y1, x2,y2);
    f.write(l7+'\n');
    



