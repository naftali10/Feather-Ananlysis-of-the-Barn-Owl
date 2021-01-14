%function[spot_data]=spot_stats(spot_mask_crop, ratio)
%input: spot mask binary image (cropped acoording to user's marking), pix/cm ratio
%output: table of individual spot properties: area, minimal distance, eccentricity

    objects=bwconncomp(spot_mask_crop);
    props=regionprops(objects,'Area','Eccentricity','Centroid');
    spot_cc=objects.PixelIdxList;
    load param.mat;
    switch param.area
        case 1
            ratio_new=ratio/(10^4);
        case 2
            ratio_new=ratio/10;
        case 3
            ratio_new=ratio;
    end
    
    size=[props.Area]/(ratio_new^2);
    ecntr=[props.Eccentricity];
    if objects.NumObjects>1
        cntrs=reshape([props.Centroid],2,[])';                                 %each row is an objects mass-center coordinates
        for i=1:objects.NumObjects
            j_no_i=1:objects.NumObjects; j_no_i(i)=[];
            for j=j_no_i
                dis(j)=sqrt((cntrs(i,1)-cntrs(j,1))^2+(cntrs(i,2)-cntrs(j,2))^2);
            end
            mindis(i)=min(dis(j_no_i));
        end
        mindis=mindis/ratio_new;
    else
        mindis=0;
    end
    spot_data=[size;ecntr;mindis]';