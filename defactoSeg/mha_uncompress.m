dir_data = 'D:\data\defactoSeg\';
%%
fns = dir( dir_data );
for i = 1 : numel(fns)
  if ( ~ fns(i).isdir ), continue; end
  if ( strcmp('.', fns(i).name) ), continue; end
  if ( strcmp('..', fns(i).name) ), continue; end

  % read in
  fn_mha = fullfile(dir_data, fns(i).name, 't.mha');
  if ( ~exist(fn_mha,'file') ), continue; end
  img = mha_read_volume(fn_mha);
  
  % write to
  fn_out = fullfile(dir_data, fns(i).name, 'tu.mha');
  mhawrite(fn_out, img);
  
  %
  fprintf('done %s\n', fn_out);
end