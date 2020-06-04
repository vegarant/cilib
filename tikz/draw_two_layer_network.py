"""
Creates tikz code for a two layer neural network.  
"""
blue = 'cyan!25';
red = 'red!50';

box_height = 0.7;
width_hidden = 3;
box_sep = 0.3;
layer_sep = 1.4;
nbr_input_nodes = 5;
nbr_hidden_layers = 3;
nbr_last_layers = 2;

def center_input_node(node_nbr): 
    " node_nbr = 1,2, ..., 5"
    nbr = nbr_input_nodes - node_nbr; # 1,2,3,4,5
    cy = 0.5*box_height + nbr*(box_height + box_sep); 
    cx = 0.5*box_height; 
    return cx,cy;

def center_hidden_layer(node_nbr): 
    " node_nbr = 1, 2, 3 " 
    u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
    u2 = box_height*nbr_hidden_layers + (nbr_hidden_layers-1)*box_sep;
    #a = nbr_input_nodes - nbr_hidden_layers
    baseline_y = (u1-u2)/2;
    #box_height+layer_sep
    
    nbr = nbr_hidden_layers - node_nbr; # 1,2,3
    cy = baseline_y + 0.5*box_height + nbr*(box_height + box_sep); 
    cx = layer_sep + 0.5*width_hidden + box_height; 
    
    return cx,cy;

def center_last_layer(node_nbr): 
    " node_nbr = 1, 2, 3 " 
    u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
    u2 = box_height*nbr_last_layers + (nbr_last_layers-1)*box_sep;
    #a = nbr_input_nodes - nbr_hidden_layers
    baseline_y = (u1-u2)/2
    #box_height+layer_sep
    
    nbr = nbr_last_layers - node_nbr; # 1,2,3
    cy = baseline_y + 0.5*box_height + nbr*(box_height + box_sep); 
    cx = 2*layer_sep + 1.5*width_hidden + box_height; 
    
    return cx,cy;

def draw_input_node(node_nbr):
    cx,cy = center_input_node(node_nbr);   
    a = 0.5*box_height;
    l1 = r'\fill[%s] (%g,%g) rectangle (%g,%g);' % (blue,cx-a,cy-a, cx+a,cy+a);
    l2 = r'\node at (%g,%g) {$x_{%d}$};'  % (cx,cy, node_nbr);
    print(l1);
    print(l2);

def draw_hidden_layer(node_nbr):
    cx,cy = center_hidden_layer(node_nbr);   
    a = 0.5*width_hidden;
    b = 0.5*box_height
    l1 = r'\fill[%s] (%g,%g) rectangle (%g,%g);' % (red,cx-a,cy-b, cx+a,cy+b);
    l2 = r'\node at (%g,%g) {$\sigma ( (W^{(1)} \cdot + b^{(1)} )_{%d})$};'  % (cx,cy, node_nbr);
    print(l1);
    print(l2);

def draw_last_layer(node_nbr):
    cx,cy = center_last_layer(node_nbr);   
    a = 0.5*width_hidden;
    b = 0.5*box_height
    l1 = r'\fill[%s] (%g,%g) rectangle (%g,%g);' % (red,cx-a,cy-b, cx+a,cy+b);
    l2 = r'\node at (%g,%g) {$\sigma ( (W^{(2)} \cdot + b^{(2)} )_{%d})$};'  % (cx,cy, node_nbr);
    print(l1);
    print(l2);

def draw_arrows_lay1(node_nbr):
    cx,cy = center_input_node(node_nbr);   
    u = box_height/(nbr_input_nodes-1)
    nbr = nbr_input_nodes - node_nbr; # 1,2,3
       

    u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
    u2 = box_height*nbr_hidden_layers + (nbr_hidden_layers-1)*box_sep;
    #a = nbr_input_nodes - nbr_hidden_layers
    baseline_y = (u1-u2)/2;
    ccx = box_height+layer_sep
    b = 0.3*box_height
    for i in range(nbr_hidden_layers):
        a = baseline_y + i*(box_height+box_sep)+ u*(nbr)
        l1 = '\draw[-latex\', black!25] (%g,%g) -- (%g,%g);' % (cx+b, cy, ccx, a);
        print(l1)

def draw_arrows_lay2(node_nbr):
    cx,cy = center_hidden_layer(node_nbr);   
    u = box_height/(nbr_hidden_layers-1)
    nbr = nbr_hidden_layers - node_nbr; # 1,2,3
    
    u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
    u2 = box_height*nbr_last_layers + (nbr_last_layers-1)*box_sep;
    #a = nbr_input_nodes - nbr_hidden_layers
    baseline_y = (u1-u2)/2;
    ccx = box_height+2*layer_sep+width_hidden;
    b = 0.3*width_hidden
    for i in range(nbr_last_layers):
        a = baseline_y + i*(box_height+box_sep)+ u*(nbr)
        l1 = '\draw[-latex\', black!25] (%g,%g) -- (%g,%g);' % (cx+b, cy, ccx, a);
        print(l1)

def draw_arrows_lay3(node_nbr):
    cx,cy = center_hidden_layer(node_nbr);   
    u = box_height/(nbr_hidden_layers-1)
    nbr = nbr_last_layers - node_nbr; # 1,2,3
    
    u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
    u2 = box_height*nbr_last_layers + (nbr_last_layers-1)*box_sep;
    #a = nbr_input_nodes - nbr_hidden_layers
    baseline_y = (u1-u2)/2;
    ccx = box_height+2*layer_sep+2*width_hidden;
    b = 0.3*width_hidden
    a = baseline_y + nbr*(box_height+box_sep) + 0.5*box_height
    l1 = '\draw[-latex\', black!25] (%g,%g) -- (%g,%g);' % (ccx, a, ccx+layer_sep, u1/2+(nbr-0.5)*0.1*a);
    print(l1)


for i in range(nbr_input_nodes):
    draw_arrows_lay1(i+1)
for i in range(nbr_input_nodes):
    draw_input_node(i+1);
cx = 0.5*box_height;
cy = nbr_input_nodes*(box_height + box_sep)-box_sep;
l1 = r'\node[align=center, above] (fds) at (%g,%g) {Input\\layer};' % (cx,cy);
print(l1)

for i in range(nbr_hidden_layers):
    draw_arrows_lay2(i+1)
for i in range(nbr_hidden_layers):
    draw_hidden_layer(i+1)


u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
u2 = box_height*nbr_hidden_layers + (nbr_hidden_layers-1)*box_sep;
#a = nbr_input_nodes - nbr_hidden_layers
baseline_y = (u1-u2)/2 + u2;

cx = box_height + layer_sep + 0.5*width_hidden;
cy = baseline_y
l1 = r'\node[align=center, above] (fds) at (%g,%g) {Hidden \\layer};' % (cx,cy);
print(l1)


for i in range(nbr_last_layers):
    draw_arrows_lay3(i+1)
    draw_last_layer(i+1)

u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
u2 = box_height*nbr_last_layers + (nbr_last_layers-1)*box_sep;
#a = nbr_input_nodes - nbr_hidden_layers
baseline_y = (u1-u2)/2 + u2;
cx = box_height + 2*layer_sep + 1.5*width_hidden;
cy = baseline_y
l1 = r'\node[align=center, above] (fds) at (%g,%g) {Output \\layer};' % (cx,cy);
print(l1)


u1 = box_height*nbr_input_nodes + (nbr_input_nodes-1)*box_sep;
cx = box_height + 3*layer_sep + 2*width_hidden;

l1 = r'\node[align=center, right] (fds) at (%g,%g) {Output};' % (cx,u1/2);
print(l1)

