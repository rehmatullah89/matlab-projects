function varargout = assign2(varargin)
% ASSIGN2 M-file for assign2.fig
%      ASSIGN2, by itself, creates a new ASSIGN2 or raises the existing
%      singleton*.
%
%      H = ASSIGN2 returns the handle to a new ASSIGN2 or the handle to
%      the existing singleton*.
%
%      ASSIGN2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGN2.M with the given input arguments.
%
%      ASSIGN2('Property','Value',...) creates a new ASSIGN2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assign2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assign2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assign2

% Last Modified by GUIDE v2.5 29-Sep-2012 13:56:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assign2_OpeningFcn, ...
                   'gui_OutputFcn',  @assign2_OutputFcn, ...
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


% --- Executes just before assign2 is made visible.
function assign2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assign2 (see VARARGIN)

% Choose default command line output for assign2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assign2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = assign2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ZoomFactor.
function ZoomFactor_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ZoomFactor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ZoomFactor
% Determine the selected data set.
      str = get(hObject, 'String');
      val = get(hObject,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case '2' % User selects 2.
         handles.current_data = 2;
      case '4' % User selects 4.
         handles.current_data = 4;
      case '6' % User selects 6.
         handles.current_data = 6;
      case '8' % User selects 8.
         handles.current_data = 6;
      case '10' % User selects 10.
         handles.current_data = 10;
      end
    % Save the handles structure.
guidata(hObject,handles)
   


% --- Executes during object creation, after setting all properties.
function ZoomFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseImage.
function BrowseImage_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=imread('img.jpg');
imshow(im);


% --- Executes on button press in Zoomk.
function Zoomk_Callback(hObject, eventdata, handles)
% hObject    handle to Zoomk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=imread('img.jpg');
[r c d] = size(image);
rn = floor(zoom*r);
cn = floor(zoom*c);
s = zoom;
im_zoom = cast(zeros(rn,cn,d),'uint8');
im_pad = zeros(r+4,c+4,d);
im_pad(2:r+1,2:c+1,:) = image;
im_pad = cast(im_pad,'double');
for m = 1:rn
    x1 = ceil(m/s); x2 = x1+1; x3 = x2+1;
    p = cast(x1,'uint16');
    if(s>1)
       m1 = ceil(s*(x1-1));
       m2 = ceil(s*(x1));
       m3 = ceil(s*(x2));
       m4 = ceil(s*(x3));
    else
       m1 = (s*(x1-1));
       m2 = (s*(x1));
       m3 = (s*(x2));
       m4 = (s*(x3));
    end
    X = [ (m-m2)*(m-m3)*(m-m4)/((m1-m2)*(m1-m3)*(m1-m4)) ...
          (m-m1)*(m-m3)*(m-m4)/((m2-m1)*(m2-m3)*(m2-m4)) ...
          (m-m1)*(m-m2)*(m-m4)/((m3-m1)*(m3-m2)*(m3-m4)) ...
          (m-m1)*(m-m2)*(m-m3)/((m4-m1)*(m4-m2)*(m4-m3))];
    for n = 1:cn
        y1 = ceil(n/s); y2 = y1+1; y3 = y2+1;
        if (s>1)
           n1 = ceil(s*(y1-1));
           n2 = ceil(s*(y1));
           n3 = ceil(s*(y2));
           n4 = ceil(s*(y3));
        else
           n1 = (s*(y1-1));
           n2 = (s*(y1));
           n3 = (s*(y2));
           n4 = (s*(y3));
        end
        Y = [ (n-n2)*(n-n3)*(n-n4)/((n1-n2)*(n1-n3)*(n1-n4));...
              (n-n1)*(n-n3)*(n-n4)/((n2-n1)*(n2-n3)*(n2-n4));...
              (n-n1)*(n-n2)*(n-n4)/((n3-n1)*(n3-n2)*(n3-n4));...
              (n-n1)*(n-n2)*(n-n3)/((n4-n1)*(n4-n2)*(n4-n3))];
        q = cast(y1,'uint16');
        sample = im_pad(p:p+3,q:q+3,:);
        im_zoom(m,n,1) = X*sample(:,:,1)*Y;
        if(d~=1)
              im_zoom(m,n,2) = X*sample(:,:,2)*Y;
              im_zoom(m,n,3) = X*sample(:,:,3)*Y;
        end
    end
end
im_zoom = cast(im_zoom,'uint8');
imshow(im_zoom);

% --- Executes on button press in PixelReplication.
function PixelReplication_Callback(hObject, eventdata, handles)
% hObject    handle to PixelReplication (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clear all;
imIn = imread('img.jpg');
im = imresize(imIn,0.5,'nearest');
[r c d] = size(im);
img = cast(im,'double');
zoom = 2;
factor = 1/zoom;
x = 1:c;
xx = 1:factor:(c+1-factor);
for i = 1:r
    new(i,:,1) = spline(x,[0 img(i,:,1) 0],xx);
    new(i,:,2) = spline(x,[0 img(i,:,2) 0],xx);
    new(i,:,3) = spline(x,[0 img(i,:,3) 0],xx);
end
y = 1:r;
yy = 1:factor:(r+1-factor);
for i = 1:(zoom*(c))
    new1(:,i,1) = (spline(y,[0 new(:,i,1)' 0],yy))';
    new1(:,i,2) = (spline(y,[0 new(:,i,2)' 0],yy))';
    new1(:,i,3) = (spline(y,[0 new(:,i,3)' 0],yy))';
end
new1 = cast(new1,'uint8');
imwrite(new1,'doble.jpg')
%imshow('img.jpg');
figure('doble.jpg');

% --- Executes on button press in ZoomTwice.
function ZoomTwice_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomTwice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Display surf plot of the currently selected data.
im=imread('img.jpg');
[rows cols dim]=size(im);

N_rows=2*rows-1;
M_cols=2*cols-1;

col=cols-1;
row=rows-1;

if(dim==1)
 for i=1:row
    for j=1:col
     new(row,col,1)=(im(i,j,1)+im(i,j+1,1))/2;
    end
 end
 
 for i=1:N_rows
    for j=1:M_cols
        if mod(j,2)==0
            mew(N_rows,N_rows,1)=im(i,j,1);
        end
      if mod(j,2)==1
            mew(N_rows,N_rows,1)=new(i,j,1);
        end
    end
end
end
%for rgb
if dim==3
 for i=1:row
    for j=1:col
     new(row,col,1)=(im(i,j,1)+im(i,j+1,1))/2;
    end
 end
 
 for i=1:N_rows
    for j=1:M_cols
        if mod(j,2)==0
            red(N_rows,N_rows,1)=im(i,j,1);
        end
      if mod(j,2)==1
            red(N_rows,N_rows,1)=new(i,j,1);
        end
    end
 end
  for i=1:row
    for j=1:col
     new(row,col,1)=(im(i,j,2)+im(i,j+1,2))/2;
    end
 end
 
 for i=1:N_rows
    for j=1:M_cols
        if mod(j,2)==0
            green(N_rows,N_rows,1)=im(i,j,2);
        end
      if mod(j,2)==1
            green(N_rows,N_rows,1)=new(i,j,2);
        end
    end
 end

  for i=1:row
    for j=1:col
     new(row,col,1)=(im(i,j,3)+im(i,j+1,3))/2;
    end
 end
 
 for i=1:N_rows
    for j=1:M_cols
        if mod(j,2)==0
            blue(N_rows,N_rows,1)=im(i,j,3);
        end
      if mod(j,2)==1
            blue(N_rows,N_rows,1)=new(i,j,3);
        end
    end
 end

 color(:,:,:)=red(:)+green(:)+blue(:);
 
end
imshow(color);

% --- Executes on button press in MakeGrey.
function MakeGrey_Callback(hObject, eventdata, handles)
% hObject    handle to MakeGrey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=imread('img.jpg');
[rows cols]=size(im);

for i=1:rows
    for j=1:cols
     new(i,j,1)=(im(i,j,1)+im(i,j,2)+im(i,j,3))/3;
    end
end
imshow(new);
