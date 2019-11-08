function  outputTest = testScript(inputs)

%clc
%clear
%
%pkg load parallel

%inputs = 1:10;
nPROC = 2;
[outputTest] = pararrayfun (nPROC, @testFunction, inputs);