## The supervised Neural Network workflow
The torch's phylosophy: abstract any machine learning task as the data-model-criterion-train-test workflow.

### data
Load the training/validation/testing data with the general or tailored data loader. 
Produce the data batch by batch.
It's up to you wether to load all the data into memory at one time or to read in a bunch of files in a directory once a time.
There are many off-the-shelf loaders ranging from `iris_loader` to `imagenet_loader`

### model
Build the model with the building blocks provided by `nn` and `nngraph`. 
Do it by specify the nodes and the connections for a Directed Acyclic Graph (DAG)

### criterion
i.e., the loss function

### train
Do the f-prop and b-prop, get the gradient of the parameters and update the parameters.
Write your own numeric algorithm if you like. Also, the `optim` library includes many mature algorithm and would save your many efforts.

### test
Predict for the unseen data using the trained model.

## Matlab Matrix (mxArray) v.s. Torch.Tensor

### memory layout
**Matlab**: always contiguous, stride across dims is **not** allowed! This is for the consideration of high-performance linear algebra calculation, can cause difficulties for machine learning task. Matlab does use copy-on-write trick, however, it just postpones the memory copy when slicing and modifying.

**Torch**: might be not contiguous, stride acrosss dims is allowed! This is convenient for in-place operations that are common in machine learning (e.g., collect the parameters for the Neural Network model and update them all). Another benefit is the one-data-for-all (e.g., in supervised learning one can concatenate instances X and labels Y as a big Tensor and get them separately by slicing, which is in-place operation)

### dimensionality order
**Matlab**: first dim major, i.e., for a matrix with the size [dim_1,dim_2,...,dim_N], the data is stored in the order of dim_1, dim_2,...,dim_N. Try this code:
``` Matlab
% make a 4 x 3 x 2 array by enumerating 1,2,...,24
a = 1 : 4*3*2;
a = reshape(a, [4,3,2])
```
The output is:
``` Matlab
a(:,:,1) =

     1     5     9
     2     6    10
     3     7    11
     4     8    12


a(:,:,2) =

    13    17    21
    14    18    22
    15    19    23
    16    20    24

```

**Torch**: last dim major. i.e., for a matrix with the size [dim_1,dim_2,...,dim_N], the data is stored in the order of dim_N, dim_{N-1},...,dim_1. Try this and compare the output with that in Matlab:
``` Lua
-- make a 4 x 3 x 2 array by enumerating 1,2,...,24
a = torch.range(1,4*3*2)
a:resize(4,3,2)
```
The output is
```Lua
(1,.,.) =
   1   2
   3   4
   5   6

(2,.,.) =
   7   8
   9  10
  11  12

(3,.,.) =
  13  14
  15  16
  17  18

(4,.,.) =
  19  20
  21  22
  23  24
[torch.DoubleTensor of dimension 4x3x2]

```
