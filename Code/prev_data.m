function varargout = prev_data(varargin)
% PREV_DATA MATLAB code for prev_data.fig
%      PREV_DATA, by itself, creates a new PREV_DATA or raises the existing
%      singleton*.
%
%      H = PREV_DATA returns the handle to a new PREV_DATA or the handle to
%      the existing singleton*.
%
%      PREV_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREV_DATA.M with the given input arguments.
%
%      PREV_DATA('Property','Value',...) creates a new PREV_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prev_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prev_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prev_data

% Last Modified by GUIDE v2.5 09-Sep-2012 16:41:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prev_data_OpeningFcn, ...
                   'gui_OutputFcn',  @prev_data_OutputFcn, ...
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


% --- Executes just before prev_data is made visible.
function prev_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prev_data (see VARARGIN)
pos=get(handles.figure1,'Position');
newpos=round(get(0,'ScreenSize')/2-pos/2);
set(handles.figure1,'Position',[newpos(3) newpos(4) pos(3) pos(4)]);

file_name=evalin('base','file_name;');
set(handles.text2,'String',file_name);
load param.mat;
org_dir=cd(param.save_folder);
[handles.data,handles.txt]=xlsread(file_name,'Sheet1','','basic');
cd(org_dir);
if ~isfield(handles,'data')
    errordlg({'File not found!';'';'Check your data saving folder in the options screen'},'Error');
    close(handles.figure1);
end

set(handles.chosen_mark,'String',handles.txt(2:end,2));

%displaying categories
switch param.area
        case 1
            handles.uA=' [sq. um]'; handles.uD=' [um]'; handles.uS=' [spot per sq. um]';
        case 2
            handles.uA=' [sq. mm]'; handles.uD=' [mm]'; handles.uS=' [spot per sq. mm]';
        case 3
            handles.uA=' [sq. cm]'; handles.uD=' [cm]'; handles.uS=' [spot per sq. cm]';
end
set(handles.text3,'String',sprintf([...
'Number of spots:..................................................................................'...
'\n\n'...
'Average spot area%s:...................................................................'...
'\n\n'...
'Density%s:....................................................................'...
'\n\n'...
'Average eccentricity:............................................................................'...
'\n\n'...
'Average distance to the nearest neighbor%s:.......................................'...
    ],handles.uA,handles.uS,handles.uD));

%displaying values
set(handles.text4,'String',sprintf('%d\n\n%.5f\n\n%.5f\n\n%.5f\n\n%.5f', ...
    handles.data(1,1),handles.data(1,2),handles.data(1,3),handles.data(1,4),handles.data(1,5)));
set(handles.R,'String',sprintf('R=%f',handles.data(1,6)));
set(handles.G,'String',sprintf('G=%f',handles.data(1,7)));
set(handles.B,'String',sprintf('B=%f',handles.data(1,8)));

axes(handles.axes1);
imshow(zeros(48,290));
axes(handles.axes2);
imshow(uint8(cat(3,ones(48,317)*handles.data(1,6),ones(48,317)*handles.data(1,7),ones(48,317)*handles.data(1,8))));


% Choose default command line output for prev_data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prev_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prev_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in chosen_mark.
function chosen_mark_Callback(hObject, eventdata, handles)
% hObject    handle to chosen_mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chosen_mark contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chosen_mark
i=get(hObject,'Value');

set(handles.text4,'String',sprintf('%d\n\n%.5f\n\n%.5f\n\n%.5f\n\n%.5f', ...
    handles.data(i,1),handles.data(i,2),handles.data(i,3),handles.data(i,4),handles.data(i,5)));
set(handles.R,'String',sprintf('R=%f',handles.data(i,6)));
set(handles.G,'String',sprintf('G=%f',handles.data(i,7)));
set(handles.B,'String',sprintf('B=%f',handles.data(i,8)));

axes(handles.axes1);
imshow(zeros(48,290));
axes(handles.axes2);
imshow(uint8(cat(3,ones(48,317)*handles.data(i,6),ones(48,317)*handles.data(i,7),ones(48,317)*handles.data(i,8))));
