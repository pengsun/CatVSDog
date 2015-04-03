%system('python dfm.py t.mha 200 230 88 64 out');
%%
% mk = mha_read_volume('mask.mha');
% gmk = gpuArray( single(mk) );
% gker = gpuArray( ones(10,10,10,'single') );
%% Mask
mk = single( mha_read_volume('mask.mha') );
mk(mk>0) = 1;
%% conv kernel
sz = [10,10,10];
num = prod(sz);
ker = ones(sz,'single') ./ num;
%% conv them
r = convn(mk, ker, 'same');
%% reject block that is too "solid"
th = 0.5;
r(r > th) = 0.0;
%% AND with the initial mask
rr = (mk & r);
%% write mha file
rrr = uint8( 255*rr );
WriteRawFile('./tmd.mha', rrr, [1,1,1], 'uint8');