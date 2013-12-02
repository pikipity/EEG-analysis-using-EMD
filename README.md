EEG analysis using EMD method
======================

In this project, EMD method will be used to do offline analysis of EEG signal. For EEG signal, I mainly focus on SSVEP signals.

## File Discription

### Experiment files

Experiment files include experiment discription file and data files. There are two kinds of experiment data. One is from "The University of Macao" in the "UM" folder. The other is from the other School.

For "UM" data:

+ Experiment discription file: an introduction of this experiment.

   - Internship Project.pdf
+ Data files: 

   - ssvep_20110824_wcm_1a.mat
   - ssvep_20110824_wcm_2a.mat
   - ssvep_20110824_wcm_3a.mat
   - ssvep_20110824_wcm_1b.mat
   - ssvep_20110824_wcm_2b.mat
   - ssvep_20110824_wcm_3b.mat
   
   You can directly use ```load()``` function to load them in Matlab. After load them into Matlab, there are four variables which are loaded. But only ```y``` and ```yy``` contain all informations which you may want to know. And they are same. You can use one of them to do analysis. They are 16\*XX matrixes (different file has different value for XX). The 1st row is time. Data for 14 channels are from 2nd row to 15th row. Data of one channel are in one row. The 16th row are flashing sychrnous signal data which has a impulse when the screen begins to flash. Except data in 1st row, all unit of y axis is uV. The voltage of common EEG signal is from -100uV to 100uV. Some data maybe are anomalous. They need to be removed.

   Those data cannot be used directly for analysis files. Use ```Split_Data.m``` to split all data.
   
For other school data:

- c_processed.mat
- d_processed.mat
- e_processed.mat
- f_processed.mat
- g_processed.mat

Those data can be used directly for analysis files.
   
### Analysis files

Analysis files include matlab running files, analysis result files and test data genrate file:

+ Matlab running files: 

   - Split_Data.m
   
     run this file to pre-process data file. Use it to process ssvep_20110824_wcm_1a.mat, ssvep_20110824_wcm_2a.mat and ssvep_20110824_wcm_3a.mat or ssvep_20110824_wcm_1b.mat, ssvep_20110824_wcm_2b.mat and ssvep_20110824_wcm_3b.mat. 

     It will split all data into one large materix according to their flashing frequency, trial number and channel number. And it will also split time into one large matrix according to their flashing frequency, trial number (Since different channel has the same time, time will not be splited according to time.). 
   
     After running it, a_processed.mat (for ssvep_20110824_wcm_1a.mat, ssvep_20110824_wcm_2a.mat and ssvep_20110824_wcm_3a.mat) or b_processed.mat (for ssvep_20110824_wcm_1b.mat, ssvep_20110824_wcm_2b.mat and ssvep_20110824_wcm_3b.mat) will be generated. Every file contains two large matrixes: ```ssvepdata``` and ```timedata```. For ```ssvepdata```, it is a 5\*9\*14\*3600 matrix. 5 means 5 different freqeuncies. 9 means 9 trials for one frequency. 14 means 14 channels for one trial and one frequency. 3600 means 3600 data for one trial, one frequency and one channel. For ```timedata```, it is 5\*9\*3600. The meanings of 5, 9 and 3600 are same as ```ssvepdata```.
   - emd_my__dot_analysis.m
   
     Use emd method and inner product with IMFs and flahing frequency sinusoidal signal to find the flashing freqeuncy for every data segment. The emd matlab program is writed by G. Rilling. It is not included in this project. You can download it from [http://perso.ens-lyon.fr/patrick.flandrin/emd](http://perso.ens-lyon.fr/patrick.flandrin/emd).
   - emd_dot_analysis.m

     This program is the same with ```emd_my_dot_analysis.m```. But use the eemd program which is inside this project for emd Matlab program.
   - eemd_my_dot_analysis.m
   
     This program is the same with ```emd_my_dot_analysis.m```. The only difference is to use eemd method to replace emd method. The emd program is still the program writen by G. Rilling.
   - eemd_dot_analysis.m  

     This program is the same with ```eemd_my_doy_analysis.m```. The only difference is to use eemd program which is inside this project to replace the emd program written by G. Rilling.
   - fft_analysis.m
   
     Use fast Fourier transform to find the flashing frequency for every data segment
+ test data generate file

  - test_data_generate.m

    ***This data will not be used in the Matlab running files.*** Use the combination of sine waveforms to genrate some testing data to test the EMD method and fft method for ideal signals. The testing data will be stored in t_processed.mat. The data arrangement is the same as a_processed.mat and b_processed.mat. There are 5 frequencies and 9 trials but only 1 channel.
  
    The combination of sine waveforms is shown below.
    
    s=A1\*sin(2\*pi\*f1\*t+phase1)+A2\*sin(2\*pi\*f2\*t+phase2)+A3\*sin(2\*pi\*f3\*t+phase3)+A4\*sin(2\*pi\*f4\*t+phase4)+A5\*sin(2\*pi\*f5\*t+phase5)
    
    f1, f2, f3, f4 and f5 are 17.14Hz, 15Hz, 13.33Hz, 12Hz and 10.9Hz.
    
    A1, A2, A3, A4 and A5 are amplitudes. Values are random from 0 to 1. But for different frequency experiment, the corresponding amplitude will be 1.1.
    
    phase1, phase2, phase3, phase4 and phase5 are phases. Values are random from 0 to 2*pi 
  - normal_data_generate.m
  
    It will generate the ```normal_data_processed.mat```. It is a linear combination of five sine waves:

    s=A1\*sin(2\*pi\*f1\*t)+A2\*sin(2\*pi\*f2\*t)+A3\*sin(2\*pi\*f3\*t)+A4\*sin(2\*pi\*f4\*t)+A5\*sin(2\*pi\*f5\*t)
    
    A1=2. A2, A3, A4, A5=1.
    
    f1, f2, f3, f4 and f5 are 17.14Hz, 15Hz, 13.33Hz, 12Hz and 10.9Hz.
  - normal_data_generate_diff_fix_phase.m
  
    It will generate the ```normal_data_diff_fix_phase_processed.mat```. It is a linear combination of five sine waves with fixed phase difference:

    s=A1\*sin(2\*pi\*f1\*t+p1)+A2\*sin(2\*pi\*f2\*t+p2)+A3\*sin(2\*pi\*f3\*t+p3)+A4\*sin(2\*pi\*f4\*t+p4)+A5\*sin(2\*pi\*f5\*t+p5)
    
    A1=2. A2, A3, A4, A5=1.
    
    f1, f2, f3, f4 and f5 are 17.14Hz, 15Hz, 13.33Hz, 12Hz and 10.9Hz.
    
    p1, p2, p3, p4 and p5 are pi/4, pi/2, 3\*pi/4, pi and 5\*pi/4.
  - normal_data_generate_diff_random_phase.m
  
    It will generate the ```normal_data_diff_random_phase_processed.mat```. It is a linear combination of five sine waves with random phase difference:

    s=A1\*sin(2\*pi\*f1\*t+p1)+A2\*sin(2\*pi\*f2\*t+p2)+A3\*sin(2\*pi\*f3\*t+p3)+A4\*sin(2\*pi\*f4\*t+p4)+A5\*sin(2\*pi\*f5\*t+p5)
    
    A1=2. A2, A3, A4, A5=1.
    
    f1, f2, f3, f4 and f5 are 17.14Hz, 15Hz, 13.33Hz, 12Hz and 10.9Hz.
    
    p1, p2, p3, p4 and p5 are random values. For different time, they will have different values. The random range is from 0 to 2\*pi.
