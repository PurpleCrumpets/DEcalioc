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
  
  %              Simulation Primary Settings:  RPM  -  Filling degree
  Input.model{1}       =   'rotatingdrum1'; %  20      0.2 
  Input.model{2}       =   'rotatingdrum2'; %  20      0.5
  Input.model{3}       =   'rotatingdrum3'; %  30      0.3
  Input.model{4}       =   'rotatingdrum4'; %  40      0.2
  Input.model{5}       =   'rotatingdrum5'; %  40      0.5
  
  
  Input.cpu(1,1)       =   1;
  Input.cpu(2,1)       =   1;
  Input.cpu(3,1)       =   1;
  Input.cpu(4,1)       =   1;
  Input.cpu(5,1)       =   1;
  
  
  % User-specific input
  %  - Input.maxCPU           : (OG) maximum count of CPUs used during the whole
  %                             run. Currently used to represent the number of
  %                             jobs that can be submitted to the cluster at a
  %                             time. 
  Input.maxCPU         =   160; % Hard limit: 512 
  
  % Kriging-model specific input
  %  - Input.numOfSam         : number of samples generatred by latin hypercubic sampling
  Input.numOfSam       =   21; % samples PER model (5-10 per calibration variable)
  
  
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
  
  % rotatingdrum1
  optim.targetVal{1}(1) =   420;
  optim.targetVal{1}(2) =   0.02;
  % rotatingdrum2
  optim.targetVal{2}(1) =   15;
  optim.targetVal{2}(2) =   709;
  % rotatingdrum3
  optim.targetVal{3}(1) =   0.58;
  optim.targetVal{3}(2) =   0.58;
  % rotatingdrum4
  optim.targetVal{4}(1) =   0.58;
  optim.targetVal{4}(2) =   0.58;
  % rotatingdrum5
  optim.targetVal{5}(1) =   0.58;
  optim.targetVal{5}(2) =   0.58;
  
  % rotatingdrum1
  optim.tolRes{1}(1)   =   0.01;
  optim.tolRes{1}(2)   =   0.01;
  % rotatingdrum2
  optim.tolRes{2}(1)   =   0.01;
  optim.tolRes{2}(2)   =   0.01;
  % rotatingdrum3
  optim.tolRes{3}(1)   =   0.01;
  optim.tolRes{3}(2)   =   0.01;
  % rotatingdrum4
  optim.tolRes{4}(1)   =   0.01;
  optim.tolRes{4}(2)   =   0.01;
  % rotatingdrum5
  optim.tolRes{5}(1)   =   0.01;
  optim.tolRes{5}(2)   =   0.01;

  
  optim.tolfun        =   0.002; % Default: 0.002
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
  
  modelVars.coefRestitutionPP = 0.60;
  modelVars.coefRestitutionPW = 0.69;
  modelVars.poissonsRatioP    = 0.30;
  modelVars.radiusP           = 2e-3;
  modelVars.youngsModulusP    = 5e6;
  
  modelVars.percentRayleigh   = 0.35;
  
  
  % Design variables
  %   - assign: cell struct which assigns variable names to the design variables 
  %     (1) densityP
  %     (2) poissonsRatioP  
  %     (3) coefFrictionPP
  %     (4) coefFrictionPW
  %     (5) coefRollingFrictionPP
  %     (6) coefRollingFrictionPW
%  assign{1} = "densityP";
%  assign{2} = "coefFrictionPP";
%  assign{3} = "coefFrictionPW";
%  assign{4} = "coefRollingFrictionPP";
%  assign{5} = "coefRollingFrictionPW";
  
  % Coefficient of Restitution
  assign{1} = "COR_PP_PP";
  assign{2} = "COR_PP_GL";
  assign{3} = "COR_PP_DW";
  assign{4} = "COR_PP_DE1";
  assign{5} = "COR_PP_DE2";
  assign{6} = "COR_GL_GL";
  assign{7} = "COR_GL_DW";
  assign{8} = "COR_GL_DE1";
  assign{9} = "COR_GL_DE2";
  
  % Coefficient of Static Friction
  assign{10} = "CoSF_PP_PP";
  assign{11} = "CoSF_PP_GL";
  assign{12} = "CoSF_PP_DW";
  assign{13} = "CoSF_PP_DE1";
  assign{14} = "CoSF_PP_DE2";
  assign{15} = "CoSF_GL_GL";
  assign{16} = "CoSF_GL_DW";
  assign{17} = "CoSF_GL_DE1";
  assign{18} = "CoSF_GL_DE2";  
  
  % Coefficient of Rolling Friction
  assign{19} = "CoRF_PP_PP";
  assign{20} = "CoRF_PP_GL";
  assign{21} = "CoRF_PP_DW";
  assign{22} = "CoRF_PP_DE1";
  assign{23} = "CoRF_PP_DE2";
  assign{24} = "CoRF_GL_GL";
  assign{25} = "CoRF_GL_DW";
  assign{26} = "CoRF_GL_DE1";
  assign{27} = "CoRF_GL_DE2";
  
  
  
  % Boundaries of the feasible region
  %   -> first row min-values, second row max-values
  %   -> columns according to cell struct 'assign'
%  paramLims = [500  0.3 0.3 0.025 0.025;
%               800 0.7 0.7 0.075 0.075];
               
  paramLims = [0     0     0     0     0     0     0     0     0      ... CoR  Min
               0.3   0.3   0.3   0.3   0.3   0.3   0.3   0.3   0.3    ... CoSF Min
               0.001 0.001 0.001 0.001 0.001 0.001 0.001 0.001 0.001; ... CoRF Min
               1     1     1     1     1     1     1     1     1      ... CoR  Max
               0.6   0.6   0.6   0.6   0.6   0.6   0.6   0.6   0.6    ... CoSF Max
               0.02  0.02  0.02  0.02  0.02  0.02  0.02  0.02  0.02]; %   CORF Max
  
  
  %*****************************************************************************
  %//	END
  %*****************************************************************************
  % Reshaping of some variables...
  optim.targetVal = horzcat(optim.targetVal{:})';
  optim.tolRes = horzcat(optim.tolRes{:})';
  
endfunction
