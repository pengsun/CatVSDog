function gen_bgb(fn_mkv, fn_mkb,  fn_out)
%GEN_BGB generate balanced backgound mask
%   fn_mkv: file name of vessel mask
%   fn_mkb: file name of background mask
%   fn_out: output balanced background mask

% read in vessel mask
mkv = mha_read_volume(fn_mkv);
% read in bg mask
mkb = mha_read_volume(fn_mkb);

% balanced sampling
n = numel( find(mkv==255) );
ixb = find(mkb==255);
ixbb = ixb( randsample( numel(ixb), n) );
% set the pixels ON
mkbb = zeros( size(mkb), 'like', mkb);
mkbb(ixbb) = 255; 

% done, write file
mha_write(fn_out, mkbb, [1.0,1.0,1.0], 'uint8');

