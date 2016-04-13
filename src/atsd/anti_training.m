function [x, f, exitflag] = anti_training(params)
% params
%   .PopulationSize
%   .nvar
% data 
% labels 
%

Aineq = [];
bineq = [];
A = [];
b = [];
lb = [1e-2; 1e-2];
ub = [1000; 2];

optimoptions = gaoptimset('PopulationSize', params.PopulationSize, 'PlotFcns', @gaplotpareto);
  %, 'UseParallel', 'always');
[x, f, exitflag] = gamultiobj(@atsd_wrapper, params.nvar, Aineq, bineq, A, b, lb, ub, optimoptions);

