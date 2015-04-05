%%
dir_data = 'D:\data\defactoSeg\';
sz = 8;
%%
fns = dir( dir_data );
parfor i = 1 : numel(fns)
  if ( ~ fns(i).isdir ), continue; end
  if ( strcmp('.', fns(i).name) ), continue; end
  if ( strcmp('..', fns(i).name) ), continue; end

  % the input vessel mask
  fn_mkv = fullfile(dir_data, fns(i).name, 'maskv3.mha');
  if ( ~exist(fn_mkv,'file') )
    fprintf('%s does not exist, skip\n', fn_mkv);
    continue;
  end
  
  % the input vessel+Aorta mask
  fn_mkav = fullfile(dir_data, fns(i).name, 'mask.mha');
  if ( ~exist(fn_mkav,'file') )
    fprintf('%s does not exist, skip\n', fn_mkav);
    continue;
  end

  % the output back ground mask
  fn_out = fullfile(dir_data, fns(i).name, 'maskb.mha');
  
  % do the job
  gen_bg(fn_mkv, fn_mkav,  fn_out);
  fprintf('done %s\n', fn_out);
end
