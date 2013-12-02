clear;clc;close all;
fs=600;
datanumber=6*fs;
%generate freqeuncy array
f=[17.14 15 13.33 12 10.9];
%generate t
t=(1:datanumber).*(1/fs);
%initial y
y=zeros(length(f),datanumber);
%generate ssvepdata and timedata
ssvepdata=zeros(1,1,1,datanumber);
timedata=zeros(1,1,datanumber);
timedata(1,1,:)=t;
ytemp=zeros(1,datanumber);
%amplitude
A=[2 1 1 1 1];
%phase
P=[pi/4 pi/2 3*pi/4 pi 5*pi/4];
 %generate y
 for m=1:length(f)
     y(m,:)=A(m).*sin(2*pi*f(m).*t+P(m));
 end
 y=sum(y);
 ssvepdata(1,1,1,:)=y;
%save result
save('normal_data_diff_fix_phase_processed','ssvepdata','timedata');
clear;clc;close all;