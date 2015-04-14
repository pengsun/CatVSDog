# The supervised Neural Network workflow

## data
Load the training/validation/testing data with the general or tailored data loader. 
Produce the data batch by batch.
It's up to you wether to load all the data into memory at one time or to read in a bunch of files in a directory once a time.
There are many off-the-shelf loaders ranging from `iris_loader` to `imagenet_loader`

## model
Build the model with the building blocks provided by `nn` and `nngraph`. 
Do it by specify the nodes and the connections for a Directed Acyclic Graph (DAG)

## criterion
i.e., the loss function

## train
Do the f-prop and b-prop, get the gradient of the parameters and update the parameters.
Write your own numeric algorithm if you like. Also, the `optim` library includes many mature algorithm and would save your many efforts.

## test
Predict for the unseen data using the trained model.
