function process_data()
%PROCESS_DATA Summary of this function goes here
%   Detailed explanation goes here
fn_in = './tmp2.mat';
fn_out = './tmp2.mat';

fprintf('loading data...');
tmp = load(fn_in);
fprintf('done\n');

% duplicate 
imgId = tmp.imgId;
subId = tmp.subId;
img_info = tmp.img_info;

% training/testing partition
if ( isfield(tmp, 'setId') )
  setId = tmp.setId;
else
  fprintf('do training testing partition...');
  setId = part_trte(imgId);
  fprintf('done\n');
end
% make sure there is no intersection for traing images and testing images
tmp_tr = unique( imgId( setId==1 ) );
tmp_te = unique( imgId( setId==3 ) );
assert( isempty( intersect(tmp_tr,tmp_te) ) );

% processing label
% fprintf('processing label: scalar -> 0/1 response vector\n');
% Y = y_s2v( tmp.Y );
% fprintf('done\n');
Y = tmp.Y;

% processing data
fprintf('processing data: normalize\n');
X = x_normalize( tmp.X, setId );
fprintf('done\n');
% X = tmp.X;

% save 
fprintf('saving data...');
save(fn_out, 'X','Y','imgId','subId','img_info', 'setId',...
  '-v7.3');
fprintf('done\n');


function yv = y_s2v(ys)
N = numel(ys);
yset = unique(ys);
K = numel( yset );
yv = zeros(K,N, 'single');
for k = 1 : K
  the_y = yset(k);
  yv(k, the_y == ys) = 1;
end

function xn = x_normalize(x, setId)
x = single(x);
% the mean on *training set*
xMean = mean(x(:,:,:, setId==1), 4);
% take out the mean
xn = bsxfun(@minus, x, xMean);

function setId = part_trte(imgId)

% map: a convenietn representation
imgId_map = build_imgId_map(imgId);
% decide how many training set
[imgTrId, imgTeId] = do_part_trte( numel(imgId_map) );

% the output
setId = zeros(numel(imgId), 1 );

% Training: set 1
imgTrId_map = imgId_map(imgTrId);
setId( cell2mat(imgTrId_map) ) = 1;

% Testing: set 3
imgTeId_map = imgId_map(imgTeId);
setId( cell2mat(imgTeId_map) ) = 3;

function imgId_map = build_imgId_map(imgId)
u = unique(imgId);
imgId_map = cell(numel(u), 1);
for i = 1 : numel(u)
  imgId_map{i} = find(u(i)==imgId);
end

function [iTr, iTe] = do_part_trte( N )

num_img_tr = round( (6/7) * N ); 
assert(num_img_tr > 1);
iTr = 1 : num_img_tr;

num_img_te = N - num_img_tr;
assert(num_img_te > 1);
iTe = num_img_tr+1 : N;