mex -v -largeArrayDims CFLAGS='$CFLAGS -pthread -std=c++11' load_xy_async.cpp

% %% config
% opt = {};
% % opt{end+1} = '-g';
% opt{end+1} = '-v';
% opt{end+1} = '-largeArrayDims';
% 
% str = computer('arch');
% switch str(1:3)
%   case 'win' 
%     opt{end+1} = 'COMPFLAGS=/openmp $COMPFLAGS';
%     opt{end+1} = 'LINKFLAGS=/openmp $LINKFLAGS';
%   otherwise
%     opt{end+1} = 'CFLAGS=''%CFLAGS -pthread -std=c++11''';
%     opt{end+1} = 'LDFLAGS=''$LDFLAGS -pthread -std=c++11''';
% end
% %% do it
% mex(opt{:}, 'load_xy_async.cpp');