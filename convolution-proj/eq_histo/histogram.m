function varargout = histogram(varargin)
% HISTOGRAM M-file for histogram.fig
%      HISTOGRAM, by itself, creates a new HISTOGRAM or raises the existing
%      singleton*.
%
%      H = HISTOGRAM returns the handle to a new HISTOGRAM or the handle to
%      the existing singleton*.
%
%      HISTOGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HISTOGRAM.M with the given input arguments.
%
%      HISTOGRAM('Property','Value',...) creates a new HISTOGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before histogram_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to histogram_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help histogram

% Last Modified by GUIDE v2.5 11-Dec-2012 10:49:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @histogram_OpeningFcn, ...
                   'gui_OutputFcn',  @histogram_OutputFcn, ...
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


% --- Executes just before histogram is made visible.
function histogram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to histogram (see VARARGIN)

% Choose default command line output for histogram
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes histogram wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = histogram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ViewHistogram.
function ViewHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to ViewHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=imread('lena.jpg');
I=double(I);
maximum_value=max((max(I)));
[row col]=size(I);
c=row*col;
h=zeros(1,256);%300
z=zeros(1,256);
for n=1:row
for m=1:col
if I(n,m) == 0
I(n,m)=1;
end
end
end
for n=1:row
for m=1:col
t = I(n,m);
h(t) = h(t) + 1;
end
end
pdf = h/c;
cdf(1) = pdf(1);
for x=2:maximum_value
cdf(x) = pdf(x) + cdf(x-1);
end
new = round(cdf * maximum_value);
new= new + 1;
for p=1:row
for q=1:col
temp=I(p,q);
b(p,q)=new(temp);
t=b(p,q);
z(t)=z(t)+1;
end
end
b=b-1;
subplot(2,2,1), imshow(uint8(I)) , title(' Image1');

subplot(2,2,2), bar(h) , title('Histogram of d Orig. Image');

subplot(2,2,3), imshow(uint8(b)) , title('Image2');

subplot(2,2,4),bar(z) , title('Histogram Equalisation of image2');
