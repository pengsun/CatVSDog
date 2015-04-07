The work flow:

* `write_sample_infoV2_dir.m`: write info txts (angles, centers, extent size, label, etc)
* (optional) `verify_sample_infoV2_dir.m`: verify the labels of the sampled centers
* `dfm2.py`: write the slices to file
* `gen_mat.m`: generate the final *.mat file
* `process_data.m`: taking out mean, response labels, tr/te partition, etc