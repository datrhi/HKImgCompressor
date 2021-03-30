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

% Last Modified by GUIDE v2.5 30-Mar-2021 22:38:48

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
global R2;
global B2;
global G2;
global load;
global myicon;
global N;
global outputFile;
global q_mtx;
global dcthieu;
global idcthieu;
global T;
global R3;
global B3;
global G3;

T = dctmtx(8);
dcthieu = @(x) T*x.data*T';

idcthieu = @(x) T'*x.data*T;
q_mtx =     [16 11 10 16 24 40 51 61; 
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
mask = [1 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0            
         0 0 0 0 0 0 0 0             
         0 0 0 0 0 0 0 0            
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0];

myicon = imread('loading.jpg');
load = msgbox('Cho ti nhe ^^','Waiting','custom',myicon);


tic;
            
if~(ischar(inputFile))
               
    errordlg('Ban hay chon buc anh');
            
else
    if(handles.checkBox.Value)   
        I1 = imread(inputFile);   
        I = I1(:,:,1);             
        I = (double(I)-128);
        Block = blockproc(I,[8 8],dcthieu);
        R2 = blockproc(Block,[8 8],@(x) round(x.data./q_mtx));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
            
        I = I1(:,:,2);
        
        I = (double(I)-128);
        Block = blockproc(I,[8 8],dcthieu);
        G2 = blockproc(Block,[8 8],@(x) round(x.data./q_mtx));
        
             
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
                
        I = I1(:,:,3);                
               
        I = (double(I)-128);
        Block = blockproc(I,[8 8],dcthieu);
        B2 = blockproc(Block,[8 8],@(x) round(x.data./q_mtx));
        if(handles.checkbox2.Value)
            R2 = blockproc(R2,[8 8],@(x) mask.*x.data);
            G2 = blockproc(G2,[8 8],@(x) mask.*x.data);
            B2 = blockproc(B2,[8 8],@(x) mask.*x.data);
        end  
          
        %%%
        N(:,:,:)= cat(3,R2,G2,B2); %Noi 3 kenh RGB lai voi nhau 
        R = blockproc(R2,[8 8],@(x) round(x.data.*q_mtx));
        G = blockproc(G2,[8 8],@(x) round(x.data.*q_mtx));
        B = blockproc(B2,[8 8],@(x) round(x.data.*q_mtx));
       
        axes(handles.comImg);               
        imshow(N); 
        close(load);                      
        toc;
        set(handles.comTime,'String',num2str(toc));
        [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');                 
        imwrite(N,[pathname,outputFile]);
        %Giai nen
        
        R2 = uint8(blockproc(R,[8 8],idcthieu)+128);
        
        G2 = uint8(blockproc(G,[8 8],idcthieu)+128);
        
        B2 = uint8(blockproc(B,[8 8],idcthieu)+128);
        N = cat(3,R2,G2,B2);
        
    else
        I1 = imread(inputFile);
        I = (double(I1)-128); % anh gray -128 -> 128 

        
        B = blockproc(I,[8 8],dcthieu); %bien doi dct
        B2 = blockproc(B,[8 8],@(x) round(x.data./q_mtx)); % LUONG TU HOA
        B3 = B2;
        if(handles.checkbox2.Value)
            B3 = blockproc(B2,[8 8],@(x) x.data*mask);
        end
        close(load);          
             
        toc;
        set(handles.comTime,'String',num2str(toc));  
        axes(handles.comImg);               
        imshow(B3);     
        
     
        [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');                 
        imwrite(B3,[pathname,outputFile]);               
        
end 
end


% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
cla(handles.ogImg,'reset');
cla(handles.comImg,'reset');
cla(handles.decomImg,'reset');
set(handles.ogImg,'visible','off');
set(handles.comImg,'visible','off');
set(handles.decomImg,'visible','off');
set(handles.comTime,'String','');
set(handles.comRatio,'String','');
set(handles.ogImgSize,'String','');
set(handles.comImgSize,'String','');
set(handles.tMSE,'String','');
set(handles.tPSNR,'String','');


clear all;


% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
exitChoice = questdlg('Tho�t?', ...
	'Close this app', ...
	'C�','Kh�ng','Kh�ng');
switch exitChoice
case 'C�' % Lua chon Co
close
case 'Kh�ng' % Lua chon Khong
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




% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
about = msgbox({'Dang Trung Hieu - 18020498';'Ngo Minh Khanh - 18020698'},'Info');


% --- Executes on button press in checkBox.
function checkBox_Callback(hObject, eventdata, handles)
% hObject    handle to checkBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkBox


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in decomButton.
function decomButton_Callback(hObject, eventdata, handles)
global I1;
global ogImage;
global N;
global outputFile;
global comImage;
global comRat;
global q_mtx;
global idcthieu;
global B3;
global R3;
global G3;

if(handles.checkBox.Value)

    axes(handles.decomImg);               
    imshow(N);  
    [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');                 
       
    imwrite(N,[pathname,outputFile]);               
        
    info = imfinfo(fullfile(pathname,outputFile));
   
    comImage =  (info.FileSize)/1024;     
    set(handles.comImgSize,'String',comImage);     
    comRat = ogImage/comImage;             
    set(handles.comRatio,'String',comRat); 
else
    G3 = blockproc(B3,[8 8],@(x) round(x.data.*q_mtx));
    N = uint8(blockproc(G3,[8 8],idcthieu)+128);
    axes(handles.decomImg);
    imshow(N)
    [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');                    
    imwrite(N,[pathname,outputFile]);                      
    info = imfinfo(fullfile(pathname,outputFile));
    comImage =  (info.FileSize)/1024;       
    set(handles.comImgSize,'String',comImage);  
    comRat = ogImage/comImage;           
    set(handles.comRatio,'String',comRat); 
end
mse = immse(I1,N);
psnr = 10*log10(255*255/mse);
set(handles.tMSE,'String',mse);
set(handles.tPSNR,'String',psnr);



function tMSE_Callback(hObject, eventdata, handles)
% hObject    handle to tMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tMSE as text
%        str2double(get(hObject,'String')) returns contents of tMSE as a double


% --- Executes during object creation, after setting all properties.
function tMSE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tPSNR_Callback(hObject, eventdata, handles)
% hObject    handle to tPSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tPSNR as text
%        str2double(get(hObject,'String')) returns contents of tPSNR as a double


% --- Executes during object creation, after setting all properties.
function tPSNR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tPSNR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
