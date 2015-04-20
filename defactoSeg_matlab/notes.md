## The work flow for generating training data:

* `write_sample_infoV2_dir.m`: write info txts (angles, centers, extent size, label, etc)
* (optional) `verify_sample_infoV2_dir.m`: verify the labels of the sampled centers
* `dfm2.py`: write the slices to file
* `gen_mat.m`: *.mha in directory -> slices.mat. generate the final *.mat file
* `process_data.m`: slices.mat -> slices2.mat. taking out mean, 1-hot labels, tr/te partition, etc


## Write the info to a separate file
* `write_sep_info.m`: slices2.mat -> info.mat. tr/te partition, xMean, vmin, vmax, image names 


## The work flow for generating testing images data:

* `write_sample_infoV2_dir_teImg.m`: write info txts for ALL mask pixels in testing images
* (optional) `verify_sample_infoV2_dir.m`: verify the labels of the sampled centers
* `dfm2.py`: write the slices to file
* `gen_mat_teImg.m`: generate the final *.mat file, one mat for one image
* `process_data_teImg,.m`: processing testing data with the information of training data



