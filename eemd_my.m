function allmode=eemd_my(Y,Nstd,NE)
xsize=length(Y);
dd=1:1:xsize;
%normalize original data
Ystd=std(Y);
Y=Y/Ystd;
%initial result
TNM=fix(log2(xsize))-1;
TNM2=TNM+2;
for kk=1:1:TNM2, 
    for ii=1:1:xsize,
        allmode(ii,kk)=0.0;
    end
end
%NE -- maximum loop number
for iii=1:1:NE,
    %generate white noise -- X1
    for i=1:xsize,
        temp=randn(1,1)*Nstd;
        X1(i)=Y(i)+temp;
    end
    %EMD -- IMF stored in mode
    for jj=1:1:xsize,
        mode(jj,1) = Y(jj);
    end
    
    temp=emd(X1)';
    mode(:,2:min(TNM2-1,size(temp,2))+1)=temp(:,1:min(TNM2-1,size(temp,2)));
    mode(:,(min(TNM2-1,size(temp,2))+2):TNM2)=0;
   %sum all IMF generated now
    allmode=allmode+mode;
    
end
%average value
allmode=allmode/NE;
%denormalize result
allmode=allmode*Ystd;