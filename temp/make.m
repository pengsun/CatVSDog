%% config
opt = {};
opt{end+1} = '-g';
opt{end+1} = '-v';
opt{end+1} = '-largeArrayDims';

str = computer('arch');
switch str(1:3)
  case 'win' 
    opt{end+1} = 'COMPFLAGS=/openmp $COMPFLAGS';
    opt{end+1} = 'LINKFLAGS=/openmp $LINKFLAGS';
  case 'gln'
    opt{end+1} = 'CXXFLAGS="\$CXXFLAGS -fopenmp -std=c++11"';
    opt{end+1} = 'LDFLAGS="\$LDFLAGS -fopenmp -std=c++11"';
  otherwise
    error('unsupported platform');
end
%% do it
mex(opt{:}, 'load_xy_async.cpp');