function varargout = edit_data(varargin)
% edit_data MATLAB code for edit_data.fig
%      edit_data, by itself, creates a new edit_data or raises the existing
%      singleton*.
%
%      H = edit_data returns the handle to a new edit_data or the handle to
%      the existing singleton*.
%
%      edit_data('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in edit_data.M with the given input arguments.
%
%      edit_data('Property','Value',...) creates a new edit_data or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edit_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edit_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edit_data

% Last Modified by GUIDE v2.5 22-Aug-2012 18:58:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edit_data_OpeningFcn, ...
                   'gui_OutputFcn',  @edit_data_OutputFcn, ...
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


% --- Executes just before edit_data is made visible.
function edit_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edit_data (see VARARGIN)
pos=get(handles.figure1,'Position');
newpos=round(get(0,'ScreenSize')/2-pos/2);
set(handles.figure1,'Position',[newpos(3) newpos(4) pos(3) pos(4)]);

set(handles.exit,'CData',imread('icons/back.jpg'));
set(handles.zoom_in,'CData',imread('icons/zoom_in.jpg'));
set(handles.zoom_out,'CData',imread('icons/zoom_out.jpg'));
set(handles.zoom_move,'CData',imread('icons/pan.jpg'));
set(handles.add,'CData',imread('icons/add.jpg'));
set(handles.delete,'CData',imread('icons/delete.jpg'));
set(handles.approve,'CData',imread('icons/approve.jpg'));
set(handles.add_draw,'CData',imread('icons/pen.jpg'));
set(handles.add_click,'CData',imread('icons/target.jpg'));
set(handles.delete_batch,'CData',imread('icons/delete_batch.jpg'));
set(handles.delete_draw,'CData',imread('icons/pen.jpg'));
set(handles.delete_click,'CData',imread('icons/target.jpg'));

load_variables;

axes(handles.axes1);
Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));
h_edit_axes=imshow(Im_circ_crop);

spot_stats;
set(handles.table,'Data',spot_data);
selected_spot=0;

save_variables;

load param.mat;
switch param.area
    case 1
        uA=' [sq. um]'; uD=' [um]';
    case 2
        uA=' [sq. mm]'; uD=' [mm]';
    case 3
        uA=' [sq. cm]'; uD=' [cm]';
end
set(handles.table,'ColumnName',{['Area',uA],'Eccentricity',['Nearest Distance',uD]});

if numel(spot_data(:,1))>23
    set(handles.table,'Position',[650,51,338,451]);
end


% Choose default command line output for edit_data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edit_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edit_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when selected cell(s) is changed in table.
function table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    if eventdata.Indices(:,1)==eventdata.Indices(1,1)
        load_variables;
        selected_spot=eventdata.Indices(1,1);
        selected_spot_mask=zeros(h,w); selected_spot_mask(spot_cc{selected_spot})=1;

        axes(handles.axes1); hold on;
        h_edit_axes_new=imshow(Im_circ_crop+uint8(cat(3,zeros(h,w),selected_spot_mask*50,zeros(h,w))));
        delete(h_edit_axes);
        h_edit_axes=h_edit_axes_new;
        save_variables;
    else
        warndlg('only one spot is allowed to be chosen!','Error');
    end
end


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.delete_cntrls,'Visible','off');
if strcmp(get(handles.add_cntrls,'Visible'),'off')
    set(handles.add_cntrls,'Visible','on');
else
    set(handles.add_cntrls,'Visible','off');
end

% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_spot=evalin('base','selected_spot;');
if selected_spot~=0
    evalin('base','spot_data=[spot_data(1:selected_spot-1,:);spot_data(selected_spot+1:end,:)];');
    evalin('base','spot_mask_crop(spot_cc{selected_spot})=0;');
    evalin('base','spot_cc=[spot_cc(1:selected_spot-1),spot_cc(selected_spot+1:end)];');
    evalin('base','Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));');

    % updating the picture
    load_variables;
    axes(handles.axes1); hold on;
    h_edit_axes_new=imshow(Im_circ_crop);
    delete(h_edit_axes);
    h_edit_axes=h_edit_axes_new;

    % updating the table
    set(handles.table,'Data',spot_data);
    selected_spot=0;

    save_variables;
else
    warndlg({'no spot was selected!';'';'no change has been made.'},'Error');
end
    
% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_main=evalin('base','h_main;');
set(h_main,'Visible','on');
delete(handles.figure1);


% --- Executes on button press in approve.
function approve_Callback(hObject, eventdata, handles)
% hObject    handle to approve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','h_edit',handles.figure1)
set(handles.figure1,'Visible','off');
view_results;

% --- Executes on button press in zoom_in.
function zoom_in_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
zoom(2);


% --- Executes on button press in zoom_out.
function zoom_out_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
zoom(0.5);


% --- Executes on button press in zoom_move.
function zoom_move_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
pan;


% --- Executes on button press in add_draw.
function add_draw_Callback(hObject, eventdata, handles)
% hObject    handle to add_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.add_cntrls,'Visible','off');
load_variables;

% getting the user's dawing
set(handles.notice,'Visible','on');
set(handles.edit_cntrls,'Visible','off');
axes(handles.axes1);
hnd=imfreehand;
wait(hnd);
temp=hnd.createMask;
set(handles.notice,'Visible','off');
set(handles.edit_cntrls,'Visible','on');
spot_mask_crop(temp)=true;
delete(hnd);

%updating the image
axes(handles.axes1); hold on;
Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));
h_edit_axes_new=imshow(Im_circ_crop);
delete(h_edit_axes);
h_edit_axes=h_edit_axes_new;

%updating the table
spot_stats;
set(handles.table,'Data',spot_data);
selected_spot=0;

save_variables;


% --- Executes on button press in add_click.
function add_click_Callback(hObject, eventdata, handles)
% hObject    handle to add_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.add_cntrls,'Visible','off');
set(handles.add_cntrls,'Visible','off');
load_variables;

% getting the user's click
set(handles.notice,'Visible','on');
set(handles.edit_cntrls,'Visible','off');
axes(handles.axes1);
hnd=impoint;
coor=wait(hnd);
set(handles.notice,'Visible','off');
set(handles.edit_cntrls,'Visible','on');
delete(hnd);

%identifying the spot
spot_mask_crop=add_spot(Im_crop,Im_mark_crop,spot_mask_crop,ratio,coor);

%updating the image
axes(handles.axes1); hold on;
Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));
h_edit_axes_new=imshow(Im_circ_crop);
delete(h_edit_axes);
h_edit_axes=h_edit_axes_new;

%updating the table
spot_stats;
set(handles.table,'Data',spot_data);
selected_spot=0;

save_variables;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_main=evalin('base','h_main;');
set(h_main,'Visible','on');

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in delete_batch.
function delete_batch_Callback(hObject, eventdata, handles)
% hObject    handle to delete_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.add_cntrls,'Visible','off');
if strcmp(get(handles.delete_cntrls,'Visible'),'off')
    set(handles.delete_cntrls,'Visible','on');
else
    set(handles.delete_cntrls,'Visible','off');
end


% --- Executes on key press with focus on table and none of its controls.
function table_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'delete')
    selected_spot=evalin('base','selected_spot;');
    if selected_spot~=0
        evalin('base','spot_data=[spot_data(1:selected_spot-1,:);spot_data(selected_spot+1:end,:)];');
        evalin('base','spot_mask_crop(spot_cc{selected_spot})=0;');
        evalin('base','spot_cc=[spot_cc(1:selected_spot-1),spot_cc(selected_spot+1:end)];');
        evalin('base','Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));');

        % updating the picture
        load_variables;
        axes(handles.axes1); hold on;
        h_edit_axes_new=imshow(Im_circ_crop);
        delete(h_edit_axes);
        h_edit_axes=h_edit_axes_new;

        % updating the table
        set(handles.table,'Data',spot_data);
        selected_spot=0;

        save_variables;
    else
        warndlg({'no spot was selected!';'';'no change has been made.'},'Error');
    end
end


% --- Executes on button press in delete_draw.
function delete_draw_Callback(hObject, eventdata, handles)
% hObject    handle to delete_draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.delete_cntrls,'Visible','off');
load_variables;

% getting the user's dawing
set(handles.notice,'Visible','on');
set(handles.edit_cntrls,'Visible','off');
axes(handles.axes1);
hnd=imfreehand;
wait(hnd);
set(handles.notice,'Visible','off');
set(handles.edit_cntrls,'Visible','on');
spot_mask_crop(createMask(hnd))=false;
delete(hnd);

%updating the image
axes(handles.axes1); hold on;
Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));
h_edit_axes_new=imshow(Im_circ_crop);
delete(h_edit_axes);
h_edit_axes=h_edit_axes_new;

%updating the table
spot_stats;
set(handles.table,'Data',spot_data);
selected_spot=0;

save_variables;

% --- Executes on button press in delete_click.
function delete_click_Callback(hObject, eventdata, handles)
% hObject    handle to delete_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.delete_cntrls,'Visible','off');
set(handles.edit_cntrls,'Visible','off');
set(handles.notice_stop,'Visible','on');

load_variables;

axes(handles.axes1);
[c,r,~]=impixel;
spot_mask_crop=spot_mask_crop.*~bwselect(spot_mask_crop,c,r);
set(handles.notice_stop,'Visible','off');
set(handles.edit_cntrls,'Visible','on');

%updating the image
axes(handles.axes1); hold on;
Im_circ_crop=Im_crop-uint8(cat(3,zeros(h,w),edge(spot_mask_crop)*50,zeros(h,w)));
h_edit_axes_new=imshow(Im_circ_crop);
delete(h_edit_axes);
h_edit_axes=h_edit_axes_new;

%updating the table
spot_stats;
set(handles.table,'Data',spot_data);
selected_spot=0;

save_variables;
