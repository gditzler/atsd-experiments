function [x, f, exitflag] = anti_training(params)
% params
%   .PopulationSize
%   .nvar
global DATASETZ;

Aineq = [];
bineq = [];
A = [];
b = [];
lb = [1e-1; 1e-2];
ub = [1000; 2];

%optimoptions = gaoptimset('PopulationSize', params.PopulationSize,
%'UseParallel', 'always');
optimoptions = gaoptimset('PopulationSize', params.PopulationSize, 'UseParallel', true);
optimoptions.dataset = DATASETZ;
[x, f, exitflag] = gamultiobj(@(x)(atsd_wrapper(x,DATASETZ)), params.nvar, Aineq, bineq, A, b, lb, ub, optimoptions);

