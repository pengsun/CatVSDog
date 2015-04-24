function mhawrite(filename, img, resolution)
%MHAWRITE write 3d volume to a single mha file
%   MHAWRITE(filename, img)
%   MHAWRITE(filename, img, resolution)
%   FILENAME is a string with the path and name of the output file.
%
%   IMG is a matrix that contains the image volume.
%
%   RESOLUTION is a 3-vector with the voxel size in the X, Y and Z
%   directions. Default: [1.0, 1.0, 1.0]

% Modified from WRITERAWFILE by Peng Sun 4/2/2015
% The original file header:
%
% Copyright © 2009 University of Oxford
% 
% University of Oxford means the Chancellor, Masters and Scholars of
% the University of Oxford, having an administrative office at
% Wellington Square, Oxford OX1 2JD, UK. 
%
% This file is part of Gerardus.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. The offer of this
% program under the terms of the License is subject to the License
% being interpreted in accordance with English Law and subject to any
% action against the University of Oxford being under the jurisdiction
% of the English Courts.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

  %%% write header
  fid = fopen(filename, 'w');
  if(fid <= 0), error('Cannot open file %s\n', filename); end

  try 
    %
    sz = size(img);
    fprintf(fid, 'NDims = %d\n', numel(sz));
    %
    tmpl = repmat('%d ', 1, numel(sz)); tmpl(end) = [];
    fprintf(fid, ['DimSize = ',tmpl,'\n'], sz);
    %
    str_type = get_str_type(img);
    fprintf(fid, ['ElementType = ',str_type,'\n']);
    % 
    if (nargin==2) % default resolution
      resolution = ones(1, numel(sz));
    end
    if ( numel(resolution) ~= numel(sz) )
      exc = MException('mhawrite', 'dims(resolution)~=dims(img)!');
      throw(exc);
    end
    tmpl = repmat('%1.12f ', 1, numel(sz)); tmpl(end) = [];
    fprintf(fid, ['ElementSpacing = ', tmpl, '\n'], resolution);
    %
    fprintf(fid, 'ElementByteOrderMSB = False\n');
    %
    fprintf(fid, 'ElementDataFile = LOCAL\n');
    %
    fclose(fid);
  catch ME
    % delete the file
    fclose(fid);
    delete(filename);
    
    rethrow(ME);
  end


  %%% open the same file and append the data 
  fid = fopen( filename, 'a+');
  if(fid<=0), error('Cannot open file %s\n', filename); end 
  try
    fwrite(fid, img, class(img));
    fclose(fid);
  catch ME
    % delete the file
    fclose(fid);
    delete(filename);
    
    rethrow(ME);
  end
end

function st = get_str_type(img)
  switch class(img)
    case 'uint8'
      st = 'MET_UCHAR';
    case 'uint16'
      st = 'MET_USHORT';
    case 'int16'
      st = 'MET_SHORT';
    case 'single'
      st = 'MET_FLOAT';
    otherwise
      exc = MException('mhawrite:get_str_type', ...
        'Unsupported data type for input image: %s\n', class(img));
      throw(exc);
  end % switch
  
end % get_str_type
