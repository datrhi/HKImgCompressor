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

% Last Modified by GUIDE v2.5 05-Apr-2021 18:08:39

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
global load;
global myicon;
global outputFile;
global imgint;
global img;
global ogImage;
global outputFile;
global comImage;
global comRat;
global quant;
myicon = imread('loading.jpg');
load = msgbox('Cho ti nhe ^^','Waiting','custom',myicon);


tic;
            
if~(ischar(inputFile))
               
    errordlg('Ban hay chon buc anh');
            
else
    if(handles.checkBox.Value)   
        if(handles.luminance.Value)
            quant=1;
        elseif(handles.chrominance.Value)
            quant=2;
        elseif(handles.dctBox.Value)
            quant=3;
        end
        
        
        imgint = imread(inputFile); 
        imgint = rgb2gray(imgint);
        [row,col] = size(imgint);
        rows = row / 8;
        cols = col / 8;
        lastcode = ''; 

        
        block = []; 
        FormerDC = 0; 
        for k = 1:rows
            for l = 1:cols
                block(1:8,1:8) = imgint((k-1)*8+1:k*8,(l-1)*8+1:l*8);
                dct = JPEGDCT(block); 
                if(handles.dct1.Value)
                    dct = mask1(dct);
                elseif(handles.dct10.Value)
                    dct = mask10(dct);
                end
                q = JPEGQuantification(dct,quant); 
                zz = Zigzag(q); 
                strcode = JPEGEncode(zz,FormerDC); 
                lastcode = [lastcode,strcode];
                FormerDC = zz(1);
            end
        end
        code = lastcode;
        fid = fopen('output.txt','wt');
        fprintf(fid,code);
        fclose(fid);
        
        img = JPEGDecode(code,col,row,quant);
        axes(handles.decomImg);
        
        imshow(img);
        toc;
        close(load);
        [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');                 
        imwrite(img,[pathname,outputFile]);
        set(handles.comTime,'String',num2str(toc));
        info = imfinfo(fullfile(pathname,outputFile));
        comImage =  (info.FileSize)/1024;       
        set(handles.comImgSize,'String',comImage);  
        comRat = ogImage/comImage;           
        set(handles.comRatio,'String',comRat); 
        mse = immse(imgint,img);
        psnr = 10*log10(255*255/mse);
        set(handles.tMSE,'String',mse);
        set(handles.tPSNR,'String',psnr);
        %h=imagesc(N);
        %impixelregion(h);
       
            
    else
        imgint = imread(inputFile); 
        [row,col] = size(imgint); 
        rows = row / 8; 
        cols = col / 8;
        lastcode = ''; 

        block = []; 
        FormerDC = 0; 
        for k = 1:rows
            for l = 1:cols
                block(1:8,1:8) = imgint((k-1)*8+1:k*8,(l-1)*8+1:l*8);
                dct = JPEGDCT(block); 
                q = JPEGQuantification(dct); 
                zz = Zigzag(q); 
                strcode = JPEGEncode(zz,FormerDC); 
                lastcode = [lastcode,strcode];
                FormerDC = zz(1);
            end
        end
        code = lastcode;

        img = JPEGDecode(code,col,row);
        toc;
        close(load);
        axes(handles.decomImg);
        imshow(img);
        [outputFile,pathname]=uiputfile({'*.jpg'},'Save IMG');                 
        imwrite(img,[pathname,outputFile]);       
        
        set(handles.comTime,'String',num2str(toc));
        info = imfinfo(fullfile(pathname,outputFile));
        comImage =  (info.FileSize)/1024;       
        set(handles.comImgSize,'String',comImage);  
        comRat = ogImage/comImage;           
        set(handles.comRatio,'String',comRat); 
        mse = immse(imgint,img);
        psnr = 10*log10(255*255/mse);
        set(handles.tMSE,'String',mse);
        set(handles.tPSNR,'String',psnr);
        %h=imagesc(N);
        %impixelregion(h);
        
end 
end


% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
cla(handles.ogImg,'reset');
cla(handles.decomImg,'reset');
set(handles.ogImg,'visible','off');
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


% --- Executes on button press in luminance.
function luminance_Callback(hObject, eventdata, handles)
% hObject    handle to luminance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of luminance


% --- Executes on button press in chrominance.
function chrominance_Callback(hObject, eventdata, handles)
% hObject    handle to chrominance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chrominance


% --- Executes on button press in dctBox.
function dctBox_Callback(hObject, eventdata, handles)
% hObject    handle to dctBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dctBox


% --- Executes on button press in dct1.
function dct1_Callback(hObject, eventdata, handles)
% hObject    handle to dct1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dct1


% --- Executes on button press in dct10.
function dct10_Callback(hObject, eventdata, handles)
% hObject    handle to dct10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dct10
