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
%file which store data and according to file name, get frequency
file=2;
if file==1
    filename='a_processed';
    f=[17.14 15 13.33 12 10.9];
elseif file==0
    filename='normal_data_processed';
    f=[17.14];
elseif file==-1
    filename='normal_data_diff_fix_phase_processed';
    f=[17.14];
elseif file==-2
    filename='normal_data_diff_random_phase_processed';
    f=[17.14];
elseif file==2
    filename='b_processed';
    f=[10 9.23 8.57 8 7.5];
elseif file==3
    filename='c_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
elseif file==4
    filename='d_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
elseif file==5
    filename='e_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
elseif file==6
    filename='f_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
elseif file==7
    filename='g_processed';
    f=[20 15 10 8 7.5 17.14 13.33 12 8.57 6.67];
else
    error('File number error');
end
tic
%load data
load(filename);
%get variables
[frequencynumber,trialnumber,channelnumber,datanumber]=size(ssvepdata);
%intial result
max_b_x=zeros(frequencynumber,trialnumber,channelnumber);
max_b_y=zeros(frequencynumber,trialnumber,channelnumber);
frequency_result=zeros(frequencynumber,trialnumber,channelnumber);
 b_maxtrix=zeros(frequencynumber,trialnumber,channelnumber,length(f),9);
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
                IMF=eemd_my(data,0.1,10);
                IMF=IMF';
                IMF=IMF(2:end,:);
                %calculate h
                h=zeros(length(f),length(t));
                for k=1:length(f)
                    h(k,:)=exp(1j*2*pi*f(k).*t);
                end
                %calculate inner product of IMF and h of different frequencies
                b=abs(h*IMF');
                %reshape b to b_matrix
                if size(b,2)>=9
                    b_end=9;
                else
                    b_end=size(b,2);
                end
                b_maxtrix(frequency,trial,channel,:,1:b_end)=b(1:length(f),1:b_end);
                %reshape b to max_b_x and max_b_y
                [maxbx,maxby]=find(b==max(max(b)));
                max_b_x(frequency,trial,channel)=maxbx;
                max_b_y(frequency,trial,channel)=maxby;
            end
        end
    end
end
run_time=toc;
%get frequency_result
frequency_result=max_b_x;
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
        disp(strcat('frequency',int2str(k),'Error position: '));
        disp([xxx' yyy']);
        disp(strcat('frequency',int2str(k),'Error number: '));
        disp(length(xxx));
    end
    error_number(k)=length(xxx);
end
disp('Total error number:');
disp(sum(error_number));
disp('Total run time:')
disp(run_time)
disp('=====================================================')
for i=1:length(f)
    disp('Main frequency part in which IMF ( trial , channel ) :')
    disp(reshape(max_b_y(i,:,:),trialnumber,channelnumber));
end
                


