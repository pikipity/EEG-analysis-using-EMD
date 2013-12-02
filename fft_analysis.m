%use FFT to analysis signal
%result: 1 matrix
%  frequency_result
%       [5 frequencies, 9 trials, 14 channels]  ->  frequency result from FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
%sampling frequency
fs=600;
%file which stores data and according to file name, get frequency
file=-2;
if file==1
    filename='a_processed';
    f=[17.14 15 13.33 12 10.9];
    f_min=10;
    f_max=18;
elseif file==0
    filename='normal_data_processed';
    f=[17.14];
    f_min=10;
    f_max=18;
elseif file==-1
    filename='normal_data_diff_fix_phase_processed';
    f=[17.14];
    f_min=10;
    f_max=18;
elseif file==-2
    filename='normal_data_diff_random_phase_processed';
    f=[17.14];
    f_min=10;
    f_max=18;
elseif file==2
    filename='b_processed';
    f=[10 9.23 8.57 8 7.5];
    f_min=7;
    f_max=11;
elseif file==3
    filename='c_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
    f_min=6;
    f_max=21;
elseif file==4
    filename='d_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
    f_min=6;
    f_max=21;
elseif file==5
    filename='e_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
    f_min=6;
    f_max=21;
elseif file==6
    filename='f_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
    f_min=6;
    f_max=21;
elseif file==7
    filename='g_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
    f_min=6;
    f_max=21;
end
tic
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
            data=reshape(ssvepdata(frequency,trial,channel,1:datanumber),1,datanumber);
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
run_time=toc;
%display result which contain error
f=1:length(f);
error_number=zeros(1,length(f));
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
        disp(strcat('frequency',int2str(k),'Error position (x,y): '));
        disp([xxx' yyy']);
        disp(strcat('frequency',int2str(k),'Error number: '));
        disp(length(xxx));
    end
    error_number(k)=length(xxx);
end
disp('Total error number:');
disp(sum(error_number));
disp('Total run time:');
disp(run_time);