function trim_all( )
%%
dir_data = 'D:\data\defactoSeg2\';
%%
fns = dir( dir_data );
for i = 1 : numel(fns)
  if ( ~ fns(i).isdir ), continue; end
  if ( strcmp('.', fns(i).name) ), continue; end
  if ( strcmp('..', fns(i).name) ), continue; end
  
  fprintf('Processing %s...', fns(i).name);
  
  % trim the mha
  try
    trim_mha( fullfile(dir_data, fns(i).name) );
  catch
    fprintf('error while trmming mha for %s, skip\n', fns(i).name);
    continue;
  end
  
  % the input mask
  try
    trim_mask( fullfile(dir_data, fns(i).name) );
  catch
    fprintf('error while trimming mask for %s, skip\n', fns(i).name);
    continue;
  end
  
  fprintf('done\n');
  
end

function trim_mha( dir_mha )
fn_mha = fullfile(dir_mha, 'dataset.mha');
if ( ~exist(fn_mha, 'file') )
  fprintf('%s does not exist, skip\n', fn_mha);
  return;
end
% remove the unit
mha = mha_read_volume(fn_mha);
fnout = fullfile(dir_mha, 't.mha');
mhawrite(fnout, mha, [1,1,1]);


function trim_mask( dir_mask )
fn_masks = fullfile(dir_mask, 'masks.mhd');
if ( ~exist(fn_masks, 'file') )
  fprintf('%s does not exist, skip\n', fn_masks);
  return;
end
mk = mha_read_volume(fn_masks);

% get foreground & write
maskv3 = get_fg(mk);
fn_maskv3 = fullfile( dir_mask, 'maskv3.mha' );
mhawrite(fn_maskv3, maskv3, [1,1,1]);

% get background & write
maskb = get_bg(maskv3);
fn_maskb = fullfile( dir_mask, 'maskb.mha' );
mhawrite(fn_maskb, maskb, [1,1,1]);


function mk_fg = get_fg(mk)
th = 32; % magic number
mk_fg = zeros(size(mk), 'uint8');
mk_fg(mk>=th) = 255;


function bg = get_bg(fg)
% dilation for vessels
sznh = 32*[1, 1, 1];
nh = ones(sznh, 'uint8');
bg = imdilate(fg, nh);
% NOT (remove the vessels)
bg(fg==255) = 0;