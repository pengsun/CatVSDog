Tensor (i.e., the multi dimensional array) plays an important role in deep Nueral Network. 
In torch 7, the `torch.Tensor` adopts a pass-by-reference semantic, which is memory-efficient. 
However, this may also lead to potential "Gotchas"
* when using gpu
  * call `params, gradParams = net:forward()` AFTER calling `model:cuda()`, or the reference gets invalid
  * write `x = x:cuda()`, `y = y:cuda()` to convert Tensor type, `x:cuda()` is not in-place and has no effect on `x` after being called
* when using `DataParallelTable` for multiple gpus.
  * remember to call `syncParameters()` method to collect and synchronize parameters across gpus

Other pitfalls:
* `optim.ConfusionMatrix` class: access `totalValid` or other state variables AFTER `updateValids()` method is called
