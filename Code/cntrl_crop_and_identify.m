axes_ratio=1.310421286;
BB=regionprops(Im_mark,'BoundingBox');
x=round(BB.BoundingBox(1));
y=round(BB.BoundingBox(2));
xw=round(BB.BoundingBox(3));
yw=round(BB.BoundingBox(4));
x_old_coor=x:x+xw-1;
y_old_coor=y:y+yw-1;


Im_to_process=Im(y_old_coor,x_old_coor,:);
I_mark_to_process=Im_mark(y_old_coor,x_old_coor,:);
spot_mask=spot_identify(Im_to_process,I_mark_to_process,ratio);
if xw/yw<axes_ratio                                                        %long image
    new_w=round(yw*axes_ratio);
    x_new_coor=ceil((new_w-xw)/2)+[0:xw-1];
    y_new_coor=y_old_coor+1-y;
    
    Im_mark_crop=false(yw,new_w);
    spot_mask_crop=false(yw,new_w);
    Im_crop=uint8(cat(3,zeros(yw,new_w),zeros(yw,new_w),zeros(yw,new_w)));
else                                                                       %wide image
    new_w=round(xw/axes_ratio);
    x_new_coor=x_old_coor+1-x;
    y_new_coor=ceil((new_w-yw)/2)+[0:yw-1];
    
    spot_mask_crop=false(new_w,xw);
    Im_crop=uint8(cat(3,zeros(new_w,xw),zeros(new_w,xw),zeros(new_w,xw)));
    Im_mark_crop=false(new_w,xw);
end
Im_mark_crop(y_new_coor,x_new_coor)=Im_mark(y_old_coor,x_old_coor,:);
spot_mask_crop(y_new_coor,x_new_coor)=spot_mask;
Im_crop(y_new_coor,x_new_coor,:)=Im(y_old_coor,x_old_coor,:).*uint8(cat(3,Im_mark(y_old_coor,x_old_coor),Im_mark(y_old_coor,x_old_coor),Im_mark(y_old_coor,x_old_coor)));
[h,w]=size(spot_mask_crop);