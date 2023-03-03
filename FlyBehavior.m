function varargout = FlyBehavior(varargin)
% FLYBEHAVIOR MATLAB code for FlyBehavior.fig
%      FLYBEHAVIOR, by itself, creates a new FLYBEHAVIOR or raises the existing
%      singleton*.
%
%      H = FLYBEHAVIOR returns the handle to a new FLYBEHAVIOR or the handle to
%      the existing singleton*.
%
%      FLYBEHAVIOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLYBEHAVIOR.M with the given input arguments.
%
%      FLYBEHAVIOR('Property','Value',...) creates a new FLYBEHAVIOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FlyBehavior_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FlyBehavior_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FlyBehavior

% Last Modified by GUIDE v2.5 26-Aug-2015 15:17:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FlyBehavior_OpeningFcn, ...
                   'gui_OutputFcn',  @FlyBehavior_OutputFcn, ...
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


% --- Executes just before FlyBehavior is made visible.
function FlyBehavior_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FlyBehavior (see VARARGIN)

% Choose default command line output for FlyBehavior
handles.output = hObject;
global NumberOfAvi
NumberOfAvi = 1;
global TimerSecond
TimerSecond = 0;
set(handles.textFolder,'string',pwd);
set(handles.editComments,'string','Place for comments');
handles.vid = videoinput('gige');
src = handles.vid.Source;
src.PacketDelay = 1000;
src.PacketSize  = 1500;
src.ExposureMode = 'ContinuousProgrammable';
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';
preview(handles.vid);
pause(1);
% 
% handles.vid = videoinput('winvideo');
% preview(handles.vid);

% 
% % Start values
set(handles.sliderContinuousProgrammable,'value',src.ContinuousProgrammable); set(handles.editContinuousProgrammable,'string',num2str(src.ContinuousProgrammable));
set(handles.sliderTap1BlackLevelRaw,'value',src.Tap1BlackLevelRaw); set(handles.editTap1BlackLevelRaw,'string',num2str(src.Tap1BlackLevelRaw));
% set(handles.sliderTap2BlackLevelRaw,'value',src.Tap2BlackLevelRaw); set(handles.editTap2BlackLevelRaw,'string',num2str(src.Tap2BlackLevelRaw));
set(handles.sliderTap1GainRaw,'value',src.Tap1GainRaw); set(handles.editTap1GainRaw,'string',num2str(src.Tap1GainRaw));
% set(handles.sliderTap2GainRaw,'value',src.Tap2GainRaw); set(handles.editTap2GainRaw,'string',num2str(src.Tap2GainRaw));
set(handles.editKneeX1,'string',num2str(src.KneeX1));
set(handles.editKneeX2,'string',num2str(src.KneeX2));
set(handles.editKneeY1,'string',num2str(src.KneeY1));
set(handles.editKneeY2,'string',num2str(src.KneeY2));
% set(handles.popupKnee,'string',{'Red','Green','Blue'});
% src.GainAutoBalance = 'Once';
% src.DigitalVideoOutputOrder = 'C';
% Binary Timer
% Update handles structure
handles.pwd = pwd;
handles.Timer = timer;
handles.Timer.Period = 1;
handles.Timer.ExecutionMode = 'fixedspacing';
handles.Timer.TimerFcn = {@seconds_update,handles};
guidata(hObject, handles);


% UIWAIT makes FlyBehavior wait for user response (see UIRESUME)
% uiwait(handles.figure1);






% --- Outputs from this function are returned to the command line.
function varargout = FlyBehavior_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try closepreview(handles.vid); catch, end
try delete(handles.vid); catch, end
% Hint: delete(hObject) closes the figure
delete(hObject);




% --- Executes on button press in pbFolder.
function pbFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pbFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directoryname = uigetdir('D:\APPLICATIONS\MATLAB', 'Pick a Directory');
if directoryname ~= 0
    set(handles.textFolder,'string',directoryname);
end



function editPrefix_Callback(hObject, eventdata, handles)
% hObject    handle to editPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPrefix as text
%        str2double(get(hObject,'String')) returns contents of editPrefix as a double
global NumberOfAvi
set(handles.textNextAvi,'string',[get(hObject,'String'),sprintf('%03d',NumberOfAvi) ,'.avi']);

% --- Executes during object creation, after setting all properties.
function editPrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbStart.
function pbStart_Callback(hObject, eventdata, handles)
% hObject    handle to pbStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NumberOfAvi
global TimerSecond

str = get(hObject,'String');

if strcmp(str,'Start Experiment') == 0
    % Stopp
    set(hObject,'String','Start Experiment');
    set(handles.textExperiment,'String','No logging');
    set(handles.textEnd,'string',datestr(now));
    stop(handles.vid);
    close(handles.vidObj);
    stop(handles.Timer);
elseif strcmp (str,'Stop Experiment') == 0
    % Start
    TimerSecond = 0;
    set(hObject,'String','Stop Experiment');
    set(handles.textExperiment,'string','Logging');
    set(handles.textStart,'string',datestr(now));
    mkdir      ([get(handles.textFolder,'string'),'\',get(handles.editPrefix,'string'),datestr(now,'yyyy-mm-dd_HH_MM'),'-No',sprintf('%03d',NumberOfAvi)]);
    file =      [get(handles.textFolder,'string'),'\',get(handles.editPrefix,'string'),datestr(now,'yyyy-mm-dd_HH_MM'),'-No',sprintf('%03d',NumberOfAvi),'\',get(handles.textNextAvi,'string')];
    fid = fopen([get(handles.textFolder,'string'),'\',get(handles.editPrefix,'String'),datestr(now,'yyyy-mm-dd_HH_MM'),'-No',sprintf('%03d',NumberOfAvi),'\','Comments.txt'],'w');
    
    str = get(handles.editComments,'String');
    [nn,waste] = size(str);
    for i = 1:nn
    fprintf(fid,'%s\r\n',str(i,:));
    end
    fclose(fid);
    
    handles.vidObj = VideoWriter(file);
    handles.vidObj.FrameRate = 100;
    handles.vid.DiskLogger = handles.vidObj;
    handles.vid.FramesPerTrigger = inf;
    handles.vid.LoggingMode = 'disk';
    open(handles.vidObj);
    start(handles.vid);
    NumberOfAvi = NumberOfAvi + 1;
    set(handles.textNextAvi,'string',[get(handles.editPrefix,'String'),sprintf('%03d',NumberOfAvi) ,'.avi']);
    cd(handles.pwd);
    start(handles.Timer);
    guidata(hObject, handles);
end


% --- Executes on slider movement.
function sliderContinuousProgrammable_Callback(hObject, eventdata, handles)
% hObject    handle to sliderContinuousProgrammable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject,'Value'));
set(handles.editContinuousProgrammable,'string',num2str(val));
src = handles.vid.Source;
src.ContinuousProgrammable = val;
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';

% --- Executes during object creation, after setting all properties.
function sliderContinuousProgrammable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderContinuousProgrammable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editContinuousProgrammable_Callback(hObject, eventdata, handles)
% hObject    handle to editContinuousProgrammable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContinuousProgrammable as text
%        str2double(get(hObject,'String')) returns contents of editContinuousProgrammable as a double
val = round(str2double(get(hObject,'String')));
if val > 499, val = 499; elseif val < 0, val = 0; end
set(hObject,'string',num2str(val));
set(handles.sliderContinuousProgrammable,'value',val);
src = handles.vid.Source;
src.ContinuousProgrammable = val;
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';

% --- Executes during object creation, after setting all properties.
function editContinuousProgrammable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContinuousProgrammable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderTap1BlackLevelRaw_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTap1BlackLevelRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject,'Value'));
set(handles.editTap1BlackLevelRaw,'string',num2str(val));
src = handles.vid.Source;
src.Tap1BlackLevelRaw = val;
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';

% --- Executes during object creation, after setting all properties.
function sliderTap1BlackLevelRaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTap1BlackLevelRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editTap1BlackLevelRaw_Callback(hObject, eventdata, handles)
% hObject    handle to editTap1BlackLevelRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTap1BlackLevelRaw as text
%        str2double(get(hObject,'String')) returns contents of editTap1BlackLevelRaw as a double
val = round(str2double(get(hObject,'String')));
if val > 511, val = 511; elseif val < 0, val = 0; end
set(hObject,'string',num2str(val));
set(handles.sliderTap1BlackLevelRaw,'value',val);
src = handles.vid.Source;
src.Tap1BlackLevelRaw = val;
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';

% --- Executes during object creation, after setting all properties.
function editTap1BlackLevelRaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTap1BlackLevelRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function sliderTap1GainRaw_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTap1GainRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject,'Value'));
set(handles.editTap1GainRaw,'string',num2str(val));
src = handles.vid.Source;
src.Tap1GainRaw = val;
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';

% --- Executes during object creation, after setting all properties.
function sliderTap1GainRaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTap1GainRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editTap1GainRaw_Callback(hObject, eventdata, handles)
% hObject    handle to editTap1GainRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTap1GainRaw as text
%        str2double(get(hObject,'String')) returns contents of editTap1GainRaw as a double
val = round(str2double(get(hObject,'String')));
if val > 488, val = 488; elseif val < 66, val = 66; end
set(hObject,'string',num2str(val));
set(handles.sliderTap1GainRaw,'value',val);
src = handles.vid.Source;
src.Tap1GainRaw = val;
src.GainAutoBalance = 'Once';
src.BlackLevelAutoBalance = 'Continuous';

% --- Executes during object creation, after setting all properties.
function editTap1GainRaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTap1GainRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pbKnee.
function pbKnee_Callback(hObject, eventdata, handles)
% hObject    handle to pbKnee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% stop(handles.binTimer);
h = waitbar(1/10,'Please wait while changing the values...');
stoppreview(handles.vid);
delete(handles.vid);
waitbar(2/10,h,'Please wait while changing the values...');
imaqreset
pause(2),
waitbar(3/10,h,'Please wait while changing the values...');
handles.vid = gigecam;
% preview(handles.vid);
waitbar(4/10,h,'Please wait while changing the values...');

handles.vid.KneeX1 =  str2double(get(handles.editKneeX1,'string'));
handles.vid.KneeX2 =  str2double(get(handles.editKneeX2,'string'));
handles.vid.KneeY1 =  str2double(get(handles.editKneeY1,'string'));
handles.vid.KneeY2 =  str2double(get(handles.editKneeY2,'string'));
waitbar(5/10,h,'Please wait while changing the values...');
executeCommand(handles.vid,'KneeSet');

% closePreview(handles.vid);
waitbar(6/10,h,'Please wait while changing the values...');
delete(handles.vid);
waitbar(7/10,h,'Please wait while changing the values...');
pause(2);
waitbar(8/10,h,'Please wait while changing the values...');
handles.vid = videoinput('gige');
waitbar(9/10,h,'Please wait while changing the values...');
preview(handles.vid);
waitbar(10/10,h,'Please wait while changing the values...');
close(h);
% % Binary Timer
% handles.binTimer = timer;
% handles.binTimer.Period = 0.25;
% handles.binTimer.ExecutionMode = 'fixedspacing';
% handles.binTimer.TimerFcn = {@bin_frame_update,handles};
% start(handles.binTimer);
guidata(hObject, handles);



function editKneeX1_Callback(hObject, eventdata, handles)
% hObject    handle to editKneeX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editKneeX1 as text
%        str2double(get(hObject,'String')) returns contents of editKneeX1 as a double
val = round(str2double(get(hObject,'String')));
if val >= str2double(get(handles.editKneeX2,'string')), val = str2double(get(handles.editKneeX2,'string')) - 1; elseif val < 0, val = 0; end
set(hObject,'string',num2str(val));

% --- Executes during object creation, after setting all properties.
function editKneeX1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editKneeX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editKneeX2_Callback(hObject, eventdata, handles)
% hObject    handle to editKneeX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editKneeX2 as text
%        str2double(get(hObject,'String')) returns contents of editKneeX2 as a double
val = round(str2double(get(hObject,'String')));
if val > 255, val = 255; elseif val <= str2double(get(handles.editKneeX1,'string')), val = str2double(get(handles.editKneeX1,'string')) + 1; end
set(hObject,'string',num2str(val));

% --- Executes during object creation, after setting all properties.
function editKneeX2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editKneeX2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editKneeY1_Callback(hObject, eventdata, handles)
% hObject    handle to editKneeY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editKneeY1 as text
%        str2double(get(hObject,'String')) returns contents of editKneeY1 as a double
val = round(str2double(get(hObject,'String')));
if val >= str2double(get(handles.editKneeY2,'string')), val = str2double(get(handles.editKneeY2,'string')) - 1; elseif val < 0, val = 0; end
set(hObject,'string',num2str(val));

% --- Executes during object creation, after setting all properties.
function editKneeY1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editKneeY1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editKneeY2_Callback(hObject, eventdata, handles)
% hObject    handle to editKneeY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editKneeY2 as text
%        str2double(get(hObject,'String')) returns contents of editKneeY2 as a double
val = round(str2double(get(hObject,'String')));
if val > 255, val = 255; elseif val <= str2double(get(handles.editKneeY1,'string')), val = str2double(get(handles.editKneeY1,'string')) + 1; end
set(hObject,'string',num2str(val));

% --- Executes during object creation, after setting all properties.
function editKneeY2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editKneeY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupKnee.
function popupKnee_Callback(hObject, eventdata, handles)
% hObject    handle to popupKnee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupKnee contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupKnee


% --- Executes during object creation, after setting all properties.
function popupKnee_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupKnee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function seconds_update(obj,event,handles)
global TimerSecond
TimerSecond = 1 + TimerSecond;
set(handles.textDuration,'String',secs2hms(TimerSecond));



function editComments_Callback(hObject, eventdata, handles)
% hObject    handle to editComments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editComments as text
%        str2double(get(hObject,'String')) returns contents of editComments as a double


% --- Executes during object creation, after setting all properties.
function editComments_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editComments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editComments2_Callback(hObject, eventdata, handles)
% hObject    handle to editComments2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editComments2 as text
%        str2double(get(hObject,'String')) returns contents of editComments2 as a double


% --- Executes during object creation, after setting all properties.
function editComments2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editComments2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editComments3_Callback(hObject, eventdata, handles)
% hObject    handle to editComments3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editComments3 as text
%        str2double(get(hObject,'String')) returns contents of editComments3 as a double


% --- Executes during object creation, after setting all properties.
function editComments3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editComments3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
