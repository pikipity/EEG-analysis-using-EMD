%use dot analysis method to analysis data by using emd method.
%b=dot(IMF(i),h)  h=exp(j*2*pi*f)   max_b should be with h of fos
%result: four matrix
%  1. max_b_x:
%       [5 frequencies, 9 trials, 14 channels] -> maximum b x coordinate
%  1. max_b_y:
%       [5 frequencies, 9 trials, 14 channels] -> maximum b y coordinate
%  2. b_matrix
%       [5 frequencies, 9 trials, 14 channels, b matrix]
%  3. frequency_result
%       [5 frequencies, 9 trials, 14 channels] -> frequency result from b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
%file which store data
file=0;
if file==1
    filename='a_processed';
elseif file==0
    filename='t_processed';
elseif file==2
    filename='b_processed';
else
    error('File number error');
end
%according to file name, get frequency
if(strcmp(filename,'a_processed'))
    f=[17.14 15 13.33 12 10.9];
elseif strcmp(filename,'t_processed')
    f=[17.14 15 13.33 12 10.9];
elseif strcmp(filename,'b_processed')
    f=[10 9.23 8.57 8 7.5];
else
    error('File error');
end
%load data
load(filename);
%get variables
[frequencynumber,trialnumber,channelnumber,datanumber]=size(ssvepdata);
%intial result
max_b_x=zeros(frequencynumber,trialnumber,channelnumber);
max_b_y=zeros(frequencynumber,trialnumber,channelnumber);
frequency_result=zeros(frequencynumber,trialnumber,channelnumber);
 b_maxtrix=zeros(frequencynumber,trialnumber,channelnumber,5,9);
 %begin to calculate
for frequency=1:frequencynumber
    for trial=1:trialnumber
        for channel=1:channelnumber
            %get data
            data=reshape(ssvepdata(frequency,trial,channel,:),1,datanumber);
            if(~isempty(find(data>100, 1)))%if there is a data which is larger than 100uV, this data must be ignored.
                max_b_x(frequency,trial,channel)=0;
                max_b_y(frequency,trial,channel)=0;
                frequency_result(frequency,trial,channel)=0;
            else%if data can be used
                %reshape time to one row matrix
                t=reshape(timedata(frequency,trial,:),1,datanumber);
                %calculate IMF
                IMF=emd(data);
                %calculate h
                h=zeros(length(f),length(t));
                for k=1:length(f)
                    h(k,:)=exp(1j*2*pi*f(k).*t);
                end
                %calculate inner product of IMF and h of different frequencies
                b=h*IMF';
                %reshape b to b_matrix
                if size(b,2)>=9
                    b_end=9;
                else
                    b_end=size(b,2);
                end
                b_maxtrix(frequency,trial,channel,:,1:b_end)=b(1:5,1:b_end);
                %reshape b to max_b_x and max_b_y
                [maxbx,maxby]=find(b==max(max(b)));
                max_b_x(frequency,trial,channel)=maxbx;
                max_b_y(frequency,trial,channel)=maxby;
            end
        end
    end
end
%get frequency_result
frequency_result=max_b_x;
%display result which contain error
f=1:5;
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
                


