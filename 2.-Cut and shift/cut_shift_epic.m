function imageArr = image_average(directory)
b=450;
c=600;
k=c/5;
i = 0;
j=0;

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\Desktop\Simon & Aniela\output\Larger_area\First_axis_large');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end

fileName = files(1).name;
load([path fileName]);

acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\Simon & Aniela\\output\\Larger_area\\%.4d_%.2d_%.2d', ...
    acquiredate(1), ...
    acquiredate(2), ...
    acquiredate(3));    

folder_postfix = 1;
folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
while(exist(folder_name, 'dir'))
    folder_postfix = folder_postfix + 1;
    folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
end

mkdir(folder_name);

imageArr= zeros( [90,120,18,nFiles]);

for n = 1:nFiles
fileName = files(n).name;

load([path fileName]);

dpic=double(pic(:,:,:));
imageArr1=dpic/255;

imageArr1(end:450,:,:)=0;
imageArr1(:,end:600,:)=0;

% m = number of columns/number of averaged sets of data
% n = number of rows

% averaging in x-direction
for p=1:b;
    for m=0:k-1;
         
             
        i = (m*5) + 1;
        j= i+4;
      
        imageArr2(p,m+1,:)=mean(imageArr1(p,i:j,:));
        %imageArr1(:,n,m+1,:)=mean(imageArr1(:,n,i:j,:));
    
     
    end
 
end
%end with array 405 x 108 (x 36 photos)


%averaging in y-direction
ii = 0;
jj=0;
l=b/5;
for m=1:k;
    for p=0:l-1;
         
             
        ii = (p*5) + 1;
        jj= ii+4;
      
        imageArr3(p+1,m,:)=mean(imageArr2(ii:jj,m,:));
        
        %imageArr1(:,n+1,m,:)=mean(imageArr1(:,ii:jj,m,:));
    
     
    end
 
end
% end with an array 81 x 108 (x 36 photos)


pic=imageArr3;

filename = sprintf('%s\\pic_av_%.3d', folder_name, n);
save(filename, 'pic');

end



b=450;
c=600;
k=c/5;
i = 0;
j=0;

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\Desktop\Simon & Aniela\output\Larger_area\First_axis_large');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end

fileName = files(1).name;
load([path fileName]);

acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\Simon & Aniela\\output\\Larger_area\\%.4d_%.2d_%.2d', ...
    acquiredate(1), ...
    acquiredate(2), ...
    acquiredate(3));    

folder_postfix = 1;
folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
while(exist(folder_name, 'dir'))
    folder_postfix = folder_postfix + 1;
    folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
end

mkdir(folder_name);

imageArr= zeros( [90,120,18,nFiles]);

for n = 1:nFiles
fileName = files(n).name;

load([path fileName]);

dpic=double(pic(:,:,:));
imageArr1=dpic/255;

imageArr1(end:450,:,:)=1;
imageArr1(:,end:600,:)=1;

% m = number of columns/number of averaged sets of data
% n = number of rows

% averaging in x-direction
for p=1:b;
    for m=0:k-1;
         
             
        i = (m*5) + 1;
        j= i+4;
      
        imageArr2(p,m+1,:)=mean(imageArr1(p,i:j,:));
        %imageArr1(:,n,m+1,:)=mean(imageArr1(:,n,i:j,:));
    
     
    end
 
end
%end with array 405 x 108 (x 36 photos)


%averaging in y-direction
ii = 0;
jj=0;
l=b/5;
for m=1:k;
    for p=0:l-1;
         
             
        ii = (p*5) + 1;
        jj= ii+4;
      
        imageArr3(p+1,m,:)=mean(imageArr2(ii:jj,m,:));
        
        %imageArr1(:,n+1,m,:)=mean(imageArr1(:,ii:jj,m,:));
    
     
    end
 
end
% end with an array 81 x 108 (x 36 photos)


pic=imageArr3;

filename = sprintf('%s\\pic_av_%.3d', folder_name, n);
save(filename, 'pic');


end



b=450;
c=600;
k=c/5;
i = 0;
j=0;

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\Desktop\Simon & Aniela\output\Larger_area\+x_axis_large');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end

fileName = files(1).name;
load([path fileName]);

acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\Simon & Aniela\\output\\Larger_area\\%.4d_%.2d_%.2d', ...
    acquiredate(1), ...
    acquiredate(2), ...
    acquiredate(3));    

folder_postfix = 1;
folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
while(exist(folder_name, 'dir'))
    folder_postfix = folder_postfix + 1;
    folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
end

mkdir(folder_name);

imageArr= zeros( [90,120,18,nFiles]);

for n = 1:nFiles
fileName = files(n).name;

load([path fileName]);

dpic=double(pic(:,:,:));
imageArr1=dpic/255;

imageArr1(end:450,:,:)=0;
imageArr1(:,end:600,:)=0;

% m = number of columns/number of averaged sets of data
% n = number of rows

% averaging in x-direction
for p=1:b;
    for m=0:k-1;
         
             
        i = (m*5) + 1;
        j= i+4;
      
        imageArr2(p,m+1,:)=mean(imageArr1(p,i:j,:));
        %imageArr1(:,n,m+1,:)=mean(imageArr1(:,n,i:j,:));
    
     
    end
 
end
%end with array 405 x 108 (x 36 photos)


%averaging in y-direction
ii = 0;
jj=0;
l=b/5;
for m=1:k;
    for p=0:l-1;
         
             
        ii = (p*5) + 1;
        jj= ii+4;
      
        imageArr3(p+1,m,:)=mean(imageArr2(ii:jj,m,:));
        
        %imageArr1(:,n+1,m,:)=mean(imageArr1(:,ii:jj,m,:));
    
     
    end
 
end
% end with an array 81 x 108 (x 36 photos)


pic=imageArr3;

filename = sprintf('%s\\pic_av_%.3d', folder_name, n);
save(filename, 'pic');

end






b=450;
c=600;
k=c/5;
i = 0;
j=0;

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\Desktop\Simon & Aniela\output\Larger_area\+x_axis_large');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end

fileName = files(1).name;
load([path fileName]);

acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\Simon & Aniela\\output\\Larger_area\\%.4d_%.2d_%.2d', ...
    acquiredate(1), ...
    acquiredate(2), ...
    acquiredate(3));    

folder_postfix = 1;
folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
while(exist(folder_name, 'dir'))
    folder_postfix = folder_postfix + 1;
    folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
end

mkdir(folder_name);

imageArr= zeros( [90,120,18,nFiles]);

for n = 1:nFiles
fileName = files(n).name;

load([path fileName]);

dpic=double(pic(:,:,:));
imageArr1=dpic/255;

imageArr1(end:450,:,:)=1;
imageArr1(:,end:600,:)=1;

% m = number of columns/number of averaged sets of data
% n = number of rows

% averaging in x-direction
for p=1:b;
    for m=0:k-1;
         
             
        i = (m*5) + 1;
        j= i+4;
      
        imageArr2(p,m+1,:)=mean(imageArr1(p,i:j,:));
        %imageArr1(:,n,m+1,:)=mean(imageArr1(:,n,i:j,:));
    
     
    end
 
end
%end with array 405 x 108 (x 36 photos)


%averaging in y-direction
ii = 0;
jj=0;
l=b/5;
for m=1:k;
    for p=0:l-1;
         
             
        ii = (p*5) + 1;
        jj= ii+4;
      
        imageArr3(p+1,m,:)=mean(imageArr2(ii:jj,m,:));
        
        %imageArr1(:,n+1,m,:)=mean(imageArr1(:,ii:jj,m,:));
    
     
    end
 
end
% end with an array 81 x 108 (x 36 photos)


pic=imageArr3;

filename = sprintf('%s\\pic_av_%.3d', folder_name, n);
save(filename, 'pic');


end





b=450;
c=600;
k=c/5;
i = 0;
j=0;

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\Desktop\Simon & Aniela\output\Larger_area\+y_axis_large');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end

fileName = files(1).name;
load([path fileName]);

acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\Simon & Aniela\\output\\Larger_area\\%.4d_%.2d_%.2d', ...
    acquiredate(1), ...
    acquiredate(2), ...
    acquiredate(3));    

folder_postfix = 1;
folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
while(exist(folder_name, 'dir'))
    folder_postfix = folder_postfix + 1;
    folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
end

mkdir(folder_name);

imageArr= zeros( [90,120,18,nFiles]);

for n = 1:nFiles
fileName = files(n).name;

load([path fileName]);

dpic=double(pic(:,:,:));
imageArr1=dpic/255;

imageArr1(end:450,:,:)=0;
imageArr1(:,end:600,:)=0;

% m = number of columns/number of averaged sets of data
% n = number of rows

% averaging in x-direction
for p=1:b;
    for m=0:k-1;
         
             
        i = (m*5) + 1;
        j= i+4;
      
        imageArr2(p,m+1,:)=mean(imageArr1(p,i:j,:));
        %imageArr1(:,n,m+1,:)=mean(imageArr1(:,n,i:j,:));
    
     
    end
 
end
%end with array 405 x 108 (x 36 photos)


%averaging in y-direction
ii = 0;
jj=0;
l=b/5;
for m=1:k;
    for p=0:l-1;
         
             
        ii = (p*5) + 1;
        jj= ii+4;
      
        imageArr3(p+1,m,:)=mean(imageArr2(ii:jj,m,:));
        
        %imageArr1(:,n+1,m,:)=mean(imageArr1(:,ii:jj,m,:));
    
     
    end
 
end
% end with an array 81 x 108 (x 36 photos)


pic=imageArr3;

filename = sprintf('%s\\pic_av_%.3d', folder_name, n);
save(filename, 'pic');



end




b=450;
c=600;
k=c/5;
i = 0;
j=0;

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\Desktop\Simon & Aniela\output\Larger_area\+y_axis_large');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end

fileName = files(1).name;
load([path fileName]);

acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\Simon & Aniela\\output\\Larger_area\\%.4d_%.2d_%.2d', ...
    acquiredate(1), ...
    acquiredate(2), ...
    acquiredate(3));    

folder_postfix = 1;
folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
while(exist(folder_name, 'dir'))
    folder_postfix = folder_postfix + 1;
    folder_name = sprintf('%s__%.2d', folder_base, folder_postfix);
end

mkdir(folder_name);

imageArr= zeros( [90,120,18,nFiles]);

for n = 1:nFiles
fileName = files(n).name;

load([path fileName]);

dpic=double(pic(:,:,:));
imageArr1=dpic/255;

imageArr1(end:450,:,:)=1;
imageArr1(:,end:600,:)=1;

% m = number of columns/number of averaged sets of data
% n = number of rows

% averaging in x-direction
for p=1:b;
    for m=0:k-1;
         
             
        i = (m*5) + 1;
        j= i+4;
      
        imageArr2(p,m+1,:)=mean(imageArr1(p,i:j,:));
        %imageArr1(:,n,m+1,:)=mean(imageArr1(:,n,i:j,:));
    
     
    end
 
end
%end with array 405 x 108 (x 36 photos)


%averaging in y-direction
ii = 0;
jj=0;
l=b/5;
for m=1:k;
    for p=0:l-1;
         
             
        ii = (p*5) + 1;
        jj= ii+4;
      
        imageArr3(p+1,m,:)=mean(imageArr2(ii:jj,m,:));
        
        %imageArr1(:,n+1,m,:)=mean(imageArr1(:,ii:jj,m,:));
    
     
    end
 
end
% end with an array 81 x 108 (x 36 photos)


pic=imageArr3;

filename = sprintf('%s\\pic_av_%.3d', folder_name, n);
save(filename, 'pic');

end





