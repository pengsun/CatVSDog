### FPROP
Given the input `x`, filter `f`, bias `B`:
``` 
x: [H,   W,   D,  P, N]
f: [H',  W',  D', P, Q]   B: [1, Q]
```
Produce the output `y`:
```
y: [H'', W'', D'', Q, N]
```

For each instance, convert the data to matrix and do a plain 2D matrix multiplication:
``` 
for i = 1 : N
  phix = im2row( x(:,:,:,:, i) );  % [H''W''D'', H'W'D'P] <-- [H, W, D, P]
  F    = reshape(f);               % [H'W'D'P, Q] <-- [H', W', D', P, Q] 
  Y(:,:, i) = phix * F;            % [H''W''D'', Q] = [H''W''D'', H'W'D'P] * [H'W'D'P, Q]
  
  u = ones([H''W''D'', 1]); 
  Y(:,:,i) += u * B;  % [H''W''D'', Q] = [H''W''D'', 1] * [1, Q]
end
```
Thanks to the column-major element order in Matlab, the 3D matrix `Y: [H''W''D'', Q, N]` is already the desired 5D matrix `y: [H'', W'', D'', Q,  N] `. 

### BPROP
Given:
```
x:  [H,   W,   D,   P,  N]
f:  [H',  W',  D',  P,  Q]
dy: [H'', W'', D'', Q,  N]
```
Produce:
```
df: [H', W', D', P, Q],  dB: [1, Q]
dx: [H,  W,  D,  P, N]
```

For each instance, accumulate on `dF`, `dB` and computes `dx`
``` 
for i = 1 : N
  phix = im2row( x(:,:,:,:, i) );     % [H''W''D'', H'W'D'P] <-- [H, W, D, P]
  dY   = reshape( dy(:,:,:,:, i) );   % [H''W''D'', Q] <-- [H'', W'', D'', Q]
  dF += phix' * dY;                   % [H'W'D'P, Q] = [H'W'D'P, H''W''D''] * [H''W''D'', Q]
  
  u = ones([H''W''D'', 1]);
  dB += u' * dY;  % [1, Q] = [1, H''W''D''] * [H''W''D'', Q]
  
  dphix = dY * F' ;             % [H''W''D'', H'W'D'P] = [H''W''D'', Q] * [Q, H'W'D'P]
  dx(:,:,:,:, i) = row2im(dphix);  % [H, W, D, P] <-- [H''W''D'', H'W'D'P]
end
```
