function varargout = load_image(varargin)
% LOAD_IMAGE MATLAB code for load_image.fig
%      LOAD_IMAGE, by itself, creates a new LOAD_IMAGE or raises the existing
%      singleton*.
%
%      H = LOAD_IMAGE returns the handle to a new LOAD_IMAGE or the handle to
%      the existing singleton*.
%
%      LOAD_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOAD_IMAGE.M with the given input arguments.
%
%      LOAD_IMAGE('Property','Value',...) creates a new LOAD_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before load_image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to load_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help load_image

% Last Modified by GUIDE v2.5 31-Aug-2012 18:02:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @load_image_OpeningFcn, ...
                   'gui_OutputFcn',  @load_image_OutputFcn, ...
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


% --- Executes just before load_image is made visible.
function load_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to load_image (see VARARGIN)
pos=get(handles.figure1,'Position');
newpos=round(get(0,'ScreenSize')/2-pos/2);
set(handles.figure1,'Position',[newpos(3) newpos(4) pos(3) pos(4)]);

axes(handles.axes6);imshow(0);axis normal;
axes(handles.axes7);imshow(0);axis normal;

set(handles.mark_fixed,'CData',imread('icons/move.jpg'));
set(handles.mark_rect,'CData',imread('icons/resize.jpg'));
set(handles.mark_free,'CData',imread('icons/pen.jpg'));
set(handles.zoom_in,'CData',imread('icons/zoom_in.jpg'));
set(handles.zoom_out,'CData',imread('icons/zoom_out.jpg'));
set(handles.zoom_move,'CData',imread('icons/pan.jpg'));
set(handles.help,'CData',imread('icons/help.jpg'));
set(handles.options,'CData',imread('icons/options.jpg'));

axes(handles.axes2);imshow(imread('logos/technion.jpg'));
axes(handles.axes3);imshow(imread('logos/ee.jpg'));
axes(handles.axes4);imshow(imread('logos/sipl.jpg'));
axes(handles.axes5);imshow(imread('logos/tau.jpg'));



% Choose default command line output for load_image
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes load_image wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = load_image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in exit_button.
function exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to exit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','clear all');
clear all; close all;


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.clear,'ForegroundColor')==[0,0,0]
    cla(handles.axes1);
    set([handles.clear,handles.mark,handles.prev_data,handles.process,handles.history],'ForegroundColor',[1,1,1]*0.5);
    set([handles.im_cntrls,handles.mark_cntrls],'Visible','off');
    set(handles.history,'String','show history');
else
    warndlg('no image is displayed!','Error');
end


% --- Executes on button press in browse.
function Im = browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.notice_load,'Visible','on');
load param.mat;
[FileName,PathName] = uigetfile({'*.jpg;*.bmp','Image Files (*.jpg,*.bmp)'},'',param.load_folder);
if FileName ~= 0
    image_name=FileName(1:end-4);
    evalin('base','clear file_name');
    if exist([PathName,image_name,'.mat'])
        load([PathName,image_name,'.mat'])
        [H,W,~]=size(Im);
    else
        choice=questdlg({'Image is not calibrated. Do you want to calibrate now?';'';'Notice: Calibration can take several minutes. It can be done conveniently using Night Mode.'},'Uncalibrated image','Yes','No','No');
        if strcmp(choice,'Yes')
            Im_org=imread([PathName,FileName]);
            [H,W,~]=size(Im_org);
            try
            cntrl_calibrate_image;
            catch
                errordlg({'Image calibration has failed!';'';'Make sure that the WhiBal card is present.'},'Loading Failed');
            end
        else
            set(handles.notice_load,'Visible','off');
            return;
        end
    end
    Im_mark_hist=zeros(H,W);
    cla(handles.axes1);
    axes(handles.axes1);
    try h_Im=imshow(Im); end
    set([handles.clear,handles.mark],'ForegroundColor','k');
    set([handles.prev_data,handles.process,handles.history],'ForegroundColor',[1,1,1]*0.5);
    set(handles.history,'String','show history');
    set(handles.im_cntrls,'Visible','on');
    save_variables;
else
    warndlg('No image was loaded!','Loading failed');
end
set(handles.notice_load,'Visible','off');

% --- Executes on button press in prev_data.
function prev_data_Callback(hObject, eventdata, handles)
% hObject    handle to prev_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.prev_data,'ForegroundColor')==[0,0,0]
    prev_data;
else
    warndlg('There is no previous data!','Error');
end

% --- Executes on button press in mark.
function mark_Callback(hObject, eventdata, handles)
% hObject    handle to mark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.mark,'ForegroundColor')==[0,0,0]
    if strcmp(get(handles.mark_cntrls,'Visible'),'off')
        set(handles.mark_cntrls,'Visible','on');
    else
        set(handles.mark_cntrls,'Visible','off');
    end
else
    if get(handles.clear,'ForegroundColor')==[0,0,0]
        warndlg('First complete current marking!','Error');
    else
        warndlg('No image is displayed!','Error');
    end
end


% --- Executes on button press in history.
function history_Callback(hObject, eventdata, handles)
% hObject    handle to history (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.history,'ForegroundColor')==[0,0,0]
    load_variables;
    if get(handles.history,'String')=='show history'
        h_Im=evalin('base','h_Im;');
        Im_mark_hist=evalin('base','Im_mark_hist;');
        axes(handles.axes1); hold on;
        h_Im_hist=imshow(Im-uint8(cat(3,zeros(H,W),Im_mark_hist*100,zeros(H,W))));
        delete(h_Im);
        save_variables;
        set(handles.history,'String','hide history');
    else
        axes(handles.axes1); hold on;
        h_Im=imshow(Im);
        delete(h_Im_hist);
        save_variables;
        set(handles.history,'String','show history');
    end
else
    warndlg('there is no marking history!','Error');
end


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.process,'ForegroundColor')==[0,0,0]
    load_variables;
    cntrl_crop_and_identify;
    h_main=handles.figure1;
    h_main_process=handles.process;
    h_main_prev_data=handles.prev_data;
    h_main_history=handles.history;
    save_variables;
    set(handles.figure1,'Visible','off');
    edit_data;
else
    warndlg('no image area was marked!','Error');
end


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


% --- Executes on button press in mark_rect.
function mark_rect_Callback(hObject, eventdata, handles)
% hObject    handle to mark_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mark_cntrls,'Visible','off');
set(handles.notice,'Visible','on');
set(handles.mark,'ForegroundColor',[1,1,1]*0.5);
axes(handles.axes1);
[~,rct]=imcrop;
set(handles.notice,'Visible','off');
h=imrect(handles.axes1,rct);
Im_mark=createMask(h);
delete(h);
set(handles.mark,'ForegroundColor',[0,0,0]);
if sum(find(Im_mark))~=0
    assignin('base','Im_mark',Im_mark);
    set(handles.process,'ForegroundColor','k');
else
    warndlg({'no image area was marked!';'';'last marking is still relevant.'},'Error');
end


% --- Executes on button press in mark_free.
function mark_free_Callback(hObject, eventdata, handles)
% hObject    handle to mark_free (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mark_cntrls,'Visible','off');
set(handles.notice,'Visible','on');
set(handles.mark,'ForegroundColor',[1,1,1]*0.5);
axes(handles.axes1);
h=imfreehand;
wait(h);
set(handles.notice,'Visible','off');
Im_mark=createMask(h);
delete(h);
set(handles.mark,'ForegroundColor',[0,0,0]);
if sum(find(Im_mark))~=0
    assignin('base','Im_mark',Im_mark);
    set(handles.process,'ForegroundColor','k');
else
    warndlg({'no image area was marked!';'';'last marking is still relevant.'},'Error');
end

% --- Executes on button press in mark_fixed.
function mark_fixed_Callback(hObject, eventdata, handles)
% hObject    handle to mark_fixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mark_cntrls,'Visible','off');
set(handles.notice,'Visible','on');
set(handles.mark,'ForegroundColor',[1,1,1]*0.5);
load_variables;
load param.mat;
fixed_W=ratio*param.fixed_width;
fixed_H=ratio*param.fixed_hight;
ctr_x=round(W/2);
ctr_y=round(H/2);
h=impoly(handles.axes1,[1 1;fixed_W 1;fixed_W fixed_H;1 fixed_H]+repmat([ctr_x,ctr_y],4,1));
setVerticesDraggable(h,0);
h_struct.h=h; h_struct.ngl=0;
assignin('base','h_Im_mark_struct',h_struct);
set(handles.angle,'Visible','on');
wait(h);
set([handles.notice,handles.angle],'Visible','off');
Im_mark=createMask(h);
delete(h);
set(handles.mark,'ForegroundColor',[0,0,0]);
if sum(find(Im_mark))~=0
    assignin('base','Im_mark',Im_mark);
    set(handles.process,'ForegroundColor','k');
else
    warndlg({'no image area was marked!';'';'last marking is still relevant.'},'Error');
end


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help;

% --- Executes on button press in options.
function options_Callback(hObject, eventdata, handles)
% hObject    handle to options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options;


% --- Executes on slider movement.
function angle_Callback(hObject, eventdata, handles)
% hObject    handle to angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
h=evalin('base','h_Im_mark_struct;');
new_ngl=get(hObject,'Value');
ngl=new_ngl-h.ngl;
pos=getPosition(h.h);
COR=[mean(pos([1,3],1)),mean(pos([1,3],2))];                               %center of rectangle
pos=pos-repmat(COR,4,1);
newPos(:,1)=pos(:,1)*cosd(ngl)-pos(:,2)*sind(ngl);
newPos(:,2)=pos(:,2)*cosd(ngl)+pos(:,1)*sind(ngl);
newPos=newPos+repmat(COR,4,1);
setPosition(h.h,newPos);
h.ngl=new_ngl;
assignin('base','h_Im_mark_struct',h);


% --- Executes on button press in night.
function night_Callback(hObject, eventdata, handles)
% hObject    handle to night (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_main=handles.figure1;
assignin('base','h_main',h_main);
set(h_main,'Visible','off');
night_mode;
