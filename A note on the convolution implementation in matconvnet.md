The im2col trick is used.

### FPROP
The input `X`, filter `F`, bias `B`, output `Y`:
``` 
X: [H, W, P, N]
F: [a, b, P, Q]   B: [1, Q]
Y: [R, S, Q, N]
```

For each instance, convert them to matrix and multiply them as plain 2D matrix:

``` 
for i = 1 : N
  X [H, W, P]        (im2col)-->   XX: [RS, abP] 
  F [a, b, P, Q]    (reshape)-->   FF: [abP, Q]
  Y [R, S, Q]       (reshape)-->   YY: [RS, Q]
  YY = XX * FF using gemm
  
  B [1, Q]  (left times all one)--> BB: [RS, Q]
  YY = YY + BB
end
```

