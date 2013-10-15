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
clear;clc;close all;
%file which store data
file=1;
if file==1
    filename='a_processed';
else
    filename='b_processed';
end
%according to file name, get frequency
if(filename=='a_processed')
    f=[17.14 15 13.33 12 10.9];
else
    f=[10 9.23 8.57 8 7.5];
end
%load data
load(filename);
%get variables
[frequencynumber,trialnumber,channelnumber,datanumber]=size(ssvepdata);
%intial result
max_b_x=zeros(frequencynumber,trialnumber,channelnumber);
max_b_y=zeros(frequencynumber,trialnumber,channelnumber);
frequency_reuslt=zeros(frequencynumber,trialnumber,channelnumber);
 b_maxtrix=zeros(frequencynumber,trialnumber,channelnumber,5,9);
for frequency=1:frequencynumber
    for trial=1:trialnumber
        for channel=1:channelnumber
            %get data
            data=reshape(ssvepdata(frequency,trial,channel,:),1,datanumber);
            if(~isempty(find(data>100, 1)))%if there is a data which is larger than 100uV, this data must be ignored.
                max_b_x(frequency,trial,channel)=0;
                max_b_y(frequency,trial,channel)=0;
                frequency_reuslt(frequency,trial,channel)=0;
            else
                t=reshape(timedata(frequency,trial,:),1,datanumber);
                IMF=emd(data);
                for k=1:length(f)
                    h=exp(1j*2*pi*f(k).*t);
                    for i=1:size(IMF,1)
                        b(k,i)=abs(dot(IMF(i,:),h));
                    end
                end
                b_maxtrix(frequency,trial,channel,:,:)=b(1:5,1:9);
                [maxbx,maxby]=find(b==max([max(b(1,:)),max(b(2,:)),max(b(3,:)),max(b(4,:)),max(b(5,:))]));
                max_b_x(frequency,trial,channel)=maxbx;
                max_b_y(frequency,trial,channel)=maxby;
                frequency_reuslt(frequency,trial,channel)=maxbx;
            end
        end
    end
end
                


