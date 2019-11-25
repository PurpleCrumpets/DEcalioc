% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Christopher Jelich
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

function [Input, optim, modelVars, assign, paramLims] = loadInput()
  % INFO
  % loads Input specifying the Discrete Element Models and optimization options
  %
  % args:   none
  % return:
  %   - Input: cell structure containing model specific information
  %   - optim: cell structure containing optimization specific information
  %   - modelVars: cell structure containing non-default but fixed model variables
  %   - assign: cell structure used for assigning ParamLims to model variables
  %   - paramLims: matrix containing limits of parameter space
  
  
  %*****************************************************************************
  %//	input - DISCRETE ELEMENT MODELS
  %*****************************************************************************
  % Model specific input
  %  - Input.model{k}         : name of k-th model, n models in total
  %  - Input.cpu(k,1)         : CPUs used in a run of the k-th model
  
  %              Simulation Primary Settings:  Filling degree
%  Input.model{1}       =   'rotatingdrum20'; %  0.20       
  Input.model{1}       =   'rotatingdrum35'; %  0.35      
%  Input.model{3}       =   'rotatingdrum50'; %  0.50      

  
%  Input.cpu(1,1)       =   1; % Leave as 1 (legacy)
  Input.cpu(1,1)       =   1; % Leave as 1 (legacy)
%  Input.cpu(3,1)       =   1; % Leave as 1 (legacy)

  
  
  % User-specific input
  %  - Input.maxCPU           : (OG) maximum count of CPUs used during the whole
  %                             run. Currently used to represent the number of
  %                             jobs that can be submitted to the cluster at a
  %                             time. 
  Input.maxCPU         =   100; % Hard limit of cluster: 512 
  
  % Kriging-model specific input
  %  - Input.numOfSam         : number of samples generatred by latin hypercubic sampling
  samplesPerVar        =   10; % Recommended 5 to 10 by Rackl
  numVar               =   21; % 21 Design Variables
  Input.numOfSam       =   100; %samplesPerVar*numVar; % samples PER model
  
  
  %*****************************************************************************
  %//	input - OPTIMIZATION
  %*****************************************************************************
  % Optimization specific input
  %  - optim.targetVal{k}(i)  : i-th target value of the k-th model
  %                             Note: must be specified according to the specified
  %                                   evaluate function in 'costFunction.m'
  %  - optim.tolRes{k}(i)     : tolerance used as stopping criteria of the optimization runs
  %                             e.g.: stop optimization run if for every model k,
  %                                   the specified residuals{k}(1:i) are below the
  %                                   corresponding Input.tolRes{k}(1:i)
  %  - optim.tolfun           : second stopping criteria, optimization run stops
  %                             if the costfunction's change is below Input.tolfun
  %  - optim.maxIter          : third stopping criteria, optimization run stops
  %                             if the number of iterations exceeds Input.maxIter 
  %  - optim.maxIter          : fourth stopping criteria, optimization run stops
  %                             if the number of function evaluations exceeds
  %                             Input.maxFunEvals
  %  - optim.WRL              : weighting factor for the Rayleigh-time step
  
  % rotatingdrum20
%  optim.targetVal{1}(1) =   30.0; % average
%  optim.targetVal{1}(2) =   30.0; % non-linear
%  optim.targetVal{1}(3) =   40.0; % average
%  optim.targetVal{1}(4) =   40.0; % non-linear
%  optim.targetVal{1}(5) =   50.0; % average
%  optim.targetVal{1}(6) =   50.0; % non-linear
  
  % rotatingdrum35
  optim.targetVal{1}(1) =   05.0; % average
  optim.targetVal{1}(2) =   05.0; % non-linear
  optim.targetVal{1}(3) =   33.0; % average
  optim.targetVal{1}(4) =   33.0; % non-linear
  optim.targetVal{1}(5) =   50.0; % average
  optim.targetVal{1}(6) =   50.0; % non-linear
  
  % rotatingdrum50
%  optim.targetVal{2}(1) =   30.0; % average
%  optim.targetVal{2}(2) =   30.0; % non-linear
%  optim.targetVal{2}(3) =   40.0; % average
%  optim.targetVal{2}(4) =   40.0; % non-linear
%  optim.targetVal{2}(5) =   50.0; % average
%  optim.targetVal{2}(6) =   50.0; % non-linear

  
  % rotatingdrum20
%  optim.tolRes{1}(1)   =   0.01; % average
%  optim.tolRes{1}(2)   =   0.01; % non-linear
%  optim.tolRes{1}(3)   =   0.01; % average
%  optim.tolRes{1}(4)   =   0.01; % non-linear
%  optim.tolRes{1}(5)   =   0.01; % average
%  optim.tolRes{1}(6)   =   0.01; % non-linear
  
  % rotatingdrum35
  optim.tolRes{1}(1)   =   0.1; %0.01; % average
  optim.tolRes{1}(2)   =   0.1; %0.01; % non-linear
  optim.tolRes{1}(3)   =   0.1; %0.01; % average
  optim.tolRes{1}(4)   =   0.1; %0.01; % non-linear
  optim.tolRes{1}(5)   =   0.1; %0.01; % average
  optim.tolRes{1}(6)   =   0.1; %0.01; % non-linear
  
  % rotatingdrum50
%  optim.tolRes{3}(1)   =   0.01; % average
%  optim.tolRes{3}(2)   =   0.01; % non-linear
%  optim.tolRes{3}(3)   =   0.01; % average
%  optim.tolRes{3}(4)   =   0.01; % non-linear
%  optim.tolRes{3}(5)   =   0.01; % average
%  optim.tolRes{3}(6)   =   0.01; % non-linear


  
  optim.tolfun        =   0.02; % Default: 0.002
  optim.maxIter       =   3;     % Default: 3
  optim.maxFunEvals   =   40;    % Default: 40
  
  optim.WRL           =   0;     % Default: 0.5 (0 = off)
  
  
  %*****************************************************************************
  %//	input - MODEL VARIABLES and DESIGN VARIABLES
  %*****************************************************************************
  % Fixed model variables
  %   -> declare variables which values differ from the corresponding default values
  %      found in 'data.head' of the specified models
  %   -> NOTE: since the cost function takes the Rayleigh time step into account
  %            radiusP, densitiyP, youngsModulusP and poissonRatioP MUST be 
  %            specified here as fixed model variables or must be defined 
  %            later on as design variables!
  
  
  % As the weighting factor of the Rayleigh time step is zero 
  % (optim.WRL = 0), the modelVars are not necessary. They will be written to 
  % to the data.head but will not make any difference as these variables are not 
  % used anywhere in the main script.  
  
  modelVars.poissonsRatioP    = 0.30; % Not in use
  modelVars.radiusP           = 2e-3; % Not in use
  modelVars.youngsModulusP    = 5e6;  % Not in use 
  modelVars.densityP          = 1000; % Not in use
  modelVars.percentRayleigh   = 0.35; % Not in use
  
  
  % Design variables
  %   - assign: cell struct which assigns variable names to the design variables 
  
  % Coefficient of Restitution
  assign{1} = "COR_PP_PP";
  assign{2} = "COR_PP_GL";
  assign{3} = "COR_PP_DW";
  assign{4} = "COR_PP_DE1";
  assign{5} = "COR_GL_GL";
  assign{6} = "COR_GL_DW";
  assign{7} = "COR_GL_DE1";
  
  % Coefficient of Friction
  assign{8} = "CoF_PP_PP";
  assign{9} = "CoF_PP_GL";
  assign{10} = "CoF_PP_DW";
  assign{11} = "CoF_PP_DE1";
  assign{12} = "CoF_GL_GL";
  assign{13} = "CoF_GL_DW";
  assign{14} = "CoF_GL_DE1"; 
  
  % Coefficient of Rolling Friction
  assign{15} = "CoRF_PP_PP";
  assign{16} = "CoRF_PP_GL";
  assign{17} = "CoRF_PP_DW";
  assign{18} = "CoRF_PP_DE1";
  assign{19} = "CoRF_GL_GL";
  assign{20} = "CoRF_GL_DW";
  assign{21} = "CoRF_GL_DE1";
  
  
  % Boundaries of the feasible region
  %   -> first row min-values, second row max-values
  %   -> columns according to cell struct 'assign'            
  paramLims = [0.06  0.06  0.06  0.06  0.06  0.06  0.06   ... 
               0.2   0.2   0.2   0.2   0.2   0.2   0.2    ... 
               0.001 0.001 0.001 0.001 0.001 0.001 0.001; ... 
               0.95  0.95  0.95  0.95  0.95  0.95  0.95   ... 
               1.4   1.4   1.4   1.4   1.4   1.4   1.4    ... 
               0.02  0.02  0.02  0.02  0.02  0.02  0.02]; %
  % Row 1: CoR Min
  % Row 2: CoF Min 
  % Row 3: CoRF Min
  % Row 4: CoR Max
  % Row 5: CoF Max 
  % Row 6: CoRF Max
  
  %*****************************************************************************
  %//	END
  %*****************************************************************************
  % Reshaping of some variables...
  optim.targetVal = horzcat(optim.targetVal{:})';
  optim.tolRes = horzcat(optim.tolRes{:})';
  
endfunction