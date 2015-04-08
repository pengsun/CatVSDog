%% config: pick the testing image Ids
dir_mat = 'C:\Temp\slices2.mat';
load(dir_mat, 'setId','imgId','img_info');
tid = imgId(setId==3);
tid = unique(tid);
clear setId imgId
%% config
dir_data = 'D:\data\defactoSeg\';
dir_info_out = 'D:\data\defactoSeg_matlab\sample_info_teImg';
a_ran = 0.0; % angle
sz = 32;     % extent
K = inf;
%% 
for i = 1 : numel(tid)
  imgId = tid(i);
  [~,img_name,~] = fileparts( img_info{imgId}.name );
  
  % the output sample info
  fn_out = fullfile(dir_info_out, [img_name,'.txt']);
  if ( exist(fn_out,'file') )
    fprintf('%s exists, skip\n', fn_out);
    continue;
  end
  
  % the input vessel mask
  fn_maskv = fullfile(dir_data, img_name, 'maskv3.mha');
  if ( ~exist(fn_maskv,'file') )
    fprintf('%s does not exist, skip\n', fn_maskv);
    continue;
  end
  
  % the input back ground mask
  fn_maskb = fullfile(dir_data, img_name, 'maskb.mha');
  if ( ~exist(fn_maskv,'file') )
    fprintf('%s does not exist, skip\n', fn_maskb);
    continue;
  end
  
  % do the job
  % wrtie vessels sampling info
  label = 1;
  write_sample_infoV2(fn_maskv, a_ran, sz, img_name, K, label, fn_out);
  % write (append) background sampling info
  label = 0;
  write_sample_infoV2(fn_maskb, a_ran, sz, img_name, K, label, fn_out);
  fprintf('done %s\n', fn_out);
end
