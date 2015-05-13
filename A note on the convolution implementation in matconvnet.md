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
It computes: `alpha*op(A)*op(B) + beta*C`, where
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
It computes the transposed version `alpha * A' * x + beta * y` or non-transposed version `alpha * A * x + beta * y`, where
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
