%use FFT to analysis signal
%result: 1 matrix
%  frequency_result
%       [5 frequencies, 9 trials, 14 channels]  ->  frequency result from FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
%sampling frequency
fs=600;
%file which stores data and according to file name, get frequency
file=0;
if file==1
    filename='a_processed';
    f=[17.14 15 13.33 12 10.9];
    f_min=10;
    f_max=18;
elseif file==0
    filename='t_processed';
    f=[17.14 15 13.33 12 10.9];
    f_min=10;
    f_max=18;
elseif file==2
    filename='b_processed';
    f=[10 9.23 8.57 8 7.5];
    f_min=7;
    f_max=11;
end
%load data
load(filename);
%get variables
[frequencynumber,trialnumber,channelnumber,datanumber]=size(ssvepdata);
%initial result matrix
frequency_result=zeros(frequencynumber,trialnumber,channelnumber);
%according to data length, find fft length
NFFT=2^nextpow2(datanumber);
%frequency range
frange=fs/2*linspace(0,1,NFFT/2+1);
%get frequency number will be used
fnumber=intersect(find(frange>=f_min),find(frange<=f_max));
%cut frequency range
frangecut=frange(fnumber);
%begin to calculate
for frequency=1:frequencynumber
    for trial=1:trialnumber
        for channel=1:channelnumber
            %get data
            data=reshape(ssvepdata(frequency,trial,channel,:),1,datanumber);
            if(~isempty(find(data>100, 1)))%if there is a data which is larger than 100uV, this data must be ignored.
                frequency_result(frequency,trial,channel)=0;
            else%if data can be used
                %callculate fft result
                data=data-mean(data);
                fft_result=fft(data,NFFT)/datanumber;
                fft_result=2*abs(fft_result(1:NFFT/2+1));
                %get fft result that will be used
                fft_result=fft_result(fnumber);
                %find max value of fft frequency result
                fft_result_max= fft_result==max(fft_result);
                fft_result_max=frangecut(fft_result_max);
                %compare which frequency is close to this max value
                compare=ones(1,length(f)).*fft_result_max;
                compare=compare-f;
                 frequency_result(frequency,trial,channel)=find(abs(compare)==min(abs(compare)));
            end
        end
    end
end
%display result which contain error
f=1:length(f);
for k=1:length(f)
    Temp=reshape(frequency_result(k,:,:),trialnumber,channelnumber);
    [xx,yy]=find(Temp~=f(k));
    xxx=[];
    yyy=[];
    for xk=1:length(xx)
        if Temp(xx(xk),yy(xk))~=0
            xxx=[xxx,xx(xk)];
            yyy=[yyy,yy(xk)];
        end
    end
    if(~isempty(xxx))
        disp(strcat('frequency',int2str(k),'result: '));
        disp(reshape(frequency_result(k,:,:),trialnumber,channelnumber));
        disp(strcat('frequency',int2str(k),'Error position: '));
        disp([xxx' yyy']);
    end
end