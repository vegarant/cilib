# Source code

In this directory you find all the source code for the CIlib project.

## Advice

Most of these scripts are not computationally heavy, and can be exectured in a few seconds og a few minutes. However, for a few of the script, more computations are needed.  In such cases, you might want to do the computations in the background and at a low priority. To do this on a UNIX system you can for instance type the following in the terminal

```bash
nohup nice -n 19 matlab --nodesktop -nosplash <path/to/matlab/file.m &>output_matlab.txt &
```
This will start matlab in the background at the lowest priority, so that you can still use the computer, almost unaffected. In the file `output_matlab.txt` you can track the progress of the computations. Do not edit the file `path/to/matlab/file.m` while the computations are running. This will make things crash. 

On some systems the matlab command does not work in the terminal. In such cases you need to locate the Matlab executable yourself. This file will typically lie inside the matlab installation files, in the directory `bin` and it has the name `matlab`.

