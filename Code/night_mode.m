function varargout = night_mode(varargin)
% NIGHT_MODE MATLAB code for night_mode.fig
%      NIGHT_MODE, by itself, creates a new NIGHT_MODE or raises the existing
%      singleton*.
%
%      H = NIGHT_MODE returns the handle to a new NIGHT_MODE or the handle to
%      the existing singleton*.
%
%      NIGHT_MODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NIGHT_MODE.M with the given input arguments.
%
%      NIGHT_MODE('Property','Value',...) creates a new NIGHT_MODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before night_mode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to night_mode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help night_mode

% Last Modified by GUIDE v2.5 26-Sep-2012 09:51:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @night_mode_OpeningFcn, ...
                   'gui_OutputFcn',  @night_mode_OutputFcn, ...
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


% --- Executes just before night_mode is made visible.
function night_mode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to night_mode (see VARARGIN)
pos=get(handles.figure1,'Position');
newpos=round(get(0,'ScreenSize')/2-pos/2);
set(handles.figure1,'Position',[newpos(3) newpos(4) pos(3) pos(4)]);

axes(handles.background);imshow(imread('icons/night_background.jpg'));
BB=imread('icons/button_background.jpg');
axes(handles.axes1); imshow(BB);
axes(handles.axes2); imshow(BB);
axes(handles.axes3); imshow(BB);
axes(handles.axes4); imshow(BB);


% Choose default command line output for night_mode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes night_mode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = night_mode_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load param.mat;
[FileNames,PathName] = uigetfile({'*.jpg;*.bmp','Image Files (*.jpg,*.bmp)'},'',param.load_folder,'MultiSelect','on');
if ~iscell(FileNames)
    FileNames={FileNames};
end
if FileNames{1} ~= 0
    handles.files=FileNames';
    handles.path=PathName;
    handles.numf=numel(FileNames);
    set(handles.table,'Data',[handles.files,repmat({'ready'},handles.numf,1)]);
    if handles.numf>=17
        set(handles.table,'Position',[390,88,319,311]);
    else
        set(handles.table,'Position',[390,88,302,311]);
    end
    set(handles.start,'ForegroundColor','k');
    global stopcal;
    stopcal=0;
    guidata(hObject, handles);
else
    warndlg('No image was loaded!','Loading failed');
end

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.start,'ForegroundColor')==[0,0,0]
    load param.mat;
    set(handles.start,'ForegroundColor',[1,1,1]*0.5);
    set(handles.stop,'ForegroundColor','k');
    data=[handles.files,repmat({'queued'},handles.numf,1)];
    set(handles.table,'Data',data);
    for i=1:handles.numf
        data{i,2}='currently calibrated';
        set(handles.table,'Data',data);
        pause(1);
        global stopcal;
        if stopcal==0
            Im_org=imread([handles.path,handles.files{i}]);
            try
                run('cntrl_calibrate_image');
                save([handles.path,handles.files{i}(1:end-4)],'Im','ratio');
                data{i,2}='calibrated successfully';
            catch
                data{i,2}='calibration has failed';
            end
            set(handles.table,'Data',data);
        else
            data(i:end,2)=repmat({'canceled'},numel(data(i:end,2)),1);
            set(handles.table,'Data',data);
            break;
        end
    end
    set(handles.stop,'ForegroundColor',[1,1,1]*0.5);
else
    warndlg('No image is ready for calibration!','Error');
end

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.stop,'ForegroundColor')==[0,0,0]
    global stopcal;
    stopcal=1;
    set(handles.stop,'ForegroundColor',[1,1,1]*0.5);
else
    warndlg('Calibration hasn''t started yet!','Error');
end

% --- Executes on button press in main.
function main_Callback(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_main=evalin('base','h_main;');
if get(handles.stop,'ForegroundColor')==[0,0,0]
    choice=questdlg({'Are you sure?';'';'Only completed calibrations will be saved.'},'Exiting Night Mode','Yes','No','No');
    if strcmp(choice,'Yes')
        global stopcal;
        stopcal=1;
        set(h_main,'Visible','on');
        delete(handles.figure1);
    end
else
    set(h_main,'Visible','on');
    delete(handles.figure1);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_main=evalin('base','h_main;');
if get(handles.stop,'ForegroundColor')==[0,0,0]
    choice=questdlg({'Are you sure?';'';'Only completed calibrations will be saved.'},'Exiting Night Mode','Yes','No','No');
    if strcmp(choice,'Yes')
        global stopcal;
        stopcal=1;
        set(h_main,'Visible','on');
        delete(handles.figure1);
    end
else
    set(h_main,'Visible','on');
    delete(handles.figure1);
end
