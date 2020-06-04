
sp = 0.5;
lc = 'very thick, gray!80';
blcv = 'black!78';
blch = 'black!100';
wv = 'black!16';
wh = 'black!0';
fcb = 'white';


# Create the filled regions
l1 = r'\fill[%s] (0,1) rectangle (3,3);' % (blch);
l2 = r'\fill[%s] (3+%g,0) rectangle (6+%g,1);' % (blch, sp, sp);
l3 = r'\fill[%s] (3+%g,2) rectangle (6+%g,3);' % (blch, sp, sp);
l4 = r'\fill[%s] (6+2*%g,0) rectangle (9+2*%g,2);' % (blch, sp, sp);

print(l1);
print(l2);
print(l3);
print(l4);

l1 = r'\fill[%s] (0,3+%g) rectangle (2,6+%g);' % (blcv, sp,sp);
l2 = r'\fill[%s] (3+%g,3+%g) rectangle (4+%g,6+%g);' % (blcv, sp, sp, sp, sp);
l3 = r'\fill[%s] (5+%g,3+%g) rectangle (6+%g,6+%g);' % (blcv, sp, sp, sp, sp);
l4 = r'\fill[%s] (7+2*%g, 3+%g) rectangle (9+2*%g,6+%g);' % (blcv, sp, sp, sp, sp);
l5 = r'\fill[%s] (0,0) rectangle (3,1);' % (wv);
l6 = r'\fill[%s] (3+%g,1) rectangle (6+%g,2);' % (wv, sp, sp);
l7 = r'\fill[%s] (6+2*%g,2) rectangle (9+2*%g,3);' % (wv, sp, sp);

print(l1);
print(l2);
print(l3);
print(l4);
print(l5);
print(l6);
print(l7);

# Draw all rectangles
l1 = r'\draw[%s] (0,0) rectangle (3,3);' % (lc);
l2 = r'\draw[%s] (3+%g,0) rectangle (6+%g,3);' % (lc, sp, sp);
l3 = r'\draw[%s] (6+%g,0) rectangle (9+%g,3);' % (lc, 2*sp, 2*sp);

l4 = r'\draw[%s] (0, 3+%g) rectangle (3, 6+%g);' % (lc, sp, sp);
l5 = r'\draw[%s] (3+%g, 3+%g) rectangle (6+%g, 6+%g);' % (lc, sp, sp, sp, sp);
l6 = r'\draw[%s] (6+%g, 3+%g) rectangle (9+%g, 6+%g);' % (lc, 2*sp, sp, 2*sp, sp);
print(l1);
print(l2);
print(l3);
print(l4);
print(l5);
print(l6);

# Draw all vertical lines
l7 =  r'\draw[%s] (1,0) -- (1,3);' % (lc);
l8 =  r'\draw[%s] (2,0) -- (2,3);' % (lc);
l9 =  r'\draw[%s] (3+%g+1,0) -- (3+%g+1,3);'  % (lc,sp,sp);
l10 = r'\draw[%s] (3+%g+2,0) -- (3+%g+2,3);' % (lc,sp,sp);
l11 = r'\draw[%s] (6+2*%g+1,0) -- (6+2*%g+1,3);'  % (lc,sp,sp);
l12 = r'\draw[%s] (6+2*%g+2,0) -- (6+2*%g+2,3);' % (lc, sp,sp);

print(l7);
print(l8);
print(l9);
print(l10);
print(l11);
print(l12);

l13 = r'\draw[%s] (1,3+%g) -- (1,6+%g);' % (lc,sp,sp);
l14 = r'\draw[%s] (2,3+%g) -- (2,6+%g);' % (lc, sp,sp);
l15 = r'\draw[%s] (3+%g+1,3+%g) -- (3+%g+1,6+%g);'  % (lc,sp,sp,sp,sp);
l16 = r'\draw[%s] (3+%g+2,3+%g) -- (3+%g+2,6+%g);' % (lc,sp,sp,sp,sp);
l17 = r'\draw[%s] (6+2*%g+1,3+%g) -- (6+2*%g+1,6+%g);'  % (lc,sp,sp,sp,sp);
l18 = r'\draw[%s] (6+2*%g+2,3+%g) -- (6+2*%g+2,6+%g);' % (lc,sp, sp, sp, sp);

print(l13);
print(l14);
print(l15);
print(l16);
print(l17);
print(l18);

# Draw all horizontal lines
l19 = r'\draw[%s] (0, 1) -- (3,1);' % (lc)
l20 = r'\draw[%s] (0,2) -- (3,2);' % (lc)
l21 = r'\draw[%s] (0, 3+%g+1) -- (3, 3+%g+1);' % (lc, sp, sp);
l22 = r'\draw[%s] (0, 3+%g+2) -- (3, 3+%g+2);' % (lc, sp, sp);

print(l19);
print(l20);
print(l21);
print(l22);

l23 = r'\draw[%s] (3+%g, 1) -- (6+%g,1);' % (lc, sp,sp);
l24 = r'\draw[%s] (3+%g,2) -- (6+%g,2);' % (lc, sp,sp);
l25 = r'\draw[%s] (3+%g, 3+%g+1) -- (6+%g, 3+%g+1);'  % (lc, sp,sp,sp,sp);
l26 = r'\draw[%s] (3+%g, 3+%g+2) -- (6+%g, 3+%g+2);' % (lc, sp,sp,sp,sp);

print(l23);
print(l24);
print(l25);
print(l26);



l27 = r'\draw[%s] (6+2*%g, 1) -- (9+2*%g,1);' % (lc, sp,sp);
l28 = r'\draw[%s] (6+2*%g,2) -- (9+2*%g,2);' % (lc, sp,sp);
l29 = r'\draw[%s] (6+2*%g, 3+%g+1) -- (9+2*%g, 3+%g+1);'  % (lc,sp,sp,sp,sp);
l30 = r'\draw[%s] (6+2*%g, 3+%g+2) -- (9+2*%g, 3+%g+2);' % (lc,sp,sp,sp,sp);

print(l27);
print(l28);
print(l29);
print(l30);

l31 = r'\draw[%s] (4.5+%g, 0.5)  node {$-a$};' % (fcb, sp);
l32 = r'\draw (4.5+%g, 1.5)  node {$1-a$};' % (sp);
l33 = r'\draw[%s] (4.5+%g, 2.5)  node {$-a$};' % (fcb, sp);

print(l31);
print(l32);
print(l33);

l31 = r'\draw[%s] (3.5+%g, 4.5+%g)  node {$a$};' % (fcb, sp, sp);
l32 = r'\draw[%s] (4.5+%g, 4.5+%g)  node {$1+a$};' % ('black', sp, sp);
l33 = r'\draw[%s] (5.5+%g, 4.5+%g)  node {$a$};' % (fcb, sp, sp);

print(l31);
print(l32);
print(l33);








