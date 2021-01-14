% this code saves variables from GUI functions into the global workspace

%תמונה מכוילת
if exist('Im')
    assignin('base','Im',Im);
end

%רוחב ואורך התמונה
if exist('H') && exist('W')
    assignin('base','H',H);
    assignin('base','W',W);
end

%היסטוריית סימון
if exist('Im_mark_hist')
    assignin('base','Im_mark_hist',Im_mark_hist);
end

%ידית לתמונה המכוילת במסך הראשי
if exist('h_Im')
    assignin('base','h_Im',h_Im);
end

%יחס פיקסלים לס"מ
if exist('ratio')
    assignin('base','ratio',ratio);
end

%ידית לתמונה של הסטוריית הסימון במסך הראשי
if exist('h_Im_hist')
    assignin('base','h_Im_hist',h_Im_hist);
end

%מסכת נקודות, חתוכה ביחס מתאים
if exist('spot_mask_crop')
    assignin('base','spot_mask_crop',spot_mask_crop);
end

%ידיות למסך הראשי
if exist('h_main') && exist('h_main_process') && exist('h_main_prev_data') && exist('h_main_history')
    assignin('base','h_main',h_main);
    assignin('base','h_main_process',h_main_process);
    assignin('base','h_main_prev_data',h_main_prev_data);
    assignin('base','h_main_history',h_main_history);
end

%מסכת סימון משתמש
if exist('Im_mark')
    assignin('base','Im_mark',Im_mark);
end

%תמונה מכוילת עם נקודות מוקפות
if exist('Im_circ_crop')
    assignin('base','Im_circ_crop',Im_circ_crop);
end

%טבלת 3 נתוני נקודות
if exist('spot_data')
    assignin('base','spot_data',spot_data);
end

%רשימות הפיקסלים של הנקודות
if exist('spot_cc')
    assignin('base','spot_cc',spot_cc);
end

%ידית התמונה המוצגת במסך השני
if exist('h_edit_axes')
    assignin('base','h_edit_axes',h_edit_axes);
end

%ידית למסך השני
if exist('h_edit')
    assignin('base','h_edit',h_edit);
end

%מספר הנקודה שנבחרה במסך השני
if exist('selected_spot')
    assignin('base','selected_spot',selected_spot);
end

%תמונה חתוכה ביחס מתאים
if exist('Im_crop')
    assignin('base','Im_crop',Im_crop);
end

%רוחב ואורך התמונות החתוכות ביחס מתאים
if exist('h') && exist('w')
    assignin('base','h',h);
    assignin('base','w',w);
end

%מסכת סימון משתמש חתוכה ביחס מתאים
if exist('Im_mark_crop')
    assignin('base','Im_mark_crop',Im_mark_crop);
end

%שם קובץ תמונה
if exist('image_name')
    assignin('base','image_name',image_name);
end