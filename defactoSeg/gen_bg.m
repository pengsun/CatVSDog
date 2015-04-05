function gen_bg(fn_mkv, fn_mkav,  fn_out)
%GEN_BG generate backgound mask
%   fn_mkv: file name of vessel mask
%   fn_mkav: file name of vessel+Aorta mask

% read in vessel mask
maskv = mha_read_volume(fn_mkv);
% dilation for vessels
sznh = 32*[1, 1, 1];
nh = ones(sznh, 'uint8');
maskb = imdilate(maskv, nh);

% read in Aorta + vessels mask
maskav = mha_read_volume(fn_mkav);
% NOT
maskb(maskav==255) = 0;

% done, write file
mha_write(fn_out, maskb, [1.0,1.0,1.0], 'uint8');

