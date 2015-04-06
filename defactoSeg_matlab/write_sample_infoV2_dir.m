%%
dir_data = 'D:\data\defactoSeg\';
dir_info_out = 'D:\data\defactoSeg_matlab\sample_info';
a_ran = 20; % angle
sz = 32;    % extent
K = 500;
%%
fns = dir( dir_data );
parfor i = 1 : numel(fns)
  if ( ~ fns(i).isdir ), continue; end
  if ( strcmp('.', fns(i).name) ), continue; end
  if ( strcmp('..', fns(i).name) ), continue; end
  
  % the output sample info
  fn_out = fullfile(dir_info_out, [fns(i).name,'.txt']);
  if ( exist(fn_out,'file') )
    fprintf('%s exists, skip\n', fn_out);
    continue;
  end
  
  % the input vessel mask
  fn_maskv = fullfile(dir_data, fns(i).name, 'maskv3.mha');
  if ( ~exist(fn_maskv,'file') )
    fprintf('%s does not exist, skip\n', fn_maskv);
    continue;
  end
  
  % the input back ground mask
  fn_maskb = fullfile(dir_data, fns(i).name, 'maskb.mha');
  if ( ~exist(fn_maskv,'file') )
    fprintf('%s does not exist, skip\n', fn_maskb);
    continue;
  end
  
  % do the job
  %%%% IMPORTANT: make sure there is NO fn_out
  % wrtie vessels sampling info
  label = 1;
  write_sample_infoV2(fn_maskv, a_ran, sz, fns(i).name, K, label, fn_out);
  % write (append) background sampling info
  label = 0;
  write_sample_infoV2(fn_maskb, a_ran, sz, fns(i).name, K, label, fn_out);
  fprintf('done %s\n', fn_out);
end
