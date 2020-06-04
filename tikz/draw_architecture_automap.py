"""
Creates the tikz code for the AUTOMAP architecture.
"""

box_width = 0.03
box_width_eps = 0.0017 # For boxes with super few filters
box_height = 1.9
filter_ = 10;
len_conv = 0.4;
len_tconv = 0.2;
len_max_pool = 0.2;
blank = 0.1;
blank_long = 0.4
draw_conv = lambda x1,y1, color: print("\\draw[ultra thick,%s,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (color, x1,y1,x1+len_conv,y1))
draw_max_pool = lambda x1,y1: print("\\draw[ultra thick,blue,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1,x1,y1-len_max_pool))
draw_tconv = lambda x1,y1: print("\\draw[ultra thick,red,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1,x1,y1+len_tconv))
draw_connection = lambda x1,y1,x2,y2: print("\\draw[ultra thick,lightgray,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1,x2,y2))

# node[midway, above, black] {\\scriptsize{skip con.}}

def draw_rec(x1,y1,res,filt,color, pos='above', center_text=0.5, filt_nbr=None):
    l1 = "\\fill[%s] (%g, %g) rectangle (%g, %g);" % (color, x1,y1+0.5*res*box_height,x1+filt*box_width,y1-0.5*res*box_height)
    if pos is not None:
        if filt_nbr is not None:
            l2 = " \\node[%s]  at (%g, %g) {\\scriptsize{$%d$}};" % (pos,x1+center_text*filt*box_width,y1+0.5*res*box_height, filt_nbr)
        else:
            l2 = " \\node[%s]  at (%g, %g) {\\scriptsize{$%d$}};" % (pos,x1+center_text*filt*box_width,y1+0.5*res*box_height, filt)
    else:
        l2 = ''
    print(l1+l2)
xpos = 0.0;
ypos = 0.0;

colors = ['brown', 'red', 'blue', 'lightgray', 'teal', 'orange']; 


res = 0.6;

filtsize = [64,64]

con_xy_pos1 = []
con_xy_pos2 = []

filt= 1
draw_rec(xpos,ypos, res, filt=filt, color='violet');

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$2m$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)
res = 1.5;
xpos += filt*box_width+blank;
draw_conv(xpos,ypos, colors[0])
xpos += len_conv + blank
draw_rec(xpos,ypos, res,filt, 'violet')
xpos += filt*box_width + blank

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$\\tfrac{3}{2}N^2$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)
l3 = "\\draw[<-] (%g,%g) -- (%g,%g) node[right] {{\\scriptsize Number of channels}};" % (xpos+1*blank, ypos+0.57*res*box_height, xpos+4*blank, ypos+0.57*res*box_height)
print(l3)

res = 1;
xpos += blank;
draw_conv(xpos,ypos,colors[1])
xpos += len_conv + blank
draw_rec(xpos,ypos, res,filt, 'violet')

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$N^2$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)
xpos += filt*box_width + blank

res = 1;
xpos += blank;
draw_conv(xpos,ypos, colors[2])
xpos += len_conv + blank
draw_rec(xpos,ypos, res,filt, 'violet')

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$N\\!\\!\\times \\!\\! N$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)
xpos += filt*box_width + blank

filt=30
res = 1;
draw_conv(xpos,ypos, colors[3])
xpos += len_conv + blank
draw_rec(xpos,ypos, res,filt=filt, color='violet', filt_nbr=64)

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$N\\!\\!\\times \\!\\! N$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)
xpos += filt*box_width + blank

filt=30
res = 1;
draw_conv(xpos,ypos, colors[4])
xpos += len_conv + blank
draw_rec(xpos,ypos, res,filt=filt, color='violet', filt_nbr=64)

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$N\\!\\!\\times \\!\\! N$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)
xpos += filt*box_width + blank

filt=1
res = 1;
draw_conv(xpos,ypos, colors[5])
xpos += len_conv + blank
draw_rec(xpos,ypos, res,filt=filt, color='violet')

l2 = " \\node[rotate=90, above right]  at (%g, %g) {\\scriptsize{$N\\!\\!\\times \\!\\! N$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)

res = 1.5

xpos += filt*box_width + 8*blank
ypos += 0.35*res*box_height


draw_conv(xpos,ypos, colors[0])

l1 = "\\node[right] at (%g,%g) {\\scriptsize{Dense \\!+\\! $\\tanh$}};" % (xpos+blank+len_conv, ypos)
print(l1)

ypos -= len_conv;
draw_conv(xpos,ypos, colors[1])
l1 = "\\node[right] at (%g,%g) {\\scriptsize{Dense \\!+\\! Subtract mean}};" % (xpos+blank+len_conv, ypos)
print(l1)

ypos -= len_conv;
draw_conv(xpos,ypos, colors[2])
l1 = "\\node[right] at (%g,%g) {\\scriptsize{Reshape}};" % (xpos+blank+len_conv, ypos)
print(l1)

ypos -= len_conv;
draw_conv(xpos,ypos, colors[3])
l1 = "\\node[right] at (%g,%g) {\\scriptsize{Conv. \\!+\\! $\\tanh$}};" % (xpos+blank+len_conv, ypos)
print(l1)

ypos -= len_conv;
draw_conv(xpos,ypos, colors[4])
l1 = "\\node[right] at (%g,%g) {\\scriptsize{Conv. \\!+\\! ReLU}};" % (xpos+blank+len_conv, ypos)
print(l1)

ypos -= len_conv;
draw_conv(xpos,ypos, colors[5])
l1 = "\\node[right] at (%g,%g) {\\scriptsize{Tansp. Conv. }};" % (xpos+blank+len_conv, ypos)
print(l1)




