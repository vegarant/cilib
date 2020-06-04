#### Scripts used to generate the figures.
-------------------------------------

* Figure 4.1: Show_gauss_patterns_different_levels.m
* Figure 4.2: Show_2d_MRI_patterns.m
* Figure 4.3: Show_different_walsh_patterns.m
* Figure 4.4: Compute_psnr_curve_fourier.m and Read_psnr_values_and_create_plot.m 
    * configs/config_psnr45.m
* Figure 4.5: Compute_psnr_curve_fourier.m and Read_psnr_values_and_create_plot.m 
    * configs/config_psnr46.m
    * configs/config_psnr47.m
    * configs/config_psnr48.m
* Figure 4.6: Show_gaussian_fourier_sampling_maps.m 
* Figure 4.7: Compute_psnr_curve_walsh.m and Read_psnr_values_and_create_plot.m 
    * configs/config_psnr51.m
	* configs/config_psnr52.m
	* configs/config_psnr53.m
* Figure 4.8: Show_walsh_DAS_DIS.m
* Figure 4.9: Compare_resolutions.m 
* Figure 4.10: Sample_brain_text_comparison.m
* Figure 4.11: Cont_radon_example.m
* Figure 4.12: Compare_sparsifying_transforms_fourier.m 
* Figure 4.13: Compare_reweighting.m and Demo_create_image_crop.m

-------------------------------------

#### Scripts producing figures which were not used
-------------------------------------

* Demo_visualize_patterns.m 

-------------------------------------

#### Color styles
When generating the PSNR vs sampling rate plots for Figures 4.4, 4.5 and 4.7,
we have tried to use the following color conventions for the different sampling 
patterns. This makes it easy to see which pattern each line is.

* DAS       - yellow
* DIS       - red
* 2 level   - green
* Exp l2    - blue
* Exp l_inf - cyan
* Exp l_1   - magenta
* Exp l_0.5 - brown 
* Power law - black, light green

