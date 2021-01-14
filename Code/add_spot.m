function[spot_mask]=add_spot(Im,Im_mark,spot_mask,ratio,spot_coor)
% input: an image, its relevant area mask, its pixel-to-centimeter ratio, its current spot mask, and a pixel from an unmasked spot
% output: a new spots mask which includes the unmasked spot
    load param.mat;
    [ImH,ImW,~]=size(Im);
    avg_spt=ratio*param.spot_rad;                                          %average spot radius in pixels
    avg_spt_area=pi*avg_spt^2;
    K=2;
    %%  marking the local ROI
        local_rad=avg_spt*2;
        [xx,yy]=ndgrid(1:size(Im_mark,1), 1:size(Im_mark,2));
        CroppingMask= ( (xx-spot_coor(2)).^2+(yy-spot_coor(1)).^2<=local_rad^2 );
        Im_mark=Im_mark & CroppingMask; 
    %% object contrust enhancement
        P=round(avg_spt);
        se=strel('disk',P);
        Im_tophat=255-imbothat(Im,se);
    %% unmarked pixels elimination
        rlvnt_pix=Im_mark & ~spot_mask;
        Im_kmeans=shiftdim(reshape(double(Im_tophat),[],1,3),2)';
        Im_kmeans(find(~rlvnt_pix),:)=[];
        rlvnt_coor=find(rlvnt_pix);
    %% brightness-guided masking
        init_cond=[min(Im_kmeans) ; max(Im_kmeans)];                       %initial conditions of kmeans
        [multi_mask]=kmeans(Im_kmeans,K,'start',init_cond,'emptyaction','singleton');
        add_spot_mask=false(ImH,ImW);
        add_spot_mask(rlvnt_coor(multi_mask==1))=true;
    %% picking only the wanted spot
        add_spot_mask=bwselect(add_spot_mask,spot_coor(1),spot_coor(2));
    %% size condition
        if sum(add_spot_mask(:))>2*avg_spt_area
            add_spot_mask=false(ImH,ImW);
        end
    %% joining to the spots mask
        spot_mask=spot_mask | add_spot_mask;
end