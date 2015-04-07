%% load slices.mat
% load('C:\Temp\slices.mat');
load('.\tmp.mat');
% load('.\tmp2.mat');
%%
% i_inst = randi(size(X,4), 1);
i_inst = 3178;
%%
I = X(:,:,:, i_inst);
% y = find( Y(:,i_inst)==1 );
y = Y(i_inst);
%% show images
figure;
subplot(1,3,1), imshow(I(:,:,1), []);
subplot(1,3,2), imshow(I(:,:,2), []);
subplot(1,3,3), imshow(I(:,:,3), []);
%% print
i_img = imgId( i_inst );
i_slice = subId( i_inst );
fprintf('i_inst = %d\n', i_inst);
fprintf('label = %d\n', y);
fprintf('img name = %s\n', img_info{i_img}.name);
fprintf('img size = [%d %d %d]\n', size(I));
fprintf('center: %d %d %d\n', img_info{i_img}.cen(:,i_slice) );
fprintf('angle: %d %d %d\n', img_info{i_img}.ang(:,i_slice) );