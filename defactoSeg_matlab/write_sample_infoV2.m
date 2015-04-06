function write_sample_infoV2(fn_mask, a_ran, sz, fnbase, K, label,  fn_out)
% write sampling info for the slices to txt file
% fn_mask: string. file name of the mask, 1's (>0, to be exact) indicate where to sample
% a_ran: [1] range for random rotated angles
% sz: [1] size for the extent of the 2D slice
% fnbase: string. base file name
% K: [1]. # to be sampled
% fn_out: string. output file name, a txt file with each line the information

% read mask
mk = mha_read_volume(fn_mask);
% random angles and centers
ac = gen_angle_center(mk, a_ran, K);
% zero based integers!
ac = floor(ac) - 1;
sz = round(sz);

% write file
line_tmpl = '%d %d %d    %d %d %d    %d   %d   %s\n';
fid = fopen(fn_out, 'a'); % append if any
if ( fid < 0), error('error while writing %s\n', fn_out); end
for i = 1 : size(ac, 1)
  fprintf(fid, line_tmpl,...
    ac(i,1),ac(i,2),ac(i,3),...
    ac(i,4),ac(i,5),ac(i,6),...
    sz,     label,  fnbase);
end
fclose(fid);


function ac = gen_angle_center(mask, a_ran, K)
% random angles and centers
%
% centers
c = sample_at(mask, K);

% angles: [-a_ran, a_ran]
a = a_ran * (2*rand(size(c))-1);

% angles + centers
ac = [a, c];


function cen = sample_at(mask, K)
% K: #instances
% cen: [K, 3], 1 base
ii = find( mask > 0 );
if ( K < numel(ii) )
  ix = ii( randsample(numel(ii), K) );
else
  warning('In write_sample_infoV2: K >= numel(ii), replacement = false\n');
  ix = ii( randsample(numel(ii), K, true) );
end
[i1,i2,i3] = ind2sub(size(mask), ix);
cen = [i1(:),i2(:),i3(:)];


