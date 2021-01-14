%'Im_org' is the original image
[x_sun,y_sun]=sun_identify(Im_org);
[crd_angle,crd_lngth]=square_identify(Im_org,x_sun,y_sun);
[Im,ratio]=image_calibration(Im_org,x_sun,y_sun,crd_angle,crd_lngth);