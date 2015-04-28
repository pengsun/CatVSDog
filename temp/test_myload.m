%%
ii = randperm(3);
iii = repmat(ii(:), 200, 1);

for j = 1 : numel(iii)
  ind = iii(j);
  
  fn = sprintf('z%d.mat', ind);
  
  myload(fn);
  
  [xx,yy] = myload();
  size(xx)
  size(yy)
end