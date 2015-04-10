%%
u = unique( imgId( setId==3 ) );
%% 
for i = 1 : numel(u)
  fprintf('%s\n', img_info{i}.name);
end