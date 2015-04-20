%% load info
load('D:\data\defactoSeg\info.mat');
%% subsample, make a small set 
imgSetId = 3 * ones(1, numel(imgSetId));
imgSetId(1) = 1;
imgSetId(3) = 1;
imgSetId(9) = 1;
imgSetId(16) = 1;
%%
save('D:\data\defactoSeg\info_small.mat',...
  'imgNames', 'imgSetId',...
  'vmax', 'vmin', 'Xm');