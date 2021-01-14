% this code saves variables from GUI functions into the global workspace

%����� ������
if exist('Im')
    assignin('base','Im',Im);
end

%���� ����� ������
if exist('H') && exist('W')
    assignin('base','H',H);
    assignin('base','W',W);
end

%��������� �����
if exist('Im_mark_hist')
    assignin('base','Im_mark_hist',Im_mark_hist);
end

%���� ������ ������� ���� �����
if exist('h_Im')
    assignin('base','h_Im',h_Im);
end

%��� ������� ��"�
if exist('ratio')
    assignin('base','ratio',ratio);
end

%���� ������ �� �������� ������ ���� �����
if exist('h_Im_hist')
    assignin('base','h_Im_hist',h_Im_hist);
end

%���� ������, ����� ���� �����
if exist('spot_mask_crop')
    assignin('base','spot_mask_crop',spot_mask_crop);
end

%����� ���� �����
if exist('h_main') && exist('h_main_process') && exist('h_main_prev_data') && exist('h_main_history')
    assignin('base','h_main',h_main);
    assignin('base','h_main_process',h_main_process);
    assignin('base','h_main_prev_data',h_main_prev_data);
    assignin('base','h_main_history',h_main_history);
end

%���� ����� �����
if exist('Im_mark')
    assignin('base','Im_mark',Im_mark);
end

%����� ������ �� ������ ������
if exist('Im_circ_crop')
    assignin('base','Im_circ_crop',Im_circ_crop);
end

%���� 3 ����� ������
if exist('spot_data')
    assignin('base','spot_data',spot_data);
end

%������ �������� �� �������
if exist('spot_cc')
    assignin('base','spot_cc',spot_cc);
end

%���� ������ ������ ���� ����
if exist('h_edit_axes')
    assignin('base','h_edit_axes',h_edit_axes);
end

%���� ���� ����
if exist('h_edit')
    assignin('base','h_edit',h_edit);
end

%���� ������ ������ ���� ����
if exist('selected_spot')
    assignin('base','selected_spot',selected_spot);
end

%����� ����� ���� �����
if exist('Im_crop')
    assignin('base','Im_crop',Im_crop);
end

%���� ����� ������� ������� ���� �����
if exist('h') && exist('w')
    assignin('base','h',h);
    assignin('base','w',w);
end

%���� ����� ����� ����� ���� �����
if exist('Im_mark_crop')
    assignin('base','Im_mark_crop',Im_mark_crop);
end

%�� ���� �����
if exist('image_name')
    assignin('base','image_name',image_name);
end