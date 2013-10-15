EEG analysis using EMD method
======================

In this project, EMD method will be used to do offline analysis of EEG signal. For EEG signal, I mainly focus on SSVEP signals.

## File Discription

### Experiment files

Experiment files include experiment discription file and data files:

1. Experiment discription file: an introduction of this experiment.

   + Internship Project.pdf
2. Data files: 

   + ssvep_20110824_wcm_1a.mat
   + ssvep_20110824_wcm_2a.mat
   + ssvep_20110824_wcm_3a.mat
   + ssvep_20110824_wcm_1b.mat
   + ssvep_20110824_wcm_2b.mat
   + ssvep_20110824_wcm_3b.mat
   
   They are matlab files. They include experiment data. If you want to know what they are, please reference experiment discription file above. 

   You can directly use ```load()``` function to load them in Matlab. After load them into Matlab, there are four variables which are loaded. But only ```y``` and ```yy``` contain all informations which you may want to know. And they are same. You can use one of them to do analysis. They are 16\*XX matrixes (different file has different value for XX). The 1st row is time. Data for 14 channels are from 2nd row to 15th row. Data of one row are in one row. The 16th row are flashing signal data. Except data in 1st row, all unit of y axis is uV. The voltage of common EEG signal is from -100uV to 100uV. Some data maybe are anomalous. They need to be removed.
   
### Analysis files

Analysis files include matlab running files and analysis result files:

1. Matlab running files: 

   + Split_Data.m
   
     run this file to pre-process data file. Use it to process ssvep_20110824_wcm_1a.mat, ssvep_20110824_wcm_2a.mat and ssvep_20110824_wcm_3a.mat or ssvep_20110824_wcm_1b.mat, ssvep_20110824_wcm_2b.mat and ssvep_20110824_wcm_3b.mat. 

     It will split all data into one large materix according to their flashing frequency, trial number and channel number. And it will also split time into one large matrix according to their flashing frequency, trial number (Since different channel has the same time, time will not be splited according to time.). 
   
     After running it, a_processed.mat (for ssvep_20110824_wcm_1a.mat, ssvep_20110824_wcm_2a.mat and ssvep_20110824_wcm_3a.mat) or b_processed.mat (for ssvep_20110824_wcm_1b.mat, ssvep_20110824_wcm_2b.mat and ssvep_20110824_wcm_3b.mat) will be generated. Every file contains two large matrixes: ```ssvepdata``` and ```timedata```. For ```ssvepdata```, it is a 5\*9\*14\*3600 matrix. 5 means 5 different freqeuncies. 9 means 9 trials for one frequency. 14 means 14 channels for one trial and one frequency. 3600 means 3600 data for one trial, one frequency and one channel. For ```timedata```, it is 5\*9\*3600. The meanings of 5, 9 and 3600 are same as ```ssvepdata```.
   + emd_dot_analysis.m
   
     Use emd method to find the flashing freqeuncy for every data segment. 
2. Analysis result files

   + a_processed.m
   + b_processed.m
   
   They are results of Split_Data.m. Use them to do futher analysis.