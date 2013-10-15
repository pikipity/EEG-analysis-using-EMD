% Conver 1a, 2a and 3a or 1b, 2b and 3b to two big data matrixes.
% Two matrix construct:
%    1. ssvepdata will contan the data of ssvep signal
%              [5 frequencies, 9 trials, 14 channels, 3600 data]
%    2. timedata will contain time for every data
%              [5 frequency, 9 trials, 3600data] 
clear;clc;close all;
%file name
file=2;
if(file==1)
    dataname=['ssvep_20110824_wcm_1a'
                       'ssvep_20110824_wcm_2a'
                       'ssvep_20110824_wcm_3a'];
else
    dataname=['ssvep_20110824_wcm_1b'
                      'ssvep_20110824_wcm_2b'
                     'ssvep_20110824_wcm_3b'];
end
%initial some variables
Fs=600;%sampling frequency
thresholdvalue=25000;%use it for finding sampling point
samplesub=6*Fs;%sampling pints number
waitsub=4*Fs;%waiting point number
beginningignore=6*Fs;%At the beginning, some point need to be ignored.
ssvepdata=zeros(5,9,14,3600);%ssvep data matrix
timedata=zeros(5,9,3600);%ssvep data materix
triallabel=[1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
                 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
                 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5];%trial label matrix
trialnumber=ones(5,1);%trial number matrix
%begin to split data
for i=1:size(dataname,1)
    %load data
    load(dataname(i,:));
    %get all sampling data x value
    triglabel=find(y(end,:)>thresholdvalue);
    triglabel=triglabel(triglabel>beginningignore);
    %find the beginning point of sampling
    pos=triglabel(1+find((triglabel(2:end)-triglabel(1:end-1))>waitsub));
    pos=[triglabel(1) pos];
    for k=1:length(pos)
        %get freqeuncy number
        frequencynum=triallabel(i,k);
        trialno=trialnumber(frequencynum);
        trialnumber(frequencynum)=trialnumber(frequencynum)+1;
        %build ssvepdata
        ssvepdata(frequencynum,trialno,:,:)=y(2:end-1,pos(k):pos(k)+samplesub-1);
        %build timedata
        timedata(frequencynum,trialno,:)=y(1,pos(k):pos(k)+samplesub-1);
    end
end
%save data
save(strcat(dataname(1,end),'_processed'),'ssvepdata','timedata');
%clear all
clear;clc;

