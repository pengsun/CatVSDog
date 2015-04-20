%% generate back ground mask, balanced sampling equal #pixels of fg
%%
dir_data = 'D:\data\defactoSeg\';
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
  
  % the input background mask
  fn_mkb = fullfile(dir_data, fns(i).name, 'maskb.mha');
  if ( ~exist(fn_mkb,'file') )
    fprintf('%s does not exist, skip\n', fn_mkb);
    continue;
  end

  % the output balanced back ground mask
  fn_out = fullfile(dir_data, fns(i).name, 'maskbb.mha');
  
  % do the job
  gen_bgb(fn_mkv, fn_mkb,  fn_out);
  fprintf('done %s\n', fn_out);
end
