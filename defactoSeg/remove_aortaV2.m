function remove_aortaV2(fn_in, fn_out, varargin)
%REMOVE_AORTAV2 Summary of this function goes here
%   Detailed explanation goes here

if (isempty(varargin))
  sz = 8;
else
  sz = varargin{1};
end

% 
mk = single( mha_read_volume(fn_in) );
% mk = gpuArray(mk);
% Min Pooling: get Aorta in low resolution
% a trick: max pool on NOT
a = vl_nnpool(255 - mk, sz, 'stride',sz,'method','max');
% NOT
a = uint8( 255-a );

% TODO: Remove singular pixel due to thick vessels

% 1 pixel dialation
for i = 1 : size(a,3)
  nh = ones(3,3, 'uint8');
  a(:,:,i) = imdilate(a(:,:,i), nh);
end

% Upsampling
tsz = size(a);
tsz = [ sz*tsz(1), sz*tsz(2), tsz(3)];
aa = zeros(tsz, 'like',a);
for i = 1 : size(a,3)
  aa(:,:,i) = imresize( a(:,:,i), sz, 'nearest');
end
%mha_write('aa.mha', aa, [1,1,1], 'uint8');

% segment Aorta by XOR
bin_mk = (mk==255);
bin_aa = (aa==255);
rr = bin_mk & (~bin_aa);
rr = uint8( 255*rr );

% write 
mha_write(fn_out, rr, [1,1,1], 'uint8');


