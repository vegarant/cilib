"""
Creates the tikz code for a U-net architecture.
"""


box_width = 0.0011
box_width_eps = 0.0017 # For boxes with super few filters
box_height = 1.9
filter_ = 10;
len_conv = 0.2;
len_tconv = 0.2;
len_max_pool = 0.2;
blank = 0.05;
blank_long = 0.4
draw_conv = lambda x1,y1, res: print("\\draw[ultra thick,brown,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1-.5*res*box_height,x1+len_conv,y1-.5*res*box_height))
draw_max_pool = lambda x1,y1: print("\\draw[ultra thick,blue,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1,x1,y1-len_max_pool))
draw_tconv = lambda x1,y1: print("\\draw[ultra thick,red,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1,x1,y1+len_tconv))
draw_connection = lambda x1,y1,x2,y2: print("\\draw[ultra thick,lightgray,-{Latex[length=1.2mm,width=3mm]}] (%g, %g) -- (%g, %g);" % (x1,y1,x2,y2))

# node[midway, above, black] {\\scriptsize{skip con.}}

def draw_rec(x1,y1,res,filt,color, pos='above', center_text=0.5, filt_nbr=None):
    l1 = "\\fill[%s] (%g, %g) rectangle (%g, %g);" % (color, x1,y1,x1+filt*box_width,y1-res*box_height)
    if pos is not None:
        if filt_nbr is not None:
            l2 = " \\node[%s]  at (%g, %g) {\\scriptsize{$%d$}};" % (pos,x1+center_text*filt*box_width,y1, filt_nbr)
        else:
            l2 = " \\node[%s]  at (%g, %g) {\\scriptsize{$%d$}};" % (pos,x1+center_text*filt*box_width,y1, filt)
    else:
        l2 = ''
    print(l1+l2)
xpos = 0.0;
ypos = 0.0;

filtsize = [64,64]

con_xy_pos1 = []
con_xy_pos2 = []


res = 1.0;
filt=30;
draw_rec(xpos,ypos, res, filt=filt, color='violet', filt_nbr=1);

l2 = " \\node[rotate=90, above]  at (%g, %g) {\\scriptsize{$N\\!\\! \\times \\!\\! N$}};" % (xpos, ypos-0.5*res*box_height);
print(l2)

xpos += filt*box_width + blank
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'violet')
    xpos += filt*box_width + blank
con_xy_pos1.append((xpos, ypos-0.5*res*box_height))

a = xpos +filtsize[-1]*box_width;
b = ypos+len_max_pool;
l2 = "\\draw[<-] (%g,%g) -- (%g,%g) node[right] {{\\scriptsize Number of channels}};" % (a+4*blank, b, a+len_conv+4*blank, b)
print(l2)
 
xpos -= 0.5*filtsize[-1]*box_width+blank
ypos -= res*box_height+blank

draw_max_pool(xpos,ypos)

ypos -= len_max_pool+blank_long
xpos -= 0.5*filtsize[-1]*box_width

res =0.5
filt=filtsize[-1]
draw_rec(xpos,ypos, res,filt, 'violet')
xpos += filt*box_width + blank


l2 = " \\node[rotate=90, above]  at (%g, %g) {\\scriptsize{$\\tfrac{N}{2}\\!\\! \\times \\!\\!\\tfrac{N}{2}$}};" % (xpos-filt*box_width, ypos-0.5*res*box_height);
print(l2)

filtsize = [128,128]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'violet')
    xpos += filt*box_width + blank
con_xy_pos1.append((xpos, ypos-0.5*res*box_height))

xpos -= 0.5*filtsize[-1]*box_width+blank
ypos -= res*box_height+blank

draw_max_pool(xpos,ypos)

ypos -= len_max_pool+blank_long
xpos -= 0.5*filtsize[-1]*box_width

res =0.25
filt=filtsize[-1]
draw_rec(xpos,ypos, res,filt, 'violet')
xpos += filt*box_width + blank

l2 = " \\node[rotate=90, above]  at (%g, %g) {\\scriptsize{$\\tfrac{N}{4}\\!\\! \\times \\!\\!\\tfrac{N}{4}$}};" % (xpos-filt*box_width, ypos-0.5*res*box_height);
print(l2)

#l2 = " \\node[rotate=90, above]  at (%g, %g) {\\scriptsize{$(N/4)^2$}};" % (xpos-filt*box_width, ypos-0.5*res*box_height);
#print(l2)
filtsize = [256,256]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'violet')
    xpos += filt*box_width + blank
con_xy_pos1.append((xpos, ypos-0.5*res*box_height))

xpos -= 0.5*filtsize[-1]*box_width+blank
ypos -= res*box_height+blank

draw_max_pool(xpos,ypos)

ypos -= len_max_pool+blank_long
xpos -= 0.5*filtsize[-1]*box_width

res =0.5*0.25
filt=filtsize[-1]
draw_rec(xpos,ypos, res,filt, 'violet')
xpos += filt*box_width + blank

filtsize = [512, 512]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'violet')
    xpos += filt*box_width + blank
con_xy_pos1.append((xpos, ypos-0.5*res*box_height))

xpos -= 0.5*filtsize[-1]*box_width+blank
ypos -= res*box_height+blank

draw_max_pool(xpos,ypos)

ypos -= len_max_pool+blank_long
xpos -= 0.5*filtsize[-1]*box_width

res =0.25*0.25
filt=filtsize[-1]
draw_rec(xpos,ypos, res,filt, 'violet')
xpos += filt*box_width + blank

filtsize = [1024, 1024]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'violet')
    xpos += filt*box_width + blank

ypos += blank_long
xpos -= 0.5*filtsize[-1]*box_width + blank

draw_tconv(xpos,ypos)


res = .125;
filt=filtsize[-1]/2
ypos += blank+len_tconv + res*box_height
xpos -= 0.5*filt*box_width

draw_rec(xpos,ypos,res, filt, 'green', center_text=0, filt_nbr=filt*2)
xpos -= filt*box_width
draw_rec(xpos,ypos,res, filt, 'violet', pos=None)
con_xy_pos2.insert(0, (xpos,ypos-0.5*res*box_height))
xpos += filt*box_width
xpos += filt*box_width + blank

filtsize = [512,512]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'green')
    xpos += filt*box_width + blank


ypos += blank_long
xpos -= 0.5*filtsize[-1]*box_width + blank

draw_tconv(xpos,ypos)


res = .25;
filt=filtsize[-1]/2
ypos += blank+len_tconv + res*box_height
xpos -= 0.5*filt*box_width

draw_rec(xpos,ypos,res, filt, 'green', center_text=0, filt_nbr=filt*2)
xpos -= filt*box_width
draw_rec(xpos,ypos,res, filt, 'violet', pos=None)
con_xy_pos2.insert(0, (xpos,ypos-0.5*res*box_height))
xpos += filt*box_width
xpos += filt*box_width + blank

filtsize = [256,256]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'green')
    xpos += filt*box_width + blank

ypos += blank_long
xpos -= 0.5*filtsize[-1]*box_width + blank

draw_tconv(xpos,ypos)

res = .5;
filt=filtsize[-1]/2
ypos += blank+len_tconv + res*box_height
xpos -= 0.5*filt*box_width

draw_rec(xpos,ypos,res, filt, 'green', center_text=0, filt_nbr=filt*2)
xpos -= filt*box_width
draw_rec(xpos,ypos,res, filt, 'violet', pos=None)
con_xy_pos2.insert(0, (xpos,ypos-0.5*res*box_height))
xpos += filt*box_width
xpos += filt*box_width + blank

filtsize = [128, 128]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + blank
    draw_rec(xpos,ypos, res,filt, 'green')
    xpos += filt*box_width + blank

ypos += blank_long
xpos -= 0.5*filtsize[-1]*box_width + blank

draw_tconv(xpos,ypos)

res = 1;
filt=filtsize[-1]/2
ypos += blank+len_tconv + res*box_height
xpos -= 0.5*filt*box_width

draw_rec(xpos,ypos,res, filt, 'green', center_text=0, filt_nbr=filt*2)

xpos -= filt*box_width
draw_rec(xpos,ypos,res, filt, 'violet', pos=None)
con_xy_pos2.insert(0, (xpos,ypos-0.5*res*box_height))
xpos += filt*box_width
xpos += filt*box_width + blank

filtsize = [64,64]
for i in range(len(filtsize)):
    filt = filtsize[i];
    draw_conv(xpos,ypos,res)
    xpos += len_conv + 2*blank
    draw_rec(xpos,ypos, res,filt, 'green')
    xpos += filt*box_width + 2*blank
    
draw_conv(xpos,ypos,res)
xpos += len_conv + 2*blank
draw_rec(xpos,ypos, res,filt=30, color='green', filt_nbr=1)
xpos += filt*box_width + 2*blank

for start, end in zip(con_xy_pos1, con_xy_pos2):
    draw_connection(start[0]+blank, start[1], end[0]-blank, end[1])    

# Write what the arrows mean

xpos = -0.3
ypos = -2*box_height - 2*len_max_pool - 2*blank - 2*blank_long;

draw_max_pool(xpos,ypos)
l1 = "\\node[right] at (%g,%g) {\\scriptsize{Max pool}};" % (xpos+blank+len_conv, ypos-0.5*len_max_pool)
print(l1)

ypos -= len_max_pool + 6*blank

draw_conv(xpos-2*blank,ypos, 0)

l1 = "\\node[right] at (%g,%g) {\\scriptsize{Conv. + ReLU}};" % (xpos+blank+len_conv, ypos)
print(l1)

ypos -= len_max_pool + 6*blank

draw_tconv(xpos,ypos)

l1 = "\\node[right] at (%g,%g) {\\scriptsize{Transp. conv. + ReLU}};" % (xpos+blank+len_conv, ypos+0.5*len_tconv)
print(l1)

ypos -= len_max_pool + 6*blank

draw_connection(xpos-2*blank,ypos+len_tconv, xpos + len_conv-2*blank, ypos+len_tconv)

l1 = "\\node[right] at (%g,%g) {\\scriptsize{Copy and concatenate}};" % (xpos+blank+len_conv, ypos+len_tconv)
print(l1)




