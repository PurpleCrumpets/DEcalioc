%% makeResults.m
%
% Script to obtain the average dynamic angles of repose for a given LIGGGHTS 
% simulation
% 
% Tim Churchfield
%
% Last Edited: 13/11/2019
%
% ------------------------------------------------------------------------------
%% Variable Dictionary
%
% -- Inputs --
% 
% angleModel    - Model used to describe the slope of particles. This can either
%                 be 'noModel', 'threeAngles' or 'lineTwoCircles' (see
%                 curveProperties.m function for more information). The
%                 'lineTwoCircles' function does not work with GNU Octave.
%
%
% -- Outputs --
%
% results       - 
% averageOutput - 
%
%
% -- Other --
%
% pathProject   - (global)
% pathParts     -
% projectName   -
%
%
% ------------------------------------------------------------------------------
%% Initial Set-up

% prepare workspace
clc
clear
more off

% user input variables       
%angleModel = 'threeAngles'; % Unfortunately, quite noisy
angleModel = 'noModel';
%angleModel = 'lineTwoCircles'; % Doesn't work with Octave in its current format

% load packages
pkg load stk
pkg load parallel
pkg load struct
pkg load optim

% set paths 
global pathProject
pathProject = [pwd(), "/"];
%pathProject = '/home/tim/Desktop/createRestart35/OctaveFun/';

% ------------------------------------------------------------------------------
%% Execution

% projectName
pathParts = strsplit(pathProject,filesep);
pathProject = fullfile(pathParts{1:(end-2)});
pathProject = fullfile('/',pathProject,'/');
projectName = pathParts{end-2};

% get angles of repose  
[results, averageOutput] = getAngle(projectName,angleModel);