if ~exist('param.mat')
    param.area=2;
    param.fixed_width=4;
    param.fixed_hight=6;
    param.save_folder='Processed Data';
    param.load_folder='Owl Images';
    param.spot_rad=0.135;
    param.card=0.027;
    save('param','param');
end
if exist('Processed Data')~=7
    mkdir('Processed Data');
end
if exist('Owl Images')~=7
    mkdir('Owl Images');
end
load_image;