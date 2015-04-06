%%
dir_data = 'C:\Temp\slices';
name = '10-035-JKI';
i = 1000;
%%
fn1 = sprintf('%s_%d_%d.mha', name,i,1);
a1 = mha_read_volume( fullfile(dir_data,fn1) );

fn2 = sprintf('%s_%d_%d.mha', name,i,2);
a2 = mha_read_volume( fullfile(dir_data,fn2) );

fn3 = sprintf('%s_%d_%d.mha', name,i,3);
a3 = mha_read_volume( fullfile(dir_data,fn3) );

%% pseudo color image
% a = cat(3,a1,a2,a3);
% a = single(a);
% imtool(a,[], 'InitialMagnification', 500);

%% 3 channels
figure;
subplot(1,3,1)
imshow(a1, []);
subplot(1,3,2)
imshow(a2, []);
subplot(1,3,3)
imshow(a3, []);
