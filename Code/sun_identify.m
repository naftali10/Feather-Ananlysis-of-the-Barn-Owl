function[x,y]=sun_identify(Im)                                             %gets an image, and gives the coordinates of the BW "sun"
    Im=(double(rgb2gray(Im))-128)/256;                                     %normalizing the image into the boundries [-0.5,0.5]
    load param.mat;
    %% creating the "sun" kernel
    [ImH,ImW]=size(Im);
    N=round(0.5*sqrt(0.0311*ImH*ImW*param.card));                          %half of the size of the correlation "sun" kernel
    [X,Y]=meshgrid(-N:N,N:-1:-N);                                          %creating a cartesian space
    THETA=cart2pol(X,Y);                                                   %matrix the same size as X or Y, containing the angle (in radians) of each coordinat
    THETA(sign(THETA)==-1)=2*pi+THETA(sign(THETA)==-1);                    %angles are within [0,2pi] and not [-pi,pi]
    sun1=THETA;
    sun2=THETA;
    
    B_or_W=0;                                                              %initializing the filling color
    for i=0:23
        theta_min=(i/24)*2*pi;                                             %each homogenous area is 15 degrees wide
        theta_max=theta_min+2*pi/24;
        sun1(logical((THETA>=theta_min).*(THETA<=theta_max)))=B_or_W;
        B_or_W=1-B_or_W;
    end
    
    B_or_W=0;                                                              %initializing the filling color
    for i=-1:23
        theta_min=2*pi/48+(i/24)*2*pi;                                     %filling is starting at a different angle, this createl a rotated "sun" by 7 degrees
        theta_max=theta_min+2*pi/24;
        sun2(logical((THETA>=theta_min).*(THETA<=theta_max)))=B_or_W;
        B_or_W=1-B_or_W;
    end
    sun1=sun1-0.5; sun2=sun2-0.5;                                          %normalizing the "suns" into the boundries [-0.5,0.5]
    sun1=sun1-mean(mean(sun1)); sun2=sun2-mean(mean(sun2));                %keeping the mean value as zero
    %% finding the best fit with the image
    corrsun1=abs(xcorr2(Im,sun1));                                              %each (x,y) pixel shows the correlation value obtained when putting "sun1"'s most right and lowest pixel in (x,y) of "Im"
    corrsun2=abs(xcorr2(Im,sun2));
       
    corrsun=corrsun1+corrsun2;
       
    [maxval,maxindy]=max(corrsun);                                         %biggest values in each column and their y indexes
    [topcorr,maxindx]=max(maxval);                                         %the highest correlation value with sun1 and its x index
    maxindy=maxindy(maxval==topcorr);                                      %the y index of the highest correlation value
    maxindx=maxindx(1); maxindy=maxindy(1);                                %solution for multiple maximums
    
    x=maxindx-N;                                                           %the horizontal coordinate
    y=maxindy-N;                                                           %the vertical coordinate
end