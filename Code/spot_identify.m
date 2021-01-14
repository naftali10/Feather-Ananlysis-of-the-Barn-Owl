function[spot_mask]=spot_identify(Im,Im_mark,ratio)
% input: an image, its relevant area mask and its pixel-to-centimeter ratio
% output: a binary image where '1' indicates a spot area
    load param.mat;
    [ImH,ImW,~]=size(Im);
    avg_spt=ratio*param.spot_rad;                                          %average spot radius in pixels
    avg_spt_area=pi*avg_spt^2;
    K=2;
    init_cond=[ones(1,3)*200 ; ones(1,3)*255];                             %initial conditions of kmeans
    %% object contrust enhancement
        P=round(avg_spt);
        se=strel('disk',P);
        Im_tophat=255-imbothat(Im,se);
    %% unmarked pixels elimination
        Im_kmeans=shiftdim(reshape(double(Im_tophat),[],1,3),2)';
        Im_kmeans(find(~Im_mark),:)=[];
        mark_coor=find(Im_mark);
    %% brightness-guided masking
        [multi_mask]=kmeans(Im_kmeans,K,'start',init_cond,'emptyaction','singleton');
        spot_mask=false(ImH,ImW);
        spot_mask(mark_coor(multi_mask==1))=true;
        spot_mask=spot_mask & Im(:,:,1)<200;
    %% size conditions
        objects=bwconncomp(spot_mask);
        for i=1:objects.NumObjects
            if numel(objects.PixelIdxList{i})<0.05*avg_spt_area | numel(objects.PixelIdxList{i})>2*avg_spt_area
                spot_mask(objects.PixelIdxList{i})=false;
            end
        end                
end