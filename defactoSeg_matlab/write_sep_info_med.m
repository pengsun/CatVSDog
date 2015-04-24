%% load info
load('D:\data\defactoSeg\info.mat');
%% subsample, make a small set 
imgSetId = 3 * ones(1, numel(imgSetId));
N = numel(imgSetId);
ind = randsample(N, 25);
imgSetId(ind) = 1;
%%
save('D:\data\defactoSeg\info_med.mat',...
  'imgNames', 'imgSetId',...
  'vmax', 'vmin', 'Xm');