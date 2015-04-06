%% load slices.mat
tmp = load('C:\Temp\slices.mat');
%% sample
N = 4000;
ix = randsample( numel(tmp.Y), N);

X = tmp.X(:,:,:, ix);
Y = tmp.Y(ix);
imgId = tmp.imgId(ix);
subId = tmp.subId(ix);
img_info = tmp.img_info;
%% save 
save('tmp.mat', 'X','Y','imgId','subId','img_info');
