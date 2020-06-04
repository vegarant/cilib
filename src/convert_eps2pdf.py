"""
This search for eps files in all directories below this directory and convert 
eps files to pdf files. It works on UNIX systems where the `epstopdf` command
is installed. 
"""
from __future__ import print_function;
import os;
from os.path import join, getmtime;
from math import floor;

root_dir, file_name = os.path.split(os.path.realpath(__file__));

for dir_name, sud_dir_list, fname_list in os.walk(root_dir):

    # Find all .eps files
    fname_eps_files_list = [];
    fname_pdf_files_list = [];
    for fname in fname_list:
        if fname[-4:] == '.eps':
            fname_eps_files_list.append(fname);
        elif fname[-4:] == '.pdf':
            fname_pdf_files_list.append(fname);
    for fname in fname_eps_files_list:
        fname_core = fname[:-4];
        
        fname_eps = join(dir_name, fname);
        fname_pdf = join(dir_name, fname_core + '.pdf');
        if fname_core+'.pdf' in fname_pdf_files_list: # Check last time modified
            
            mod_time_eps = int(floor(getmtime(fname_eps)/10));
            mod_time_pdf = int(floor(getmtime(fname_pdf)/10));
            fname_eps = fname_eps.replace(' ', r'\ ');
            fname_pdf = fname_pdf.replace(' ', r'\ ');
            if mod_time_eps != mod_time_pdf:
                command = 'epstopdf %s --outfile %s && touch %s' % (fname_eps,
                fname_pdf, fname_eps);
                command_print_version = 'epstopdf %s --outfile %s' % (fname_eps, fname_pdf);  
                print(command_print_version);
                os.system(command);
        else:
            fname_eps = fname_eps.replace(' ', r'\ ');
            fname_pdf = fname_pdf.replace(' ', r'\ ');
            command = 'epstopdf %s --outfile %s && touch %s' % (fname_eps,
            fname_pdf, fname_eps);
            command_print_version = 'epstopdf %s --outfile %s' % (fname_eps, fname_pdf);  
            print(command_print_version);
            os.system(command);
            
