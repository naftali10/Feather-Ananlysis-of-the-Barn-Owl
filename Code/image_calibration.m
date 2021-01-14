function[Im_clb,ratio]=image_calibration(Im,x,y,angle,lngth)
%input: owl's image; ;WhiBal card's lngth and angle(in degrees), calculated by 'square identify' function
%output: a calibrated image; the image's pixel-to-centimeter ratio
    %% size calibration
    L=8.52;                                                                %card's lenght in cm
    ratio=lngth/L;                                                         %image's pixel/cm ratio
    %% color calibration
    % desired calibration card levels:
    b=31; g=165; w=200;
    e=1e-3;                                                                %a small constant, designed to assure the interpulation's functionality
    ang_r=angle/180*pi;                                                    %converting the angle to radians
    m_b_y=round(y-sin(ang_r)*0.27*lngth);                                        %centered measuring y coordinate
    m_b_x=round(x+cos(ang_r)*0.27*lngth);                                        %centered measuring x coordinate
    m_b=round(mean(mean(Im(m_b_y+[-10:10],m_b_x+[-10:10],:))));            %measured black
    m_w_y=round(y-sin(ang_r)*0.62*lngth-sin(ang_r-pi/2)*0.015*lngth);             %centered measuring y coordinate
    m_w_x=round(x+cos(ang_r)*0.62*lngth+cos(ang_r-pi/2)*0.015*lngth);             %centered measuring x coordinate
    m_w=round(mean(mean(Im(m_w_y+[-10:10],m_w_x+[-10:10],:))));            %measured white
    m_g_y=round(y-sin(ang_r-pi/2)*0.3*lngth);                                    %centered measuring y coordinate
    m_g_x=round(x+cos(ang_r-pi/2)*0.3*lngth);                                    %centered measuring x coordinate
    m_g=round(mean(mean(Im(m_g_y+[-10:10],m_g_x+[-10:10],:))));            %measured gray
    for i=1:3
        LUT=round(interp1([0+e,m_b(i),m_g(i),m_w(i),255+e],...
                          [0,b,g,w,255],0:255)               );            %maching the measured values to the wanted ones
        LUT=cast(LUT,'uint8');
        Im_clb(:,:,i)=intlut(Im(:,:,i),LUT);
    end
%     figure, imshow(Im(m_b_y+[-10:10],m_b_x+[-10:10],:));
%     figure, imshow(Im(m_w_y+[-10:10],m_w_x+[-10:10],:));
%     figure, imshow(Im(m_g_y+[-10:10],m_g_x+[-10:10],:));
end