clear;clc;close all;
fs=600;
datanumber=6*fs;
%generate freqeuncy array
f=[17.14 15 13.33 12 10.9];
%generate t
t=(1:datanumber).*(1/fs);
%initial y
y=zeros(length(f),datanumber);
%trial number
trialnumber=9;
%generate ssvepdata and timedata
ssvepdata=zeros(length(f),trialnumber,1,datanumber);
timedata=zeros(length(f),trialnumber,datanumber);
ytemp=zeros(1,datanumber);
for k=1:length(f)
    for i=1:trialnumber
    %generate A
    A=rand(1,length(f));
    %change A
    Atemp=A;
    Atemp(k)=1.1;
    %generate phase
    phi=rand(1).*(2*pi);
    %generate y
    for m=1:length(f)
        y(m,:)=sin(2*pi*f(m).*t+phi);
    end
    ytemp=Atemp*y;
    %generate result
    ssvepdata(k,i,:,:)=ytemp;
    timedata(k,i,:)=t;
    end
end
%save result
save('t_processed','ssvepdata','timedata');
clear;clc;close all;