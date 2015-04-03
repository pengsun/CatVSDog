function remove_aorta(fn_in, fn_out, varargin)
%REMOVE_AORTA Summary of this function goes here
%   Detailed explanation goes here

%%% Mask
%mk = single( mha_read_volume('mask.mha') );
mk = single( mha_read_volume(fn_in) );
mk(mk>0) = 1;

%%% conv kernel
sz = [10,10,10];
num = prod(sz);
ker = ones(sz,'single') ./ num;

%%% conv them
r = convn(mk, ker, 'same');

%%% reject block that is too "solid"
if (isempty(varargin))
  th = 0.5;
else
  th = varargin{1};
end
r(r > th) = 0.0;

%%% AND with the initial mask
rr = (mk & r);

%%% conver to uint8
rrr = uint8( 255*rr );

%%% write mha file
mha_write(fn_out, rrr, [1,1,1], 'uint8');