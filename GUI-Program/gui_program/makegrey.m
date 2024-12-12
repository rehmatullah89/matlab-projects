function varargout = makegrey(varargin)
% MAKEGREY M-file for makegrey.fig
%      MAKEGREY, by itself, creates a new MAKEGREY or raises the existing
%      singleton*.
%
%      H = MAKEGREY returns the handle to a new MAKEGREY or the handle to
%      the existing singleton*.
%
%      MAKEGREY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAKEGREY.M with the given input arguments.
%
%      MAKEGREY('Property','Value',...) creates a new MAKEGREY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before makegrey_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to makegrey_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help makegrey

% Last Modified by GUIDE v2.5 19-Sep-2012 10:32:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @makegrey_OpeningFcn, ...
                   'gui_OutputFcn',  @makegrey_OutputFcn, ...
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


% --- Executes just before makegrey is made visible.
function makegrey_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to makegrey (see VARARGIN)

% Choose default command line output for makegrey
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes makegrey wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = makegrey_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=imread('img.jpg');
imshow(im);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=imread('img.jpg');
[rows cols]=size(im);

for i=1:rows
    for j=1:cols
     new(i,j,1)=im(i,j,1)+im(i,j,2)+im(i,j,3);
    end
end
imshow(new);

