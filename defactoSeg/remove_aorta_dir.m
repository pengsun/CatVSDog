%%
dir_data = 'D:\data\defactoSeg\';
sz = 8;
%%
fns = dir( dir_data );
parfor i = 1 : numel(fns)
  if ( ~ fns(i).isdir ), continue; end
  if ( strcmp('.', fns(i).name) ), continue; end
  if ( strcmp('..', fns(i).name) ), continue; end

  % the input mask
  fn_mask = fullfile(dir_data, fns(i).name, 'mask.mha');
  if ( ~exist(fn_mask,'file') )
    fprintf('%s does not exist, skip\n', fn_mask);
    continue;
  end
  
  % the output mask
  fn_mask_out = fullfile(dir_data, fns(i).name, 'maskv3.mha');
%   if ( exist(fn_mask_out,'file') )
%     fprintf('%s exists, skip\n', fn_mask);
%     continue;
%   end

  % do the job
  fprintf('input %s...\n', fn_mask);
  fprintf('output %s...\n', fn_mask_out);
  remove_aortaV2(fn_mask, fn_mask_out, sz);
  fprintf('done %s\n\n', fn_mask_out);
end

%%
% dir_data = 'D:\data\defactoSeg\';
% th = 0.85;
%%
% fns = dir( dir_data );
% parfor i = 1 : numel(fns)
%   if ( ~ fns(i).isdir ), continue; end
%   if ( strcmp('.', fns(i).name) ), continue; end
%   if ( strcmp('..', fns(i).name) ), continue; end
% 
%   % the input mask
%   fn_mask = fullfile(dir_data, fns(i).name, 'mask.mha');
%   if ( ~exist(fn_mask,'file') )
%     fprintf('%s does not exist, skip\n', fn_mask);
%     continue;
%   end
%   % the output mask
%   fn_mask_out = fullfile(dir_data, fns(i).name, 'maskv.mha');
% %   if ( exist(fn_mask_out,'file') )
% %     fprintf('%s exists, skip\n', fn_mask);
% %     continue;
% %   end
% 
%   % do the job
%   fprintf('input %s...\n', fn_mask);
%   fprintf('output %s...\n', fn_mask_out);
%   remove_aorta(fn_mask, fn_mask_out, th);
%   fprintf('done %s\n\n', fn_mask_out);
% end