function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 28-Mar-2021 16:23:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chooseImgButton.
function chooseImgButton_Callback(hObject, eventdata, handles)
global inputFile;
global ogImage;
[inputFile,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.tiff;';'*.*'},'Chon anh di bro');
if ~isequal(inputFile,0)  
    inputImage = imread([pathname,inputFile]);         
    axes(handles.ogImg);
    imshow(inputImage);                

    info = imfinfo(fullfile(pathname,inputFile));   % info anh goc
    ogImage = (info.FileSize)/1024; %chuyen tu Byte sang KB
    set(handles.ogImgSize,'String',ogImage);
else
    msgbox('Sao khong chon anh di :( ')
end



% --- Executes on button press in compressedButton.
function compressedButton_Callback(hObject, eventdata, handles)
global inputFile;
global I;
global I1;
global MT;
global Block;
global R;
global G;
global B;
global B2;
global load;
global myicon;
global ogImage;
global N;
global outputFile;
global comImage;
global comRat;

myicon = imread('loading.jpg');
load = msgbox('Program is working. Please wait a minute !','Time','custom',myicon);
   
tic;
            
if~(ischar(inputFile))
               
    errordlg('Ban hay chon buc anh');
            
else
    
    I1 = imread(inputFile);

                
    I = I1(:,:,1);
                
    I = im2double(I);  %Chuyen sang kieu double
                
    MT = dctmtx(8);     %Tinh ma tran bien doi DCT 8x8
                
    Block = blkproc(I,[8 8],'P1*x*P2',MT,MT');  %Thuc hien phep nhan voi moi khoi
    mask = [1 1 1 1 0 0 0 0 
            1 1 1 0 0 0 0 0
            1 1 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 
            0 0 0 0 0 0 0 0 
            0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0];   %Mat na giu lai 10 he so DCT
        
    B2 = blkproc(Block,[8 8],'P1.*x',mask); %Luong tu hóa các he so DCT
                
    R = blkproc(B2,[8 8],'P1*x*P2',MT',MT); %Giai mã

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    I = I1(:,:,2);
    I = im2double(I);  %Chuyen sang kieu double               
    MT = dctmtx(8);     %Tinh ma tran bien doi DCT 8x8                
    Block = blkproc(I,[8 8],'P1*x*P2',MT,MT');  %Thuc hien phep nhan voi moi khoi             
    mask = [1 1 1 1 0 0 0 0                      
            1 1 1 0 0 0 0 0                    
            1 1 0 0 0 0 0 0                     
            1 0 0 0 0 0 0 0                      
            0 0 0 0 0 0 0 0                     
            0 0 0 0 0 0 0 0                   
            0 0 0 0 0 0 0 0                   
            0 0 0 0 0 0 0 0];   %Mat na giu lai 10 he so DCT

    B2 = blkproc(Block,[8 8],'P1.*x',mask); %Luong tu hóa các he so DCT                   
    G = blkproc(B2,[8 8],'P1*x*P2',MT',MT); %Giai mã

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    I = I1(:,:,3);                
    I = im2double(I);  %Chuyen sang kieu double
                
    MT = dctmtx(8);     %Tinh ma tran bien doi DCT 8x8
                
    Block = blkproc(I,[8 8],'P1*x*P2',MT,MT');  %Thuc hien phep nhan voi moi khoi
             
    mask = [1 1 1 1 0 0 0 0                      
            1 1 1 0 0 0 0 0  
            1 1 0 0 0 0 0 0                
            1 0 0 0 0 0 0 0    
            0 0 0 0 0 0 0 0 
            0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0];   %Mat na giu lai 10 he so DCT

    B2 = blkproc(Block,[8 8],'P1.*x',mask); %Luong tu hóa các he so DCT
               
    B = blkproc(B2,[8 8],'P1*x*P2',MT',MT); %Giai mã
       
    close(load);         
    
    toc;          
    set(handles.comTime,'String',num2str(toc));
    
    N(:,:,:)= cat(3,R,G,B); %Noi 3 kenh RGB lai voi nhau          
    axes(handles.comImg);     
    imshow(N);     
    [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');       
    imwrite(N,[pathname,outputFile]);     
    info = imfinfo(fullfile(pathname,outputFile));
          
    comImage =  (info.FileSize)/1024;
         
    set(handles.comImgSize,'String',comImage);
    comRat = ogImage/comImage;          
    set(handles.comRatio,'String',comRat); 
end 


% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
cla(handles.ogImg,'reset');
cla(handles.comImg,'reset');
set(handles.comTime,'String','');
set(handles.comRatio,'String','');
set(handles.ogImgSize,'String','');
set(handles.comImgSize,'String','');
set(handles.ogImg,'visible','off');
set(handles.comImg,'visible','off');
clear all;


% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
exitChoice = questdlg('Thoát?', ...
	'Close this app', ...
	'Có','Không','Không');
switch exitChoice
case 'Có' % Lua chon Co
close
case 'Không' % Lua chon Khong
end


function comImgSize_Callback(~, eventdata, handles)
% hObject    handle to comImgSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comImgSize as text
%        str2double(get(hObject,'String')) returns contents of comImgSize as a double


% --- Executes during object creation, after setting all properties.
function comImgSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comImgSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ogImgSize_Callback(hObject, eventdata, handles)
% hObject    handle to ogImgSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ogImgSize as text
%        str2double(get(hObject,'String')) returns contents of ogImgSize as a double


% --- Executes during object creation, after setting all properties.
function ogImgSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ogImgSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
