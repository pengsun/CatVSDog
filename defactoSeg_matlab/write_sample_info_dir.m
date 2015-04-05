%%
dir_data = 'D:\data\defactoSeg\';
dir_out  = 'D:\data\defactoSeg_matlab\';
a_ran = 30; % angle
sz = 32;     % extent
%%
fns = dir( dir_data );
parfor i = 1 : numel(fns)
  if ( ~ fns(i).isdir ), continue; end
  if ( strcmp('.', fns(i).name) ), continue; end
  if ( strcmp('..', fns(i).name) ), continue; end

  % the input mask
  fn_mask = fullfile(dir_data, fns(i).name, 'maskv2.mha');
  if ( ~exist(fn_mask,'file') )
    fprintf('%s does not exist, skip\n', fn_mask);
    continue;
  end
  
  % the output sample info
  fn_out = fullfile(dir_out, 'sample_info', [fns(i).name,'.txt']);
  
  % do the job
  write_sample_info(fn_mask, a_ran, sz, fns(i).name, fn_out);
  fprintf('done %s\n', fn_out);
end
