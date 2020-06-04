"""
Creates the tikz code for the Imagenet competition scores.
"""



h = 5; # Height of the diagram
w = 10.4; # Width of the diagram

scale = 30

blank = 0.8; # Space between bars
box_width = 0.5; # Space between bars
blue = 'blue!70!orange';
green = 'green!60!orange';

def draw_rectangle(xpos, num, unit, color, name, box_width=box_width):
    l1 = r'\filldraw[%s] (%g,%g) rectangle (%g,%g);' % (color, xpos, 0,xpos+box_width, unit*num)
    l2 = r'\node[above] at (%g,%g) {\scriptsize{ %s}};' % (xpos+0.4*box_width, unit*num, str(num))
    l3 = r'\node[below, align=center] at (%g,0) { %s};' % (xpos+0.5*box_width, name)
    print(l1);
    print(l2);
    print(l3);

print(r'{\scriptsize')

unit = h/scale;

xpos = 0.5*blank; 
draw_rectangle(xpos, 28.2, unit, blue, r'ILSVRC \\ 2010 \\ NEC')

xpos += blank + box_width; 
draw_rectangle(xpos, 25.7, unit, blue, r'ILSVRC \\ 2011 \\ XRCE')

xpos += blank + box_width; 
draw_rectangle(xpos, 15.3, unit, blue, r'ILSVRC \\ 2012 \\ AlexNet')

xpos += blank + box_width; 
draw_rectangle(xpos, 11.2, unit, blue, r'ILSVRC \\ 2013 \\ Clarifai')

xpos += blank + box_width; 
draw_rectangle(xpos, 7.3, unit, blue, r'ILSVRC \\ 2014 \\ VGG')

xpos += blank + box_width; 
draw_rectangle(xpos, 6.7, unit, blue, r'ILSVRC \\ 2014 \\ GoogLeNet')

xpos += blank + box_width; 
draw_rectangle(xpos, 5.1, unit, green, r'Human \\ performance')

xpos += blank + box_width; 
draw_rectangle(xpos, 3.6, unit, blue, r'ILSVRC \\ 2015 \\ ResNet')

axis_name = r'ImageNet classification top 5-error (\%)'
l1 = r'\draw[thick] (0,0) -- (%g, 0);' % (w);
l2 = r'\draw[thick] (0,0) -- (0, %g) node[midway, above, rotate=90] {%s};' % (h, axis_name);
print(l1)
print(l2)

print('}')

