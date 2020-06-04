# Tikz figures 
This directory contain the Tikz code for all the Tikz-figures in the book _Compressive Imaging_.
In addition it contain different `.py` files used to generate these figures. This allows anyone to modify these `.py` files and create their own version of the figures. 

* __Tikz code for all figure are located in the file `tikz_figures.tex`__.


#### Python scripts used to generate some of the figures
----------------------------------------

* Figure 2.3: draw_line_param.py
* Figure 2.4: draw_walsh_functions.py (requires the [fastwht](https://bitbucket.org/vegarant/fastwht/) library)
* Figure 3.6: draw_stripe_false_structure.py
* Figure 3.9: draw_dmd_grid.py
* Figure 5.1: draw_sampling_mat.py 
* Figure 18.1: draw_two_layer_network.py
* Figure 18.4: draw_imagenet_score.py
* Figure 18.9: draw_stripe_false_structure.py
* Figure 19.4: draw_architecture_U_net.py
* Figure 19.5: draw_architecture_automap.py
* draw_unstable_l1.py have not been used

----------------------------------------

Note that some of the scripts write the tex code directly to a file, while other scripts simply print the results in the terminal. In the latter case, on a UNIX system it can be useful to run the script using

```bash
python script_name.py > figures_tex_file/name_of_tikz_code.tex
```

This will write the resulting tex code directly to the file `figures_tex_file/name_of_tikz_code.tex`.

