%% makeResults.m
%
% Script to merge 
% Script to connect to Hypnos using SSH to run a LIGGHTS DEM simulation.
% The simulation is periodically stopped and data transferred to MATLAB by
% SCP. Analysis of the resulting images is conducted to determine if the 
% 
% Tim Churchfield
%
% Last Edited: 06/11/2019
%
%% Variable Dictionary



%% Prepare Workspace
clc
clear
more off


%% User Input Variables
           
angleModel = 'threeAngles';
%angleModel = 'noModel';
%angleModel = 'lineTwoCircles'; % Doesn't work with Octave in its current format


%%%%%%%%%%%%%%%%%%%%%
%% Load packages
pkg load stk
pkg load parallel
pkg load struct
pkg load optim


% set paths 
global pathProject
pathProject = [pwd(), "/"];

%pathProject = '/home/tim/Desktop/11_P_02_rot1/OctaveFun/';
pathProject = '/home/tim/Desktop/test2_cali1/OctaveFun/';

% projectName
pathParts = strsplit(pathProject,filesep);
pathProject = fullfile(pathParts{1:(end-2)});
pathProject = fullfile('/',pathProject,'/');
projectName = pathParts{end-2};



% get angles of repose  
[results, averageOutput] = getAngle(projectName,angleModel);