function [x, f, exitflag] = anti_training(params)
% params
%   .PopulationSize
%   .nvar
%

Aineq = [];
bineq = [];
A = [];
b = [];
lb = [1e-1; 1e-2];
ub = [1000; 2];

%optimoptions = gaoptimset('PopulationSize', params.PopulationSize,
%'UseParallel', 'always');
optimoptions = gaoptimset('PopulationSize', params.PopulationSize, 'UseParallel', true);
[x, f, exitflag] = gamultiobj(@atsd_wrapper, params.nvar, Aineq, bineq, A, b, lb, ub, optimoptions);

