function [x, f, exitflag] = anti_training(params, moo)
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

if moo == 1
  optimoptions = gaoptimset('PopulationSize', params.PopulationSize, 'UseParallel', true);
  [x, f, exitflag] = gamultiobj(@(x)(atsd_wrapper(x,DATASETZ)), ...
    params.nvar, Aineq, bineq, A, b, lb, ub, optimoptions);
else
  optimoptions = saoptimset();
  optimoptions = saoptimset(optimoptions, 'MaxIter', 200); 
  [x, f, exitflag] = simulannealbnd(@(x)(atsd_wrapper_soo(x,DATASETZ)), ...
    [1, .5], lb, ub, optimoptions);
end
