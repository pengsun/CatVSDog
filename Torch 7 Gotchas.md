Tensor (i.e., the multi dimensional array) plays an important role in deep Nueral Network. 
In torch 7, the `torch.Tensor` adopts a pass-by-reference semantic, which is memory-efficient. 
However, this may also lead to potential "Gotchas"
* Multiplexer (duplicate input at outputs): `nn.ConcatTable` (The name is misleading?). Concatenate Table to Tensor: `nn.JoinTable`. Split Tensor to Table: `nn.SplitTable`. 
* when using gpu
  * call `params, gradParams = net:forward()` AFTER calling `model:cuda()`, or the reference gets invalid
  * write `x = x:cuda()`, `y = y:cuda()` to convert Tensor type, `x:cuda()` is not in-place and has no effect on `x` after being called
* when using `DataParallelTable` for multiple gpus
  * remember to call `syncParameters()` method to collect and synchronize parameters across gpus
  * in the beginning at the clousure, call `model:zeroGradParameters()`. simply calling `gradParams:zero()` will NOT affect parameters of the contained models   
* `nn.ClassNLLCriterion`
  * the convention is inconsistent with `optim.ConfusionMatrix`. a safe way is to always use `FloatTensor` or `CudaTensor` for all (inputs, targets, model, criterion)
* `TemporalConvolution`
  * the data layout is DIFFERENT: data is like `batch, width, channel` 
* `optim.ConfusionMatrix` class
  * access `totalValid` or other state variables AFTER `updateValids()` method is called
  * `output` should be squeezed in case there is just one instance
