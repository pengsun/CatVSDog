function process_data_teImg()
%PROCESS_DATA_TEIMG Summary of this function goes here
%   Detailed explanation goes here

% config
dir_in = './tmp2';
dir_out = './tmp2';
fn_tr = './Temp/slices2.mat';

% get info
[xMean, vmin,vmax] = get_norm_info(fn_tr);

% process each individual mat file
fns = dir( dir_in );
for i = 1 : numel(fns)
  if (fns(i).isdir), continue; end
  
  % the input output names
  fn_in = fullfile(dir_in, fns(i).name);
  fn_out = fullfile(dir_out, fns(i).name);

  fprintf('loading data...');
  tmp = load(fn_in);
  fprintf('done\n');

  % duplicate 
  subId = tmp.subId;
  img_info = tmp.img_info;

  % processing label
  fprintf('processing label: scalar -> 0/1 response vector\n');
  Y = y_s2v( tmp.Y );
  fprintf('done\n');
  % Y = tmp.Y;

  % processing data
  fprintf('processing data: normalize\n');
  X = x_normalize( tmp.X, xMean, vmin,vmax );
  fprintf('done\n');
  % X = tmp.X;

  % save 
  fprintf('saving data...');
  save(fn_out, 'X','Y','subId','img_info',...
    '-v7.3');
  fprintf('done\n');
end

function [xMean, vmin, vmax] = get_norm_info(fn_data)
% TODO

function yv = y_s2v(ys)
N = numel(ys);
yset = unique(ys);
K = numel( yset );
yv = zeros(K,N, 'single');
for k = 1 : K
  the_y = yset(k);
  yv(k, the_y == ys) = 1;
end

function xn = x_normalize(x, xMean, vmin,vmax)
x = single(x);
% the mean on *training set*
xMean = mean(x(:,:,:, setId==1), 4);
% take out the mean
xn = bsxfun(@minus, x, xMean);
% TODO: the right thing