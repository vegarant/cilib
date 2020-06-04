"""
Cretes tikz code for an N × N sampling matrix with different colours for each row.
"""


slen = 4;     # Side length of square
N = 8;        # Number of squares
wspace = 0.4; # White space between boxes
lwidth = 'very thick'; # Linewidht
omega = [1,3,4,5,7]; # Sampling set. The index starts at 1
colours = ['cyan', 'cyan!60!orange', 'cyan!30!orange' , 'orange', 'orange!60!green', 'green!80!red','purple', 'teal'];


wblock = slen/float(N);

# Draw all the blocks
base_x = 0;

for i in range(N):

    l1 = r'\filldraw[%s, draw=black, %s] (%g,%g) rectangle (%g,%g);' % \
        (colours[i], lwidth, base_x, i*wblock, base_x+slen, (i+1)*wblock);
    print(l1)

for i in range(N):

    wx = base_x + i*(wblock);
    l2 = r'\draw[%s] (%g, %g) -- (%g, %g);' % (lwidth, wx, 0, wx, slen);
    print(l2)

# Draw blocks with whitespace
base_x += slen + wspace;

for i in range(N):

    a = i+1;
    if a in omega:
        col = colours[i];
    else:
        col = 'white';
    
    l1 = r'\filldraw[%s, draw=black, %s] (%g,%g) rectangle (%g,%g);' % \
        (col, lwidth, base_x, i*wblock, base_x+slen, (i+1)*wblock);
    print(l1)

for i in range(N):

    wx = base_x + i*(wblock);
    l2 = r'\draw[%s] (%g, %g) -- (%g, %g);' % (lwidth, wx, 0, wx, slen);
    print(l2)

# Draw blocks without whitespace
base_x += slen + wspace;

m = len(omega);
h = m*wblock;

h_baseline = (slen-h)*0.5;

k = 0
for i in range(N):

    a = i+1;
    if a in omega:
        l1 = r'\filldraw[%s, draw=black, %s] (%g,%g) rectangle (%g,%g);' % \
            (colours[i], lwidth, base_x, h_baseline+k*wblock, base_x+slen, h_baseline+(k+1)*wblock);
        print(l1)
        k += 1

k = 0
for i in range(N):

    wx = base_x + i*(wblock);
    l2 = r'\draw[%s] (%g, %g) -- (%g, %g);' % (lwidth, wx, h_baseline, wx, h_baseline + h);
    print(l2)

