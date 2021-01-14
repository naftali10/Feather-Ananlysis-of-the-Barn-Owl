function[color]=plumage_color(Im,spot_mask,Im_mark)
% input: calibrated image, spot mask, marking mask
% output: plumage color in RGB
    Imr=Im(:,:,1);
    Img=Im(:,:,2);
    Imb=Im(:,:,3);
    color(1)=mean(mean(Imr(spot_mask==0 & Im_mark==1)));
    color(2)=mean(mean(Img(spot_mask==0 & Im_mark==1)));
    color(3)=mean(mean(Imb(spot_mask==0 & Im_mark==1)));
end