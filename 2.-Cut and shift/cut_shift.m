function imageArr = intensity2characparams(directory)
% imageArr(:,:,:,:,1) = intensity2characparams();
% imageArr(:,:,:,:,1) = intensity2characparams('c:\imagebank\2011_03_07__03');

if nargin == 0
    % directory with intensity files
    directory = uigetdir('C:\Bill\ImageBank\hlc3a3data\2015_04_23__01');
end

if directory(end) ~= filesep
    path = [directory filesep];
end

files = dir([path '*.mat']);
nFiles = length(files);

if nFiles == 0
    error('No .mat files found')
end


% load first file to get dimensions (one var called pic):
fileName = files(1).name;
load([path fileName]);

% only one axis of rotation for now
%imageArr = zeros(3, size(pic,1), size(pic,2), nFiles);

    warning(['Assuming low res and cropping pic. ' ...
        'TODO: figure out how to make thor driver notice subsampling']);
    % NOTE: see also pic cropping below

% we require mod(height,3) == 0:
% and height:width = 3:4

%imageArr = zeros(3, 120, 160, nFiles);

pic=zeros(382,496,18,'uint8');

%disp('Warning: using new (non-Hui) folder format to save data');
acquiredate=clock;
folder_base = sprintf('C:\\Bill\\Desktop\\A+D\\hlc3\\c3a3crop', ...
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

r= 9.2195;
%Put angles in radians!!!
theta= 0.2186689;
acquiredate=clock;


%mkdir('C:\Documents and Settings\Bill\Desktop\Simon & Aniela\output',[int2str(acquiredate(1)),'_',int2str(acquiredate(2)),'_',int2str(acquiredate(3))]);

for n=1:nFiles
    
    nrad=(n-1)*pi/180;
    
    a= 592 + r*sin(theta+(nrad)) - 181.5; % from 90 and 270 image, work out centre of plate. use maximum size of cube to determine
                                 % start and end points of x values.
   
    c=round(a);
    
    b= 592 + r*sin(theta+(nrad)) + 181.5;
    
    d=round(b);
    
    fileName = files(n).name;
    
    load([path fileName]);
   
    pic = pic(50:323,c:d,:);
    

acquiredate=clock;

%save(['C:\Documents and Settings\Bill\Desktop\Simon & Aniela\output\',int2str(acquiredate(1)),'_',int2str(acquiredate(2)),'_',int2str(acquiredate(3)),'\pic_',int2str(n),],'pic')

filename = sprintf('%s\\pic_%.3d', folder_name, n);
save(filename, 'pic');
end

%for n = 1:nFiles


    % conains one variable called pic

    
    %characParams = characH(pic);

    % TODO: confirm this
    % characH returns h*w*3 array where the 3 are
    %  retardation = 2delta
    %  primary angle
    %  difference of angles (secondary - primary)

    % we want
    %  sin(ret) * cos(primary + secondary)
    %  sin(ret) * sin(primary + secondary)
   % retardation = characParams(:,:,1);
   % primary = characParams(:,:,2);
   % difference = characParams(:,:,3);

   % secondary = primary + difference;

  %  imageArr(1,:,:,n) = sin(retardation) .* cos(primary + secondary);
   % imageArr(2,:,:,n) = sin(retardation) .* sin(primary + secondary);
   % imageArr(3,:,:,n) = -imageArr(1,:,:,n);
%end
