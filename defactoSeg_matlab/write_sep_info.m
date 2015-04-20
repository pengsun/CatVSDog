%% load info
load('C:\Temp\slices2.mat',...
  'img_info', 'imgId', 'setId',...
  'Xm','vmin','vmax');
fn_out = 'D:\data\defactoSeg\info.mat';
%% wrtie in new protocal

% imgNames, imgSetId (tr/te)
for i = 1 : numel( img_info )
  % instance -> image
  tmp_ix = (imgId == i);
  tmp_setId = setId(tmp_ix);
  tmp_setId = unique(tmp_setId); 
  
  % an image can be either tr or te
  assert( numel(tmp_setId)==1 ); 
  assert( tmp_setId==3 || tmp_setId==1 ); 
  
  % write back
  imgSetId(i) = tmp_setId;
  [~,na] = fileparts( img_info{i}.name );
  
  % write back image name
  imgNames{i} = na;
end
%% write
save(fn_out,...
  'imgNames', 'imgSetId',...
  'Xm','vmin','vmax');