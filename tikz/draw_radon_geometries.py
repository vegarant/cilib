# This script creates tikz drawing of the geometry of radon and fan beam
# projections
#
# Remember to include the following in your tex file.
#
# \usepackage{tikz}
# \usetikzlibrary{patterns}
# \usetikzlibrary{arrows}
# \usetikzlibrary{shapes}
# \usetikzlibrary{arrows.meta} % requiers tikz v3.0 or newer

from math import pi, sin, cos, tan, asin,acos, atan, sqrt;
import numpy as np;
from os.path import join;

to_radians = lambda x: pi*x/180.0;
to_degrees = lambda x: 180*x/pi;
dest = 'figure_tex_files';

rad1 = 1.1;
theta1 = 45;
axis_diff = 1.5;
theta_perp = theta1 + 90; 

with open(join(dest,'fan_beam.tex'), 'w') as f:
    angle_detectors = 10;
    r_detector = rad1+axis_diff+0.5;
    
    l1 = r'\draw (0,0) circle (%g);' % (rad1);
    l2 = r'\draw (%g, 0) -- (%g, 0);' % (-rad1-axis_diff,rad1+axis_diff);
    l3 = r'\draw (0, %g) -- (0, %g);' % (-rad1-axis_diff,rad1+axis_diff);
    x = r_detector*cos(to_radians(angle_detectors));
    y = r_detector*sin(to_radians(angle_detectors));
    l4 = r'\draw (%g,%g)  arc (%g:%g:%g) node[midway, right] {Detectors};' % \
          (x,y,angle_detectors, -90-angle_detectors, r_detector );
    
    xs = r_detector*cos(to_radians(theta_perp));
    ys = r_detector*sin(to_radians(theta_perp));
    l5 = r'\filldraw[black] (%g,%g)  circle (0.1) node[above] {Source};' % (xs,ys);
    
    f.write(l1+'\n');
    f.write(l2+'\n');
    f.write(l3+'\n');
    f.write(l4+'\n');
    f.write(l5+'\n');
    #print(l1);
    #print(l2)
    #print(l3)
    #print(l4)
    #print(l5)
    
    nbr_angles = 9
    angles = np.linspace(-90,0, nbr_angles);
    for i in range(len(angles)):
        x = r_detector*cos(to_radians(angles[i]));
        y = r_detector*sin(to_radians(angles[i]));
        if i == int(np.floor(nbr_angles/2)): 
            l6 = r'\draw (%g,%g) -- (%g, %g);' % (xs, ys, x, y);
        else:
            l6 = r'\draw[dashed] (%g,%g) -- (%g, %g);' % (xs, ys, x, y);
        #print(l6)
        f.write(l6+'\n');
    
    x = (rad1+axis_diff)*cos(to_radians(theta1));
    y = (rad1+axis_diff)*sin(to_radians(theta1));
    l7 = r'\draw[-{Latex[length=5mm, width=2mm]}] (0,0) -- (%g,%g);' % (x,y);
    #print(l7);
    f.write(l7+'\n');
    
    
    r = 0.75*(rad1+axis_diff);
    
    x1 = r*cos(to_radians(0));
    y1 = r*sin(to_radians(0));
    l8 = r'\draw[-{Latex[length=2mm, width=1mm]}] (%g,%g)  arc (%g:%g:%g) node[midway, right] {$\theta$};' % \
          (x1,y1, 0 , theta1, r);
    f.write(l8+'\n');
    #print(l8);
    
with open(join(dest,'radon_simple.tex'), 'w') as f:    
    
    l1 = r'\draw (0,0) circle (%g);' % (rad1);
    l2 = r'\draw (%g, 0) -- (%g, 0);' % (-rad1-axis_diff,rad1+axis_diff);
    l3 = r'\draw (0, %g) -- (0, %g);' % (-rad1-axis_diff,rad1+axis_diff);
    
    f.write(l1+'\n');
    f.write(l2+'\n');
    f.write(l3+'\n');
    
    length_detector = 2.45;
    r_detector = rad1 + axis_diff-0.5;
    
    
    ang = atan(length_detector/r_detector);
    r = sqrt(length_detector**2 + r_detector**2);
    # Source
    xs1 =  r*cos(to_radians(theta_perp)-ang);
    ys1 =  r*sin(to_radians(theta_perp)-ang);
    xs2 =  r*cos(to_radians(theta_perp)+ang);
    ys2 =  r*sin(to_radians(theta_perp)+ang);
    
    # Detector
    xd1 = -r*cos(to_radians(theta_perp)-ang);
    yd1 = -r*sin(to_radians(theta_perp)-ang);
    xd2 = -r*cos(to_radians(theta_perp)+ang);
    yd2 = -r*sin(to_radians(theta_perp)+ang);
    
    l4 = r'\draw (%g,%g) -- (%g, %g);' % (xs1,ys1, xs2,ys2);
    l5 = r'\draw (%g,%g) -- (%g, %g);' % (xd1,yd1, xd2,yd2);
    f.write(l4+'\n');
    f.write(l5+'\n');

    nbr_angles = 9;
    a = 1.3;
    pos_lines = np.linspace(-a, a,nbr_angles);
    for i in range(nbr_angles):
        len_detector = pos_lines[i];
        ang = atan(len_detector/r_detector);
        sign1 = np.sign(len_detector);
        abs_len_detector = abs(len_detector);
        r = sqrt(len_detector**2 + r_detector**2);
        
        xs1 = +r*cos(to_radians(theta_perp)+sign1*ang);
        ys1 = +r*sin(to_radians(theta_perp)+sign1*ang);
        xd1 = -r*cos(to_radians(theta_perp)-sign1*ang);
        yd1 = -r*sin(to_radians(theta_perp)-sign1*ang);
        
        xs2 = -r*cos(to_radians(theta_perp)+sign1*ang);
        ys2 = -r*sin(to_radians(theta_perp)+sign1*ang);
        xd2 = +r*cos(to_radians(theta_perp)-sign1*ang);
        yd2 = +r*sin(to_radians(theta_perp)-sign1*ang);
        
        if i == int(np.floor(nbr_angles/2)): 
            l6 = r'\draw (%g,%g) -- (%g, %g);' % (xs1, ys1, xd1, yd1);
        else:
            l6 = r'\draw[dashed] (%g,%g) -- (%g, %g);' % (xs1, ys1, xd1, yd1);
            l7 = r'\draw[dashed] (%g,%g) -- (%g, %g);' % (xs2, ys2, xd2, yd2);
        #print(l6)
        f.write(l6+'\n');
        f.write(l7+'\n');
    x = (rad1+axis_diff)*cos(to_radians(theta1));
    y = (rad1+axis_diff)*sin(to_radians(theta1));
    l8 = r'\draw[-{Latex[length=5mm, width=2mm]}] (0,0) -- (%g,%g);' % (x,y);
    #print(l7);
    r = 0.75*(rad1+axis_diff);
    
    x1 = r*cos(to_radians(0));
    y1 = r*sin(to_radians(0));
    f.write(l8+'\n');
    l8 = r'\draw[-{Latex[length=2mm, width=1mm]}] (%g,%g)  arc (%g:%g:%g) node[midway, right] {$\theta$};' % \
          (x1,y1, 0 , theta1, r);
    f.write(l8+'\n');

    x1 = r_detector*cos(to_radians(-theta1))
    y1 = r_detector*sin(to_radians(-theta1))
    x2 = r_detector*cos(to_radians(theta_perp))
    y2 = r_detector*sin(to_radians(theta_perp))
    l9 = r'\draw (%g,%g)  node[right] {Detectors};' % (x1,y1);
    l10 = r'\draw (%g,%g)  node[left] {Source};' % (x2,y2);
    
    f.write(l9+'\n');
    f.write(l10+'\n');





