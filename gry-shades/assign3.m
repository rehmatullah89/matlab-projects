function varargout = assign3(varargin)
% ASSIGN3 M-file for assign3.fig
%      ASSIGN3, by itself, creates a new ASSIGN3 or raises the existing
%      singleton*.
%
%      H = ASSIGN3 returns the handle to a new ASSIGN3 or the handle to
%      the existing singleton*.
%
%      ASSIGN3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGN3.M with the given input arguments.
%
%      ASSIGN3('Property','Value',...) creates a new ASSIGN3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assign3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assign3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assign3

% Last Modified by GUIDE v2.5 22-Oct-2012 09:04:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assign3_OpeningFcn, ...
                   'gui_OutputFcn',  @assign3_OutputFcn, ...
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


% --- Executes just before assign3 is made visible.
function assign3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assign3 (see VARARGIN)

% Choose default command line output for assign3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assign3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = assign3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ShowImage.
function ShowImage_Callback(hObject, eventdata, handles)
% hObject    handle to ShowImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img=imread('img.gif');
[rows cols]=size(Img);
minimum=min(Img(:));
maximum=max(Img(:));

for i=1:rows
    for j=1:cols
        if(Img(i,j,1)== minimum)
                 new(i,j,1)=0;
        else
            new(i,j,1)= Img(i,j,1);
            end
        if(Img(i,j,1)== maximum)
                 new(i,j,1)=255;
         else
            new(i,j,1)= Img(i,j,1);
            end
    end
end
imshow (new, []);


% --- Executes on button press in HistogramStrtching.
function HistogramStrtching_Callback(hObject, eventdata, handles)
% hObject    handle to HistogramStrtching (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=imread('img.gif');
[rows cols]=size(I);
Img = im2double(I); %doubled the value for precision
minimum=min(Img(:));
maximum=max(Img(:));
figure(1);
subplot(1,2,1);
imhist(Img);
for i=1:rows
    for j=1:cols
         new(i,j)=((Img(i,j)-minimum)/(maximum-minimum))*255;
    end
end
I2 = im2uint8(new);
figure(2);
subplot(1,2,1);
[counts bins]=imhist(I2);
%show histogram
bar(bins,counts);


% --- Executes on button press in Quantize.
function Quantize_Callback(hObject, eventdata, handles)
% hObject    handle to Quantize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%newval = val{get(hObject,'Value')};
newval='7';
I=imread('img.gif');
y = str2num(newval);
x = 2.^y;
R2D=imread('img.gif');
[R2D8,map] = gray2ind(R2D,x); 
pic = ind2gray(R2D8,map);
pic = mat2gray(pic);
imwrite(pic,'newone.jpg');
imshow(pic);


% --- Executes on selection change in bpp.
function bpp_Callback(hObject, eventdata, handles)
% hObject    handle to bpp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns bpp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bpp
str = get(hObject, 'String');
      val = get(hObject,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case '7' % User selects 7.
         handles.bpp = 7;
      case '6' % User selects 6.
         handles.bpp = 6;
      case '5' % User selects 5.
         handles.bpp = 5;
      case '4' % User selects 4.
         handles.bpp = 4;
      case '3' % User selects 3.
         handles.bpp = 3;
      case '2' % User selects 2.
         handles.bpp = 2;
      case '1' % User selects 1.
         handles.bpp = 1;
      end
    % Save the handles structure.
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function bpp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bpp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Brightness.
function Brightness_Callback(hObject, eventdata, handles)
% hObject    handle to Brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=imread('img.gif');
[rows cols]=size(im);
figure(1);
subplot(1,2,1);
imhist(im);
for i=1:rows
    for j=1:cols
     new(i,j,1)=im(i,j,1)+10;
    end
end
figure(2);
subplot(1,2,1);
imhist(new);
imwrite(new,'bright.jpg');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
get(hObject,'String');
str=str2double(get(hObject,'String'));
handles.edit1 = str;
load(handles.edit1)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
