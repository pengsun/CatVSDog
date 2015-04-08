function gen_mat_teImg()

% config
dir_info_te = 'D:\data\defactoSeg_matlab\sample_info';
dir_slices = 'C:\Temp\slices';
dir_out = 'C:\Temp\';

% enumerate the info file
img_cnt = 0;
fns = dir( dir_info_te );
for i = 1 : numel(fns)
  if ( fns(i).isdir ), continue; end

  % init the output data
  X = [];        % [H,W,3, N] data
  Y = [];        % [N] labels
  subId = [];    % [N]
  img_info = struct(...
    'name', [],...
    'ang', [],...
    'cen', []);

  % for this image
  img_cnt = img_cnt + 1;
  
  % the sampling info 
  fn_info = fullfile(dir_info, fns(i).name);
  fid = fopen(fn_info);
  % a1 a2 a3   c1 c2 c3   sz  label fnbase
  C = textscan(fid, '%d %d %d  %d %d %d  %d  %d  %s\n');
  fclose(fid);
  
  % get the information needed
  [~,img_name,~] = fileparts( fns(i).name );
  [xx, yy, a, cen] = get_data_from_img(dir_slices, img_name, C);
  assert( size(xx,4)==numel(yy) );
  assert( size(a,2)==numel(yy) );
  assert( size(cen,2)==numel(yy) );
  
  % fill the output data for instances
  X = xx;
  Y = yy(:);
  subId = (1 : numel(yy))';
  
  % fill the output data for the image
  img_info.name = fns(i).name;
  img_info.ang = a;
  img_info.cen = cen;
  
  % save
  fn_out = fullfile(dir_out, [num2str(img_cnt),'.mat'] );
  fprintf('saving %s...', fn_out);
  save(fn_out, 'X','Y','subId','img_info', '-v7.3');
  fprintf('done\n');
end

function [xx, yy, a, cen] = get_data_from_img(dir_slices, img_name, C)
% C: a1 a2 a3  c1 c2 c3  sz  label  fnbase
% xx: [H,W,3, K]
% yy: [K]
% a: [3, K]
% cen: [3, K]

pnt_cnt = 0;
for j = 1 : numel( C{1} )
  % get the 3 slices data x
  x = get_x(dir_slices, img_name, j);
  if ( isempty(x) ), continue; end

  % read successfully, now, for this point:
  pnt_cnt = pnt_cnt + 1;

  % 
  xx(:,:,:, pnt_cnt) = x;
  yy(pnt_cnt) = C{8}(j);
  a(:, pnt_cnt) = [ C{1}(j); C{2}(j); C{3}(j) ];
  cen(:, pnt_cnt) = [C{4}(j); C{5}(j); C{6}(j) ];

end
yy = yy(:);

function x = get_x(dir_slices, img_name, sub_id)
% x: [H, W, 3]
img_base = [img_name, '_', num2str(sub_id)];
fn_base = fullfile(dir_slices, img_base);
x1 = get_xs(fn_base, 1);
x2 = get_xs(fn_base, 2);
x3 = get_xs(fn_base, 3);
if ( isempty(x1) || isempty(x2) || isempty(x3) )
  x = [];
  return;
end
x = cat(3, x1,x2,x3);
%%% hack: 48 x 48 centered at the center of the 64 x 64 patch
ran = 9:56;
x = x(ran, ran, :);

function xs = get_xs(fn_base, id)
% xs: [H,W,1]
fn = [fn_base, '_', num2str(id),'.mha'];
try
  xs = mha_read_volume(fn);
catch
  % could fail due to corrupted mha file
  xs = [];
end