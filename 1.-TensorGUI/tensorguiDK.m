     %%ImaqGUI edited hy H Yang for EPSRC project "Tensor tomography"

function varargout = tensorguiDK(varargin)
% TENSORGUIDK M-file for tensorguiDK.fig
%      TENSORGUIDK, by itself, creates a new TENSORGUIDK or raises the existing
%      singleton*.
%
%      H = TENSORGUIDK returns the handle to a new TENSORGUIDK or the handle to
%      the existing singleton*.
%
%      TENSORGUIDK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TENSORGUIDK.M with the given input arguments.
%
%      TENSORGUIDK('Property','Value',...) creates a new TENSORGUIDK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tensorgui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tensorguiDK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tensorguiDK_OpeningFcn, ...
                   'gui_DeleteFcn', @tensorgui_DeleteFcn, ...
                   'gui_OutputFcn',  @tensorguiDK_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before tensorguiDK is made visible.
function tensorguiDK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tensorguiDK (see VARARGIN)

%***************************************************
%initialization global para%
%clear all

% qqDS
handles.xpixel=1280; %640; %1024;
handles.ypixel=1024; %480; %768;
handles.rvdegree=1; % either 1 or 90 (S&A)
handles.urmdegree=20; % either 20 or 360 (S&A)
handles.ratio=0.5;

%%To create a video input object
% reset video
[handles.vid.cam,handles.vid.I] = openCamera;
%    'C:\Documents and Settings\Bill\desktop\test_params_lowres.ini');
%loadParameters(handles.vid.cam,     'C:\Bill\Desktop\Dejan\AS_param_2.ini'); %DK
loadParameters(handles.vid.cam,     'AS_param_2.ini'); 
handles.vid.selectedCamera = 1;
handles.vid.cam
image_size = get_Image_Size_DK2(handles.vid.cam);  %DK
handles.xsize = image_size(1)
handles.ysize = image_size(2) 

% handles.vid = videoinput('dcam',1,'Y8_1024x768');%Sheffield lab
% %handles.vid = videoinput('winvideo',1);%Loughborough home
% 
% %To start the object
% start(handles.vid);
% 
% %To initial video source
% set(getselectedsource(handles.vid),'GainMode','manual');
% set(getselectedsource(handles.vid),'Gain',384);
% set(getselectedsource(handles.vid),'ShutterMode','manual');
% %set(getselectedsource(handles.vid),'ShutterControl','absolute');
% %set(getselectedsource(handles.vid),'Shutter',90);
% %set(getselectedsource(handles.vid),'ShutterAbsolute',0.00003);
% set(getselectedsource(handles.vid),'Brightness',0);%%????
% %set(getselectedsource(handles.vid),'FrameRate',15);


% close all open devices in case they were left open (by a gui crash)
instruments = instrfind;
if ~isempty(instruments)
    fclose(instruments);
end

%%%Create an instrument object:          DK changed COM3 into COM4
handles.s = serial('COM3');  



%%%Configure property values
set(handles.s,'BaudRate',19200)
set(handles.s,'Terminator','CR')

%%%Connect to the instrument
fopen(handles.s)

%%%%Turn on the motor & home
fprintf(handles.s,'1MO;2MO;3MO;1VA20;2VA20;3VA20;3OR;2OR;1OR')
%fprintf(handles.s,'1VA20;2VA20;3VA20')%motor speed
%fprintf(handles.s,'3OR;2OR;1OR;3PR-73')%motor home

% qqDS 
% warndlg(sprintf(['debug mode. do not use if motor controller is plugged in\n', ...
%    'if it is, uncomment this line and re-enable the next one']));
pause(15);


fprintf(handles.s,'3PR-73')%%move specimen to home
%******************************************************

% Choose default command line output for tensorguiDK
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tensorguiDK wait for user response (see UIRESUME)
% uiwait(handles.figure1);

localFillFormatPop(handles);

% --- Outputs from this function are returned to the command line.
function varargout = tensorguiDK_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



function varargout = tensorgui_DeleteFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
disp('deleteFcn');


% --- Executes on button press in alignmentpushbutton.
function alignmentpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to alignmentpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%**********************************************************************
if handles.rvdegree==90
    
    %%%location of the specimen
    
    nframes=360/handles.rvdegree;
    fprintf(handles.s,'1OR;2OR;3OR');

 %alignment
load alignmdegreesdefault
alignmdegrees=alignmdegrees+90;

if alignmdegrees>0
    cmdesp=['2PR+',int2str(alignmdegrees)];
    fprintf(handles.s,cmdesp)
else
    alignmdegrees=-alignmdegrees;
    cmdesp=['2PR-',int2str(alignmdegrees)];
    fprintf(handles.s,cmdesp)
end

pic=zeros(handles.ysize,handles.xsize,nframes,'uint8');
pause(10);

for n=1:nframes
%%%Call the getsnapshot function to bring a frame into the workspace.
frame = getsnapshot(handles.vid);
pic(:,:,n)=frame(1:handles.ysize,1:handles.xsize);
pause(2);

%Rotate the polarizer and analyser
cmdesp=['3PR+',int2str(handles.rvdegree)];
fprintf(handles.s,cmdesp)

%wait to finish rotation
waittime=handles.rvdegree/20+5;
pause(waittime);
%beep
sprintf([int2str(n),' pictures are taken'])
end

acquiredate=clock;
mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\pic_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'pic')

handles.acquiredate=acquiredate;
handles.pic=pic;
guidata(hObject, handles);

%%To determine the location of the specimen
specimenlocation(hObject, eventdata, handles);

else
    
nframes=180/handles.urmdegree; %%number of images to be acquired for alignment
fprintf(handles.s,'1OR;2OR');
pic=zeros(handles.ysize,handles.xsize,nframes,'uint8');
pause(20);

for n=1:nframes
%fprintf(handles.s,'2PR-40')
%pause(20);
%for n=1:10
%%%Call the getsnapshot function to bring a frame into the workspace.
frame = getsnapshot(handles.vid);
pic(:,:,n)=frame(1:handles.ysize,1:handles.xsize);
pause(2);

%Rotate the polarizer and analyser
cmdesp=['2PR+',int2str(handles.urmdegree)];
fprintf(handles.s,cmdesp)

%wait to finish rotation
waittime=handles.urmdegree/20+3;
pause(waittime);
%beep
sprintf([int2str(n),' pictures are taken'])
end

acquiredate=clock;
mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\pic_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'pic')

%alignment using Fourier polarimetry
handles.pic=pic;
handles.acquiredate=acquiredate;
guidata(hObject, handles);
alignmdegrees=alignm(hObject, eventdata, handles);
end
%**************************************************************************

%**************************************************************************
% --- Executes on button press in fourierpushbutton.
function fourierpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to fourierpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ratio=0.5;
nframes=360/handles.urmdegree; %%number of images to be acquired for Fourier polarimetry
fprintf(handles.s,'1VA20;2VA20;1OR;2OR');
pause(15);

%alignment
load alignmdegreesdefault
alignmdegrees=alignmdegrees+90;

if alignmdegrees>0
    cmdesp=['2PR+',int2str(alignmdegrees)];
    fprintf(handles.s,cmdesp)
else
    alignmdegrees=-alignmdegrees;
    cmdesp=['2PR-',int2str(alignmdegrees)];
    fprintf(handles.s,cmdesp)
end

%load('C:\ImageBank\25_13_30_3\pic_25_13_30_3.mat');
%picsub=pic;

pic=zeros(handles.ysize,handles.xsize,nframes,'uint8');
pause(15);

for n=1:nframes
%%%Call the getsnapshot function to bring a frame into the workspace.
for nnnnn=1:20
frame = getsnapshot(handles.vid);
pic(:,:,n)=frame(1:handles.ysize,1:handles.xsize);
%pause(2);
frame = getsnapshot(handles.vid);
pic(:,:,n)=frame(1:handles.ysize,1:handles.xsize)+pic(:,:,n);
%Rotate the polarizer and analyser
end
pic(:,:,n)=pic(:,:,n)/20;%-picsub(:,:,n);

cmdesp=['1PR+',int2str(handles.urmdegree),';','2PR+',int2str(handles.ratio*handles.urmdegree)];
fprintf(handles.s,cmdesp)

%wait to finish rotation
waittime=handles.ratio*handles.urmdegree/20+2;
%waittime=handles.ratio*handles.urmdegree/20+2;
pause(waittime);
sprintf([int2str(n),' pictures are taken'])
end

acquiredate=clock;
mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\pic_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'pic')

%clear picsub

%calculate three characteristic parameter
handles.acquiredate=acquiredate;
handles.pic=pic;
guidata(hObject, handles);
characH(hObject, eventdata, handles)

%**************************************************************************
% --- Executes on button press in tensorpushbutton.
function tensorpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tensorpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Test here
%sprintf(int2str(handles.urmdegree))% delete after test
%sprintf(int2str(handles.rvdegree))% delete after test
%**************************************************************************

nframes=360/handles.urmdegree;%%number of images to be acquired for Fourier polarimetry
mframes=180/handles.rvdegree;%%number of images to be acquired for tensor tomography (either 180 or 450 S&A)
handles.ratio=0.5;
fprintf(handles.s,'1VA20;2VA20;3VA20;1OR;2OR;3OR');
pause(15);
fprintf(handles.s,'3PR');

%alignment
load alignmdegreesdefault
alignmdegrees=alignmdegrees+90;

if alignmdegrees>0
    cmdesp=['2PR+',int2str(alignmdegrees)];
    fprintf(handles.s,cmdesp)
else
    alignmdegrees=-alignmdegrees;
    cmdesp=['2PR-',int2str(alignmdegrees)];
    fprintf(handles.s,cmdesp)
end

pause(10);
pic=zeros(handles.ysize,handles.xsize,nframes,'uint8');

disp('Warning: using new (non-Hui) folder format to save data');
acquiredate=clock;
folder_base = sprintf('C:\\Users\\Abrego\\Documents\\MATLAB\\a.-Acquired images\\%.4d_%.2d_%.2d', ...
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



for m=1:mframes
     for n=1:nframes
   
%%%Call the getsnapshot function to bring a frame into the workspace.
frame = getsnapshot(handles.vid);
pic(:,:,n)=frame(1:handles.ysize,1:handles.xsize);

%Rotate the polarizer and analyser
cmdesp=['1PR+',int2str(handles.urmdegree),';','2PR+',int2str(handles.ratio*handles.urmdegree)];
fprintf(handles.s,cmdesp)

%wait to finish rotation
waittime=handles.ratio*handles.urmdegree/20+1;
pause(waittime);
   end

%acquiredate=clock;
%mkdir('c:\ImageBank',[int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
%save(['c:\ImageBank\',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\pic_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'_',int2str(m)],'pic')
filename = sprintf('%s\\frame_%.3d', folder_name, m);
save(filename, 'pic');

%%rotate specimen
cmdesp=['3PR+',int2str(handles.rvdegree)];
fprintf(handles.s,cmdesp)

sprintf(int2str(m),'view images are taken')
%wait to finish rotation
waittime=handles.rvdegree/20+1;
pause(waittime);
end
%**************************************************************************
% --- Executes on selection change in formatPop.
function formatPop_Callback(hObject, eventdata, handles)
% hObject    handle to formatPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns formatPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from formatPop

delete(handles.vid);
imageformat=localGetSelectedFormatName(handles);
%handles.vid=videoinput('winvideo',1,localGetSelectedFormatName(handles));%lboro
handles.vid=videoinput('dcam',1,imageformat);%shef
%set(handles.vid,'SelectedSourceName',localGetSelectedSourceName(handles));
start(handles.vid);

%To initial video source
set(getselectedsource(handles.vid),'GainMode','manual');
set(getselectedsource(handles.vid),'Gain',384);
set(getselectedsource(handles.vid),'ShutterMode','manual');
%set(getselectedsource(handles.vid),'ShutterControl','absolute');
%set(getselectedsource(handles.vid),'Shutter',90);
%set(getselectedsource(handles.vid),'ShutterAbsolute',0.0005);
set(getselectedsource(handles.vid),'Brightness',0);

switch lower(imageformat)
    case {'y16_1024x768','y8_1024x768'}
handles.xpixel=1024;
handles.ypixel=768;
    case {'y16_800x600','y8_800x600'}
handles.xpixel=800;
handles.ypixel=600;
    case {'y16_640x480','y8_640x480'}
handles.xpixel=640;
handles.ypixel=480;
end

preview(handles.vid)

% Update handles structure
guidata(hObject, handles);

%$*************************************************************    
% --- Executes during object creation, after setting all properties.
function formatPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to formatPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%$*************************************************************  
% --- Executes on selection change in urmpopupmenu.
function urmpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to urmpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns urmpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from urmpopupmenu

strurmdegree=get(hObject,'String');
valurmdegree=get(hObject,'Value');

switch strurmdegree{valurmdegree};
    case '72 deg.'
handles.urmdegree=72;
handles.ratio=2;
    case '40 deg.'
handles.urmdegree=40;
handles.ratio=3;
case '36 deg.'
handles.urmdegree=36;
handles.ratio=2;
    case '20 deg.'
handles.urmdegree=20;
handles.ratio=3;
case '18 deg.'
handles.urmdegree=18;
handles.ratio=2;
    case '10 deg.'
handles.urmdegree=10;
handles.ratio=3;
    case '5 deg.'
handles.urmdegree=5;
    case '2 deg.'
handles.urmdegree=2;
    case '1 deg.'
handles.urmdegree=1;
end

guidata(hObject,handles)

%*****************************************************************
% --- Executes during object creation, after setting all properties.
function urmpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to urmpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%$*************************************************************  
% --- Executes on selection change in rvpopupmenu.
function rvpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to rvpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rvpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rvpopupmenu
strrvdegree=get(hObject,'String');
valrvdegree=get(hObject,'Value');

switch strrvdegree{valrvdegree};
    case 'SpecimenLocation'
    handles.rvdegree=90;
    case '20 deg.'
    handles.rvdegree=20;
    case '10 deg.'
    handles.rvdegree=10;
    case '5 deg.'
    handles.rvdegree=5;
    case '2 deg.'
    handles.rvdegree=2;
    case '1 deg.'
    handles.rvdegree=1;
end

guidata(hObject,handles)

%**********************************************************************
% --- Executes during object creation, after setting all properties.
function rvpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rvpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%$*************************************************************  
% --- Executes on button press in previewpushbutton.
function previewpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to previewpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% qqDS not available with vcapg2
%preview(handles.vid)

%***********************************************************
% --- Executes on button press in snapshotpushbutton.
function snapshotpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to snapshotpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%Call the getsnapshot function to bring a frame into the workspace.
nf=1;
frame=zeros(handles.ysize,handles.xsize,'uint8');
tempframe=zeros(1024,1284,'uint8');
for n=1:nf
 
   tempframe=getsnapshot(handles.vid);
   
    frame = tempframe(1:handles.ysize,1:handles.xsize)+frame;
end

figure,imagesc(frame), colormap gray;%, axis off; % axis square;
acquiredate=clock;
mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\pic_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'frame')

%**************************************************************************
% --- Executes on button press in closepushbutton.
function closepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to closepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% qqDS
%delete(handles.vid)
exitCamera(handles.vid.cam);

%%Disconnect and clean up serial port
fclose(handles.s)%lab
delete(handles.s)
clear handles.s
close all
clear all

%************************************************************************
% --- Executes on button press in sourceconfig.
function sourceconfig_Callback(hObject, eventdata, handles)
% hObject    handle to sourceconfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inspect; % bring window to foreground
inspect(getselectedsource(handles.vid));
guidata(hObject, handles);

%$*************************************************************  
% --- Executes on button press in deviceconfig.
function deviceconfig_Callback(hObject, eventdata, handles)
% hObject    handle to deviceconfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inspect; % bring window to foreground
inspect(handles.vid);

%$*************************************************************  
% --- Retrieves the selected source name from the source selection UI.
function selectedFormatName = localGetSelectedFormatName(handles);
formatNames         = get(handles.formatPop,'String');
selectedFormatName =formatNames{get(handles.formatPop,'Value')};

%**************************************
function localFillFormatPop(handles)
localInitSelectedFormatIndex(handles);
% qqDS not sure we need this. comment out for now
% 
%hwA = imaqhwinfo('dcam',1);
%hwA.SupportedFormats = {'Default'};
hwA.SupportedFormats = {'Default'};
handles.formatPop = findobj(handles.figure1,'Tag','formatPop');
set(handles.formatPop,'String',hwA.SupportedFormats);

%******************************************
function localInitSelectedFormatIndex(handles)
%qqDS change detault from 6 to 1
set(handles.formatPop,'Value',1);

%********************************************************
function characH(hObject, eventdata, handles)

acquiredate=handles.acquiredate;
pfp1=abs(2*(handles.ratio-1))+1;
pfp2=2*(handles.ratio+1)+1;
%%To determine the geometry of the specimen
%fedgeintensity(hObject, eventdata, handles);

%%%resize the images
%fimgresize(hObject, eventdata, handles);
%picr=handles.picor;
picr=double(handles.pic);

%%%Calculate three characteristc parameter
F=fft(picr,[],3);
        
        A1=real(F(:,:,pfp1));        
        A2=real(F(:,:,pfp2));
        
        if handles.ratio>1
       B1=-imag(F(:,:,pfp1));%%n>1;
        else
            B1=imag(F(:,:,pfp1));%%n=0.5;
        end
        B2=-imag(F(:,:,pfp2));
 
%%%Retardation in radians
l=((A2.^2)+(B2.^2)).^(1/4);
h=((A1.^2)+(B1.^2)).^(1/4)+0.000000000001;
del=2*(atan(l./h));

%%%%Characteristic angle in redians
char=atan2(B1,A1)/2;

%%%%Primary direction in redians
pri=atan2(B2,A2)/4-char/2;

charac(:,:,1)=del;charac(:,:,2)=pri;charac(:,:,3)=char;
%charac(:,:,1)=medfilt2(del);charac(:,:,2)=medfilt2(pri);charac(:,:,3)=medfilt2(char);

handles.charact=charac;
guidata(hObject, handles);

%%%Determine the edge byb the characteristic parameters
%fdtmedgecharac(hObject, eventdata, handles);

%%%%remove the noise and determine the undefined parameter
%charac=frmvnoise(hObject, eventdata, handles);

mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\charac_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'charac')

figure,
%title('Characteristic Perameters (degrees) found using Fourier Polarimetry')
subplot (2,2,1),imagesc(abs(charac(:,:,1)/2/pi)),axis equal, axis tight, colorbar
xlabel('Characteristic Retardation')
subplot (2,2,2),imagesc(charac(:,:,2)/2/pi*360),axis equal, axis tight, colorbar
xlabel('Primary Characteristic Direction')
subplot (2,2,3),imagesc(charac(:,:,3)/2/pi*360),axis equal, axis tight, colorbar
xlabel('Characteristic Angle')
% obsolete pixval
impixelinfo

%$*************************************************************  
function alignmdegrees=alignm(hObject, eventdata, handles)

pic=handles.pic;
acquiredate=handles.acquiredate;
aa=mean(mean(pic));
[bb alignmdegrees]=min(aa);
alignmdegrees=(alignmdegrees-1)*handles.urmdegree;

mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\alignmdegrees_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'alignmdegrees')
save alignmdegrees alignmdegrees

%$*************************************************************  
% --- Executes on button press in helppushbutton.
function helppushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helppushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ratio
base = [getdir,'/help/'];
web([base,'index.htm'],'-browser');

%$*************************************************************  
% ---- Utility function to extract the directory where this 
%      file was installed.
function base = getdir
p = which('tensorgui');
[pathstr,basefile,ext,versn]=fileparts(p);
base = strrep(lower(pathstr),'\','/');

%$*************************************************************  
% --- Executes on button press in Tensorreconstructionpushbutton.
function Tensorreconstructionpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Tensorreconstructionpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tensorrec(handles.vid);

%$*************************************************************  
% --- Executes on button press in esp300pushbutton.
function esp300pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to esp300pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

esp300gui(handles.s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To determine the location of specimen
function specimenlocation(hObject, eventdata, handles);

acquiredate=handles.acquiredate;
pic=double(handles.pic);

figure,imagesc(pic(:,:,1)),colormap gray
mp=input('Input the location mark position (pixels in vertical direction):');
%mp=sscanf(Ss,'%f')
pixeln=20;

dp1=crosscor(pic(mp-pixeln:mp+pixeln,:,1),pic(mp-pixeln:mp+pixeln,:,3),pixeln);
dp2=crosscor(pic(mp-pixeln:mp+pixeln,:,2),pic(mp-pixeln:mp+pixeln,:,4),pixeln);

specimenpr=(dp1.^2+dp2.^2).^0.5;%%%radius

specimenpa1=acos(abs(dp1)/specimenpr)*360/2/pi;%%%angle
%specimenpa2=asin(-dp2/specimenpp)*360/2/pi;

if dp1>=0 & dp2>=0
    specimenpa=180+specimenpa1;
else if dp1>=0 & dp2<0
        specimenpa=180-specimenpa1;
        else if dp1<0 & dp2<0
        specimenpa=specimenpa1;
            else
               specimenpa=-specimenpa1;
            end
    end
end

specimenloc=[specimenpr specimenpa];

mkdir('c:\ImageBank',[int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))]);
save(['c:\ImageBank\',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2)),'\specimenloc_',int2str(acquiredate(5)),'_',int2str(acquiredate(4)),'_',int2str(acquiredate(3)),'_',int2str(acquiredate(2))],'specimenloc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dp=crosscor(image1,image2,pixeln)

bb=abs(fftshift(ifft2(fft2(image1).*conj(fft2(image2)))));
[xpixel ypixel]=size(image1);

%%%1D
cc=bb(pixeln,:);%mark position
%figure,plot(bb(pixeln,:)),colormap gray
[ddmax dy]=max(cc);
dp=(dy-ypixel/2-1+(log(cc(dy+1))-log(cc(dy-1)))/(4*log(cc(dy))-2*log(cc(dy+1))-2*log(cc(dy-1))))/2;

%%%2D
%[ddmax dd]=max(max(bb));
%[dx dy]=find(bb==ddmax)
%subpixel accuracy???? Gaussian fitting
%dp=(dy-ypixel/2-1+(log(bb(dx,dy+1))-log(bb(dx,dy-1)))/(4*log(bb(dx,dy))-2*log(bb(dx,dy+1))-2*log(bb(dx,dy-1))))/2;

%$*************************************************************  
%%%resize and crop the images
function fimgresize(hObject, eventdata, handles);

picor=double(handles.pic);
aa=size(picor);
rt=512/max(aa);
pic=zeros(aa(1)*rt,aa(2)*rt,aa(3));

for nn=1:aa(3)
bb(:,:)=picor(:,:,nn).*double(handles.characmask);
pic(:,:,nn)=imresize(bb,rt);
end

handles.picor=pic;
handles.rt=rt;
guidata(hObject, handles);

%$*************************************************************  
%%%%Identify the background by three parameter
function fdtmedgecharac(hObject, eventdata, handles);

charac=handles.charact;
%%%Determine the edge of the specimen
edgecha=edge(charac(:,:,1),'canny').*edge(charac(:,:,2),'canny');
[mm nn]=size(edgecha);
mmm=round(mm/2);

%%%rotated the images if the specimen is in 45 degrees

%%Determine the boundary of the specimen
for kk=1:mmm
    dd=find(edgecha(kk,:)==1);
    [vx vy]=size(dd);
    if vy>0
    ymin(kk)=min(dd);
    ymax(kk)=max(dd);
        else
        xmin(kk)=kk;
        ymin(kk)=nn;
    end
end

xmin(size(xmin)+1)=0;
ymins=min(ymin);
ymaxs=max(ymax);
xmins=min(find(xmin==0));
yp=ymaxs-ymins+1;

if yp<mm-xmins+1
    xmaxs=yp-xmins+1;
else
    xmaxs=mm;
end

%%%mask
characmask=zeros(mm,nn,3);
characmask(xmins:xmaxs,ymins:ymaxs,:)=1;

%%%%Set the parameters of background equal to zeors
characm=charac.*characmask;
handles.characm=characm;

guidata(hObject, handles);

%$*************************************************************  
%%%To remove the noise
function charac=frmvnoise(hObject, eventdata, handles);

charac=handles.characm;
threshold1=0.25;
threshold2=0.025;
[sx sy]=size(charac(:,:,1));

for mm=2:sx-1
    for nn=2:sy-1
        for kk=1:3
            if abs(charac(mm,nn,kk))>abs(threshold1*(sum(sum(charac(mm-1:mm+1,nn-1:nn+1,kk)))-charac(mm,nn,kk)))
            charac(mm,nn,kk)=(sum(sum(charac(mm-1:mm+1,nn-1:nn+1,kk)))-charac(mm,nn,kk))/8;
        end
        end
        %%%to determine undefined parameter
             if charac(mm,nn,1)<threshold2
            charac(mm,nn,2)=(sum(sum(charac(mm-1:mm+1,nn-1:nn+1,2)))-charac(mm,nn,2))/8;
             end
    end
end
handles.charac=charac;
guidata(hObject, handles);

%$*************************************************************  
%%%%Identify the background by images' intensity
function fedgeintensity(hObject, eventdata, handles);

%%%Determine the edge of the specimen
pictt=handles.pic;
gg=round(90/handles.urmdegree/2+1);
pic9=pictt(:,:,gg);
edgeimage=edge(pic9,'canny');
[mm nn]=size(edgeimage);

%%%rotated the images if the specimen is in 45 degrees

%%Determine the boundary of the specimen

nnn=1;
for kk=1:mm
    dd=find(edgeimage(kk,:)==1);
    [vx vy]=size(dd);
    if vy>0 & min(dd)<round(nn/6)
    yminx(nnn)=min(dd);
    yminy(nnn)=kk;
    ymaxx(nnn)=max(dd);
    ymaxy(nnn)=kk;
    nnn=nnn+1;
    end
end
    
meanyminx=mean(yminx);
meanymaxx=mean(ymaxx);
aa1=find(abs(yminx-meanyminx)>10);
yminx(aa1)=meanyminx;
aa2=find(abs(ymaxx-meanymaxx)>10);
ymaxx(aa2)=meanymaxx;

nnn=1;
for kk=1:nn/2
    dd=find(edgeimage(:,kk)==1);
    [vx vy]=size(dd);
    if vy>0 & min(dd)<round(mm/6)
    xminx(nnn)=min(dd);
    xminy(nnn)=kk;
    xmaxx(nnn)=max(dd);
    xmaxy(nnn)=kk;
    nnn=nnn+1;
    end
end
 
%%Remove the noise
meanxminx=mean(xminx);
meanxmaxx=mean(xmaxx);
aa1=find(abs(xminx-meanxminx)>10);
xminx(aa1)=meanxminx;
aa2=find(abs(xmaxx-meanxmaxx)>10);
xmaxx(aa2)=meanxmaxx;

%fit1=fit(yminy',yminx','poly1');fit2=fit(ymaxy',ymaxx','poly1');fit3=fit(xminy',xminx','poly1');fit4=fit(xmaxy',xmaxx','poly1');
fit1=polyfit(yminy',yminx',2);fit2=polyfit(ymaxy',ymaxx',2);fit3=polyfit(xminy',xminx',2);fit4=polyfit(xmaxy',xmaxx',2);

%%%mask
[yy xx]=meshgrid(1:nn,1:mm);
characmask=ones(mm,nn);
characmask(find(yy<xx.^2*fit1(1)+xx*fit1(2)+fit1(3)))=0;
characmask(find(yy>xx.^2*fit2(1)+xx*fit2(2)+fit2(3)))=0;
characmask(find(xx<yy.^2*fit3(1)+yy*fit3(2)+fit3(3)))=0;
characmask(find(xx>yy.^2*fit4(1)+yy*fit4(2)+fit4(3)))=0;

handles.characmask=characmask;
guidata(hObject, handles);

% qqDS replcement getsnapshot
function frame = getsnapshot(hVid)
    freezeVideo(hVid.cam);
    frame = hVid.I.image' + 0;
   
    disp('TODO: check if image is upside-down');
    
% --- Executes during object creation, after setting all properties.
function tensorpushbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tensorpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function tensorpushbutton_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to tensorpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
