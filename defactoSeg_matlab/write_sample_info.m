function write_sample_info(fn_mask, a_ran, sz, fnbase,  fn_out)
% write sampling info to txt file

% read mask
mk = mha_read_volume(fn_mask);
% random angles and centers
ac = gen_angle_center(mk, a_ran);
% zero based integers!
ac = floor(ac) - 1;
sz = round(sz);

% write file
line_tmpl = '%d %d %d    %d %d %d    %d    %s\n';
fid = fopen(fn_out, 'w');
if ( fid < 0), error('error while writing %s\n', fn_out); end
for i = 1 : size(ac, 1)
  fprintf(fid, line_tmpl,...
    ac(i,1),ac(i,2),ac(i,3),...
    ac(i,4),ac(i,5),ac(i,6),...
    sz,  fnbase);
end
fclose(fid);


function ac = gen_angle_center(mask, a_ran)
% random angles and centers
%
% centers
K = 500;
f_c = sample_fg(mask, K);
b_c = sample_bg(mask, K);
c = cat(1, f_c,b_c);

% angles: [-30, 30]
a = a_ran * (2*rand(size(c))-1);

% angles + centers
ac = [a, c];


function cen = sample_fg(mask, K)
% K: #instances
% cen: [K, 3], 1 base
i_fg = find( mask > 0 );
ix = i_fg( randsample(numel(i_fg), K) );
[i1,i2,i3] = ind2sub(size(mask), ix);
cen = [i1(:),i2(:),i3(:)];


function cen = sample_bg(mask, K)
% K: #instances
% cen: [K, 3], 1 base
i_bg = find( mask == 0 );
ix = i_bg( randsample(numel(i_bg), K) );
[i1,i2,i3] = ind2sub(size(mask), ix);
cen = [i1(:),i2(:),i3(:)];
