% this code loads global data into GUI functions

%תמונה מכוילת
if evalin('base','exist(''Im'')')
    Im=evalin('base','Im;');
end

%רוחב ואורך התמונה
if evalin('base','exist(''H'')') && evalin('base','exist(''W'')')
    H=evalin('base','H;');
    W=evalin('base','W;');
end

%היסטוריית סימון
if evalin('base','exist(''Im_mark_hist'')')
    Im_mark_hist=evalin('base','Im_mark_hist;');
end

%ידית לתמונה המכוילת במסך הראשי
if evalin('base','exist(''h_Im'')')
    h_Im=evalin('base','h_Im;');
end

%יחס פיקסלים לס"מ
if evalin('base','exist(''ratio'')')
    ratio=evalin('base','ratio;');
end

%ידית לתמונה של הסטוריית הסימון במסך הראשי
if evalin('base','exist(''h_Im_hist'')')
    h_Im_hist=evalin('base','h_Im_hist;');
end

%מסכת נקודות, חתוכה ביחס מתאים
if evalin('base','exist(''spot_mask_crop'')')
    spot_mask_crop=evalin('base','spot_mask_crop;');
end

%ידית למסך הראשי
if evalin('base','exist(''h_main'')') && evalin('base','exist(''h_main_process'')') && evalin('base','exist(''h_main_prev_data'')') && evalin('base','exist(''h_main_history'')')
    h_main=evalin('base','h_main;');
    h_main_process=evalin('base','h_main_process;');
    h_main_prev_data=evalin('base','h_main_prev_data;');
    h_main_history=evalin('base','h_main_history;');
end

%מסכת סימון משתמש
if evalin('base','exist(''Im_mark'')')
    Im_mark=evalin('base','Im_mark;');
end

%תמונה מכוילת עם נקודות מוקפות
if evalin('base','exist(''Im_circ_crop'')')
    Im_circ_crop=evalin('base','Im_circ_crop;');
end

%טבלת 3 נתוני נקודות
if evalin('base','exist(''spot_data'')')
    spot_data=evalin('base','spot_data;');
end

%רשימות הפיקסלים של הנקודות
if evalin('base','exist(''spot_cc'')')
    spot_cc=evalin('base','spot_cc;');
end

%ידית התמונה המוצגת במסך השני
if evalin('base','exist(''h_edit_axes'')')
    h_edit_axes=evalin('base','h_edit_axes;');
end

%ידית למסך השני
if evalin('base','exist(''h_edit'')')
    h_edit=evalin('base','h_edit;');
end

%מספר הנקודה שנבחרה במסך השני
if evalin('base','exist(''selected_spot'')')
    selected_spot=evalin('base','selected_spot;');
end

%תמונה חתוכה ביחס מתאים
if evalin('base','exist(''Im_crop'')')
    Im_crop=evalin('base','Im_crop;');
end

%רוחב ואורך התמונות החתוכות ביחס מתאים
if evalin('base','exist(''h'')') && evalin('base','exist(''w'')')
    h=evalin('base','h;');
    w=evalin('base','w;');
end

%מסכת סימון משתמש חתוכה ביחס מתאים
if evalin('base','exist(''Im_mark_crop'')')
    Im_mark_crop=evalin('base','Im_mark_crop;');
end

%שם קובץ אקסל
if evalin('base','exist(''file_name'')')
    file_name=evalin('base','file_name;');
end

%שם קובץ תמונה
if evalin('base','exist(''image_name'')')
    image_name=evalin('base','image_name;');
end