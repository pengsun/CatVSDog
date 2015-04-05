%%
dir_data  = 'D:\data\defactoSeg\';
dir_info  = 'D:\data\defactoSeg_matlab\sample_info';
K = 500;
%%
fns = dir( dir_info );
parfor i = 1 : numel(fns)
  if ( fns(i).isdir ), continue; end

  % the input mask
  [~,name,ext] = fileparts(fns(i).name); 
  fn_mask = fullfile(dir_data, name, 'maskv2.mha');
  if ( ~exist(fn_mask,'file') )
    fprintf('%s does not exist, skip\n', fn_mask);
    continue;
  end
  
  % the output sample info
  fn_info = fullfile(dir_info, fns(i).name);
  fid = fopen(fn_info);
  tmp = textscan(fid, '%d %d %d  %d %d %d  %d  %s');
  fclose(fid);
  cen = [tmp{4}, tmp{5}, tmp{6}];
  
  % verify
  mask = mha_read_volume(fn_mask);
  sz   = size(mask);
  ind  = sub2ind(sz, cen(:,1)+1, cen(:,2)+1, cen(:,3)+1);
  
  % label 1
  ix1 = ind(1:K);
  v1 = mask(ix1);
  assert( all(v1==255) );
  
  % label 2
  ix2 = ind(K+1:end);
  v2 = mask(ix2);
  assert( all(v2==0) );
  
  fprintf('verified %s\n', fn_info);
end
