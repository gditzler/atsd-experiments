function anti_training(params, data, labels)
% params
%   .PopulationSize
%   .nvar
% data 
% labels 
%

nvar = params;
Aineq = [];
bineq = [];
A = [];
b = [];
lb = [1e-3;1e-3];
ub = [1;1];

optimoptions = gaoptimset('PopulationSize', params.PopulationSize, ...
                          'PlotFcns', @gaplotpareto, ...
                          'UseParallel', 'always');
[x, f, exitflag] = gamultiobj(@atsd_wrapper, params.nvar, Aineq, ...
                              bineq, A, b, lb, ub, optimoptions);