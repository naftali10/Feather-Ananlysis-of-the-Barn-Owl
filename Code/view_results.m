function varargout = view_results(varargin)
% VIEW_RESULTS MATLAB code for view_results.fig
%      VIEW_RESULTS, by itself, creates a new VIEW_RESULTS or raises the existing
%      singleton*.
%
%      H = VIEW_RESULTS returns the handle to a new VIEW_RESULTS or the handle to
%      the existing singleton*.
%
%      VIEW_RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEW_RESULTS.M with the given input arguments.
%
%      VIEW_RESULTS('Property','Value',...) creates a new VIEW_RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before view_results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to view_results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help view_results

% Last Modified by GUIDE v2.5 02-Oct-2012 18:28:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @view_results_OpeningFcn, ...
                   'gui_OutputFcn',  @view_results_OutputFcn, ...
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


% --- Executes just before view_results is made visible.
function view_results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to view_results (see VARARGIN)
pos=get(handles.figure1,'Position');
newpos=round(get(0,'ScreenSize')/2-pos/2);
set(handles.figure1,'Position',[newpos(3) newpos(4) pos(3) pos(4)]);

set(handles.exit,'CData',imread('icons/back.jpg'));
set(handles.save,'CData',imread('icons/save.jpg'));

load_variables;
load param.mat;

switch param.area
        case 1
            ratio=ratio/10e4;
            handles.uA=' [sq. um]'; handles.uD=' [um]'; handles.uS=' [spot per sq. um]';
        case 2
            ratio=ratio/10;
            handles.uA=' [sq. mm]'; handles.uD=' [mm]'; handles.uS=' [spot per sq. mm]';
        case 3
            handles.uA=' [sq. cm]'; handles.uD=' [cm]'; handles.uS=' [spot per sq. cm]';
end

handles.amnt=numel(spot_data(:,1));
handles.area=mean(spot_data(:,1));
handles.dnct=numel(spot_data(:,1))/sum(sum(Im_mark_crop))*ratio;
handles.ecnt=mean(spot_data(:,2));
handles.dist=mean(spot_data(:,3));
handles.totArea=sum(sum(Im_mark))/(ratio^2);
handles.COM=regionprops(Im_mark,'Centroid');handles.COM=round(handles.COM.Centroid);

set(handles.text3,'String',sprintf('%d\n\n%.5f\n\n%.5f\n\n%.5f\n\n%.5f\n\n%.3f\n\n%g\n\n%g', ...
    handles.amnt, handles.area, handles.dnct, handles.ecnt, handles.dist, handles.totArea, handles.COM(1),handles.COM(2)));

Imr=Im_crop(:,:,1);
Img=Im_crop(:,:,2);
Imb=Im_crop(:,:,3);
handles.R_val=mean(Imr(logical(Im_mark_crop.*(~spot_mask_crop))));
handles.G_val=mean(Img(logical(Im_mark_crop.*(~spot_mask_crop))));
handles.B_val=mean(Imb(logical(Im_mark_crop.*(~spot_mask_crop))));

set(handles.R,'String',sprintf('R=%f',handles.R_val));
set(handles.G,'String',sprintf('G=%f',handles.G_val));
set(handles.B,'String',sprintf('B=%f',handles.B_val));
axes(handles.axes2);
imshow(0);
axes(handles.axes1);
imshow(uint8(cat(3,handles.R_val,handles.G_val,handles.B_val)));


set(handles.text2,'String',sprintf([...
'Number of spots:................................................................'...
'\n\n'...
'Average spot area%s:.................................................'...
'\n\n'...
'Density%s:..................................................'...
'\n\n'...
'Average eccentricity:..........................................................'...
'\n\n'...
'Average distance to the nearest neighbor%s:.....................'...
'\n\n'...
'Area processed%s:.........................................................'...
'\n\n'...
'X pixel of processed area''s center:.......................................'...
'\n\n'...
'Y pixel of processed area''s center:.......................................'...
    ],handles.uA,handles.uS,handles.uD,handles.uA));

% Choose default command line output for view_results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes view_results wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = view_results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_edit=evalin('base','h_edit;');
set(h_edit,'Visible','on');
delete(handles.figure1);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load_variables;
load param.mat;
note_text=num2str(get(handles.note,'String'));
if isempty(note_text)
    note_text='No note';
end;
%saving the data
if exist('file_name')==1
    org_dir=cd(param.save_folder);
    [~,~,file_data]=xlsread(file_name,'Sheet1','','basic');
    row=numel(file_data(:,1))+1;
    data={image_name,note_text,handles.amnt,handles.area,handles.dnct,handles.ecnt,handles.dist,handles.R_val,handles.G_val,handles.B_val,handles.totArea,handles.COM(1),handles.COM(2)};
    try success=xlswrite(file_name,data,'Sheet1',sprintf('A%d:M%d',row,row)); end
    cd(org_dir);
else
    file_name=['BarnOwl ',datestr(now,'yymmdd HH.MM'),'.xls'];
    titles={'Image name','Note','Number of spots',['Average spot area',handles.uA],['Density',handles.uS],'Average Eccentricity',['Average distance to the nearest neighbor',handles.uD],'Plumage R value','Plumage G value','Plumage B value',['Area processed',handles.uA],'X pixel of area''s center','Y pixel of area''s center'};
    data={image_name,note_text,handles.amnt,handles.area,handles.dnct,handles.ecnt,handles.dist,handles.R_val,handles.G_val,handles.B_val,handles.totArea,handles.COM(1),handles.COM(2)};
    org_dir=cd(param.save_folder);
    try success=xlswrite(file_name,[titles;data],'Sheet1'); end
    cd(org_dir);
end

if success
    assignin('base','file_name',file_name);
    evalin('base','Im_mark_hist=Im_mark_hist | Im_mark;');
    set(h_main_process,'ForegroundColor',[1,1,1]*0.5);
    set([h_main_prev_data,h_main_history],'ForegroundColor','k');

    set(h_main,'Visible','on');
    delete(h_edit);
    delete(handles.figure1);
else
    errordlg({'Something went wrong!';'';'Try saving again.'},'Error');
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_edit=evalin('base','h_edit;');
set(h_edit,'Visible','on');

% Hint: delete(hObject) closes the figure
delete(hObject);
