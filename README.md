# CIlib - A software library for compressive imaging 

This repository contains a broad set of functions and tools for experimenting with various compressive imaging reconstruction techniques. It is meant as a companion to the book  _[Compressive imaging: Structure, Sampling, Learning](https://www.compressiveimagingbook.com)_ by Ben Adcock and Anders C. Hansen (Cambridge University Press, 2020), and can be used to reproduce most of the figures presented in the book. The code has been developed by Vegard Antun (see acknowledgement section for details).

## Getting started

### Paths, data, and default values
As with any toolbox in MatLab it is important to add the right paths to your MatLab session. To do this automatically when starting MatLab, you can try to run the `install_cilib.m` file. This script will locate your `startup.m` file, and append the necessary lines to this file. If not, you can also manually add the necessary paths by running the lines below.
```python
path_to_cilib_dir = pwd;
addpath(fullfile(path_to_cilib_dir, 'src', 'samp_patt'));
addpath(fullfile(path_to_cilib_dir, 'src', 'utils'));
addpath(fullfile(path_to_cilib_dir, 'src', 'var'));
clear path_to_cilib_dir
```
Make sure to modify the `pwd` argument if you are not running this from the CIlib directory.

The test images used in the figures can be downloaded [here](https://www.mn.uio.no/math/english/people/aca/vegarant/cilib_data.zip) (347 MB).

To ensure that font sizes, colours etc., are consistent between all the figures, we define a set of default variables in `etc/set_defaults.m`. This file will create the file 'var/cilib_defaults.mat', with the chosen default parameters. This file is read by all scripts producing figures for the book. Thus to run the code successfully, it is required to run the `set_defaults.m` file once, to produce the file `cilib_defaults.mat`. Make sure you you modify the `cil_dflt.data_path` in the `set_defaults.m` file, so that it points to the directory with the test images.  

### Dependencies
It is required to install the following packages.

* [SPGL1](http://www.cs.ubc.ca/~mpf/spgl1/) A solver for large-scale sparse reconstruction
* [NESTA](http://statweb.stanford.edu/~candes/nesta/) A Fast and Accurate First-order Method for Sparse Recovery (in particular TV minimization).
* [Fastwht](https://bitbucket.org/vegarant/fastwht/) A fast implementation of
  of matlabs `fwht`-function (Optional, but recommended).
* [ShearLab](http://www3.math.tu-berlin.de/numerik/www.shearlab.org/) 
    Shearlets (ShearLab3D v1.1)
* [CurveLab](http://www.curvelet.org) Curvelets (CurveLab 2.1.3)
* [ShearletReweighting](https://github.com/jky-ma/ShearletReweighting) Iterative reweighing strategy described in Chapter 4.6.

### Note on wavelet boundary handling
By default, MatLab does not use periodic wavelets. For all the scripts in this library, it is assumed that the periodic wavelet extension is used. Thus many of the scripts call the function `dwtmode('per', 'nodisp')`, which changes the default wavelet extension in a MatLab session without notifying the user. Be aware of this behaviour, and explicitly change the wavelet extension back again if required.

## Overview of the code

All the code is located in the `src` directory. Within this directory, we find the following directories. 

* __src/utils__: Contain all functions used to create the figures
* __src/samp_patt__: Contain code to generate all the sampling patterns.
* __src/misc__: Code from various other toolboxes.
* __src/chX__: Code to generate figures in chapter __X__. See the `README.md` file within each directory for details on which figure the scripts create. 


## Citing 

To cite the book, please use
```
@book{adcock2020compressive,
	Author = {Ben Adcock and Anders C. Hansen},
	Publisher = {Cambridge University Press},
	Title = {Compressive Imaging: Structure, Sampling, Learning},
	Year = {2020}
}
```
and to cite the code, please use
```
@misc{CIlib,
	Author = {Vegard Antun},
	Year = {2020},
	Title = {{CI}lib --  A software library for compressive imaging},
	note = {https://github.com/vegarant/cilib},
}
```

## Acknowledgments
First and foremost, I need to thank Ben Adcock and Anders Hansen, without whom this code would never have existed. It has taken numerous iterations back and forth between the three of us to produce the desired images for the book. I would like to thank Kristian Monsen Haug, for coding up the backend used for all of the multilevel Gaussian sampling patterns. I want to thank Edvard Aksnes, for coding up functions to reorder wavelet coefficients and the first version of the scripts producing Figures 1.3 and 4.10. Initially, I planned to host this code its own webpage. A few years ago, Mathias Lohne, therefore, created a skeleton for such a webpage from scratch. In the end, I decided it was easier and better to use Github, but I would like to thank Mathias for the effort he put into this. 


