Something that may be anti-intuitive/confusing/misleading... in Torch 7.

* Torch 7 tensor manipulation
  * split into sub-matrix: `split`, `chunk`
  * broadcast: use `expand`, `expandAs` instead
* Path manipulations:
  * Get the path for the file being called: `path.splitpath( paths.thisfile() )`
* Multiplexer (duplicate input at outputs): `nn.ConcatTable` (The name is misleading?). Concatenate Table to Tensor: `nn.JoinTable`. Split Tensor to Table: `nn.SplitTable`. 
* when using gpu
  * call `params, gradParams = net:forward()` AFTER calling `model:cuda()`, or the reference gets invalid
  * write `x = x:cuda()`, `y = y:cuda()` to convert Tensor type, `x:cuda()` is not in-place and has no effect on `x` after being called
* when using `DataParallelTable` for multiple gpus
  * remember to call `syncParameters()` method to collect and synchronize parameters across gpus
  * in the beginning at the clousure, call `model:zeroGradParameters()`. simply calling `gradParams:zero()` will NOT affect parameters of the contained models
* `nn.ClassNLLCriterion`
  * the convention is inconsistent with `optim.ConfusionMatrix`. a safe way is to always use `CudaTensor` for all (inputs, targets, model, criterion) or the `FloatTesnor` for outputs accompanied by `LongTensor` for targets
* `TemporalConvolution`
  * the data layout is DIFFERENT: data is arranged as `batch, width, channel` (or `batch, sequenceLength, vocabulary` that sounds familiar by NLPer)
* `optim.ConfusionMatrix` class
  * access `totalValid` or other state variables AFTER `updateValids()` method is called
  * `output` should be squeezed in case there is just one instance
* `optim.sgd` L2 regularization
 * use `weightDecay`, the mnist example may be out dated. https://groups.google.com/forum/#!searchin/torch7/L2$20regularization/torch7/xpSPqkPQm9k/RTQz78DGCFYJ

https://groups.google.com/forum/#!searchin/torch7/L2$20regularization/torch7/IChhfBepfZM/usUKMS7cEAAJ
