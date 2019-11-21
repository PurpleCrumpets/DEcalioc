% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Carolin D. Görnig
% 
% Copyright 2016           Institute for
%                          Materials Handling, Material Flow, Logistics
%                          Technical University of Munich, Germany
% 
% DEcalioc is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
% 
% DEcalioc is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with DEcalioc. If not, see <http://www.gnu.org/licenses/>.
% ----------------------------------------------------------------------
%
% Modified by Tim Churchfield
% Last updated: 13/11/2019
%
% ----------------------------------------------------------------------

function A = readOutput(model, folderName)
  % INFO
  % Reads the average and non-linear dynamic angles of repose for three
  % different rotational speeds from the AngleRepose.txt output file.
  % 
  % args:
  %   - model: model's name
  %   - folderName: name of the folder where the corresponding results file is stored
  % returns:
  %   - A: dynamic angles of repose
  
  global path;
    
  % open angleRepose.txt file
  fd = fopen([path, 'optim/', model, '/', folderName, '/analysis/', folderName, '_angleRepose.txt'], 'r');
  
  % Read file into cell A
  i = 1;
  tline = fgetl(fd);
  A{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    A{i} = tline;
  end
  
  % Close file
  fclose(fd);

endfunction