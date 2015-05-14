The conventions and rationale of the convolution in matconvnet is explained in [the mannual](http://www.vlfeat.org/matconvnet/matconvnet-manual.pdf). The im2col trick is used so that convolution is converted to matrix multiplication. 

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

### Matrix Multiplication
See the blas doc on [gemm](http://www.math.utah.edu/software/lapack/lapack-blas/sgemm.html) and [gemv](http://www.math.utah.edu/software/lapack/lapack-blas/sgemv.html). A brief explanation:
```
gemm(TA, TB,
     M, N, K,
     alpha,
     A, lda,
     B, ldb,
     beta,
     C, ldc) ;
```
It computes: `C = alpha*op(A)*op(B) + beta*C`, where
```
TA,TB: 't' transpose, op(A) = A' ; 'n' not transpose, op(A) = A; the same for B
op(A): [M, K]
op(B): [K, N]
C:     [M, N]
alpha, beta: [1] scalar
lda, ldb, ldc: stride of the leading dimension for A, B, C
```

```
gemv(TA,
    M, N,
    alpha,
    A, lda,
    x, incx,
    beta,
    y, incy)
```
It computes the transposed version `y = alpha * A' * x + beta * y` or non-transposed version `y = alpha * A * x + beta * y`, where
```
TA: `t` transpose (so that y's length is N); 'n' not transpose (so that y's length is M)
A: [M, N]
lda: stride on A's leading dimension
incx, incy: stride on the elements
alpha, beta: [1] scalar
```
Remark:
- `gemm` and `gemv` are inconsistent in terms of behaviours! Be careful with the transpose specification for `gemv` where the length of `y` is automatically decided! Also, in `gemv` the argument `A` is always `[M, N]`
- The matrix is *column major* which is consistent with Matlab conventions
- The stride `lda`, `ldb`, `ldc` account for sub matrix or memory that is not contiguous 
- The stride `incx` accounts for sub (row) vector

### An example
Suppose a mini batch with the size:
```
x: [12, 12, 20, 100]
f: [5, 5, 20, 50]
y: [8, 8, 50, 100]
```

For each instance:
```
x: [12, 12, 20]
f: [5,  5,  20, 50]
y: [8,  8,  1,  50]
```

Do convolution-matrix conversion: `phiX = im2row(x)`. Do reshaping: `F = reshape(f)`, `Y = reshape(y)`.
So that 
```
phiX: [64, 500]
F:    [500, 50]
Y:    [64,  50]
```

#### BPROP
With the below size in mind:
```
X, dX: [12, 12, 20]
phiX, dphiX: [64, 500]
F, dF: [500, 50]
Y, dY: [64, 50]
```
We have:
`dF += phiX' * dY`. 
The corresponding `gemm` call:
```
gemm('t', 'n',
     M = 500, N = 50, K = 64,
     alpha = 1,
     A = phiX, ldA = 64,
     B = dY, ldB = 64,
     beta = 1 (or zero for the first instance with uninitialized dF),
     C = dF, ldC = 500)
```

`dphiX = dY * dF'`. 
The corresponding `gemm` call:
```
gemm('n','t',
     M = 64, N = 500, K = 64,
     alpha = 1,
     A = dY, ldA = 64,
     B = dF, ldB = 500,
     beta = 0,
     C = dphiX, ldC = 64)
```

`dX = row2im(dphiX)`: `[12, 12, 20] <-- [64, 500]`


Remark:
- When computing `dF, dB` the derivative over each instance should be accumulated; When computing `dX` the derivative over each instance should be kept as is.
- In `gemm`, `beta = 0` means overwriting the memory so that one needs not initialize it with zeros
