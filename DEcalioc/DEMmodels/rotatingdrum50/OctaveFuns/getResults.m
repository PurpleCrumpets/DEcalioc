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

function res = getResults(model, folderName)
  % INFO
  % Calculate the angle of repsonse and the bulk density based on the results
  % of the DEM-Simulation.
  % Returns NaN if calculation throws an error.
  %
  % args:
  %   - model: model's name
  %   - folderName: name of the folder where the simulation output has been written
  %                 i.e. the simulation has been run
  % returns:
  %   - res: scalar structure containg the average dynamic angle of repose 
  %          (1,3,5) and the non-linear average dynamic angle of repose (2,4,6).
  
  try
    A = readOutput(model, folderName);    
    res{1} = str2num(A{1});
    res{2} = str2num(A{2});
    res{3} = str2num(A{3});
    res{4} = str2num(A{4});
    res{5} = str2num(A{5});
    res{6} = str2num(A{6});
  catch
    res{1} = NaN;
    res{2} = NaN;
    res{3} = NaN;
    res{4} = NaN;
    res{5} = NaN;
    res{6} = NaN;
  end
  
endfunction