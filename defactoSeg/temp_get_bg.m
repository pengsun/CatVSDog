%% get back ground mask
%% read in vessels mask
fn_mkv = 'rrr.mha';
maskv = mha_read_volume(fn_mkv);
%% dilation for vessels
sznh = 32*[1, 1, 1];
nh = ones(sznh, 'uint8');
maskb = imdilate(maskv, nh);
%% read in Aorta + vessels mask
fn_mkav = 'mask.mha';
maskav = mha_read_volume(fn_mkav);
%% NOT
maskb(maskav==255) = 0;
%% 
mha_write('bbb.mha', maskb, [1.0,1.0,1.0], 'uint8');