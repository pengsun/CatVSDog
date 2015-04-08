%%
%% load slices.mat
tmp = load('C:\Temp\slices2.mat');
tmp_out = 'C:\Temp\tmp4.mat';
%% sample
N = 10000;
ix = randsample( size(tmp.Y, 2), N);

X = tmp.X(:,:,:, ix);
Y = tmp.Y(:,ix);

setId = tmp.setId(ix);
imgId = tmp.imgId(ix);
subId = tmp.subId(ix);

Xm = tmp.Xm;
vmax = tmp.vmax;
vmin = tmp.vmin;
img_info = tmp.img_info;
%%
% %% load slices.mat
% tmp = load('C:\Temp\slices.mat');
% %% sample
% N = 4000;
% ix = randsample( numel(tmp.Y), N);
% 
% X = tmp.X(:,:,:, ix);
% Y = tmp.Y(ix);
% imgId = tmp.imgId(ix);
% subId = tmp.subId(ix);
% img_info = tmp.img_info;
%% save 
save(tmp_out, 'X','Y', 'Xm','vmin','vmax',...
  'setId','imgId','subId','img_info');
