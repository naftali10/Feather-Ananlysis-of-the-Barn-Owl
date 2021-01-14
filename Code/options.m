function varargout = options(varargin)
% OPTIONS MATLAB code for options.fig
%      OPTIONS, by itself, creates a new OPTIONS or raises the existing
%      singleton*.
%
%      H = OPTIONS returns the handle to a new OPTIONS or the handle to
%      the existing singleton*.
%
%      OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTIONS.M with the given input arguments.
%
%      OPTIONS('Property','Value',...) creates a new OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help options

% Last Modified by GUIDE v2.5 21-Sep-2012 19:07:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @options_OpeningFcn, ...
                   'gui_OutputFcn',  @options_OutputFcn, ...
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


% --- Executes just before options is made visible.
function options_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to options (see VARARGIN)
pos=get(handles.figure1,'Position');
newpos=round(get(0,'ScreenSize')/2-pos/2);
set(handles.figure1,'Position',[newpos(3) newpos(4) pos(3) pos(4)]);

load param.mat;
set(handles.area,'Value',param.area);
set(handles.fixed_width,'String',param.fixed_width);
set(handles.fixed_hight,'String',param.fixed_hight);
set(handles.save_folder,'String',param.save_folder);
set(handles.load_folder,'String',param.load_folder);
set(handles.spot_rad,'String',param.spot_rad);
set(handles.card,'String',param.card*100);

handles.param.area=param.area;
handles.param.fixed_width=param.fixed_width;
handles.param.fixed_hight=param.fixed_hight;
handles.param.save_folder=param.save_folder;
handles.param.load_folder=param.load_folder;
handles.param.spot_rad=param.spot_rad;
handles.param.card=param.card;

% Choose default command line output for options
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes options wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save('param','-struct','handles','param');
close(handles.figure1);

% --- Executes on button press in restore.
function restore_Callback(hObject, eventdata, handles)
% hObject    handle to restore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.param.area=2;
handles.param.fixed_width=4;
handles.param.fixed_hight=6;
handles.param.save_folder='Processed Data';
handles.param.load_folder='Owl Images';
handles.param.spot_rad=0.135;
handles.param.card=0.027;

set(handles.area,'Value',handles.param.area);
set(handles.fixed_width,'String',handles.param.fixed_width);
set(handles.fixed_hight,'String',handles.param.fixed_hight);
set(handles.save_folder,'String',handles.param.save_folder);
set(handles.load_folder,'String',handles.param.load_folder);
set(handles.spot_rad,'String',handles.param.spot_rad);
set(handles.card,'String',handles.param.card*100);

guidata(hObject, handles);

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);

function area_Callback(hObject, eventdata, handles)

handles.param.area=get(hObject,'Value');
guidata(hObject, handles);

function fixed_width_Callback(hObject, eventdata, handles)

val=str2double(get(hObject,'String'));
if isnan(val)
    errordlg('Width has to be a number!','Bad Value');
    set(hObject,'String',handles.param.fixed_width);
else
    set(hObject,'String',val);
    handles.param.fixed_width=val;
end
guidata(hObject, handles);


function fixed_hight_Callback(hObject, eventdata, handles)

val=str2double(get(hObject,'String'));
if isnan(val)
    errordlg('Hight has to be a number!','Bad Value');
    set(hObject,'String',handles.param.fixed_hight);
else
    set(hObject,'String',val);
    handles.param.fixed_hight=val;
end
guidata(hObject, handles);


% --- Executes on button press in browse_save.
function browse_save_Callback(hObject, eventdata, handles)
% hObject    handle to browse_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_folder=uigetdir(handles.param.save_folder);
if new_folder~=0
    handles.param.save_folder=new_folder;
    set(handles.save_folder,'String',handles.param.save_folder);
end
guidata(hObject, handles);


function spot_rad_Callback(hObject, eventdata, handles)
% hObject    handle to spot_rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of spot_rad as text
%        str2double(get(hObject,'String')) returns contents of spot_rad as a double
val=str2double(get(hObject,'String'));
if isnan(val)
    errordlg('Radius has to be a number!','Bad Value');
    set(hObject,'String',handles.param.spot_rad);
else
    handles.param.spot_rad=val;
end
guidata(hObject, handles);


% --- Executes on button press in browse_load.
function browse_load_Callback(hObject, eventdata, handles)
% hObject    handle to browse_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_folder=uigetdir(handles.param.load_folder);
if new_folder~=0
    handles.param.load_folder=new_folder;
    set(handles.load_folder,'String',handles.param.load_folder);
end
guidata(hObject, handles);



function card_Callback(hObject, eventdata, handles)
% hObject    handle to card (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of card as text
%        str2double(get(hObject,'String')) returns contents of card as a double
val=str2double(get(hObject,'String'));
if isnan(val) || val>100 || val<0
    errordlg('Precentage has to be a number between 0 and 100!','Bad Value');
    set(hObject,'String',handles.param.card*100);
else
    handles.param.card=val/100;
end
guidata(hObject, handles);
