function [x, f, exitflag] = anti_training(params, moo, ftype)
% params
%   .PopulationSize
%   .nvar
global DATASETZ;
global LAMBDA;


Aineq = [];
bineq = [];
A = [];
b = [];
lb = [1e-1; 1e-2];
ub = [1000; 5];
%ub = [1000; sqrt(nf)*2];



if moo == 1
  optimoptions = gaoptimset('PopulationSize', params.PopulationSize, 'UseParallel', true);
  [x, f, exitflag] = gamultiobj(@(x)(atsd_wrapper_moo(x, DATASETZ, ftype)), ...
    params.nvar, Aineq, bineq, A, b, lb, ub, optimoptions);
elseif moo == 2
  optimoptions = saoptimset();
  optimoptions = saoptimset(optimoptions, 'MaxIter', 2000); 
  [x, f, exitflag] = simulannealbnd(@(x)(atsd_wrapper_soo(x,DATASETZ, LAMBDA)), ...
    [1, .5], lb, ub, optimoptions);
elseif moo == 3
  optimoptions = gaoptimset('PopulationSize', params.PopulationSize, 'UseParallel', true);
  [x, f, exitflag] = gamultiobj(@(x)(atsd_wrapper_soo(x, DATASETZ, LAMBDA)), ...
    params.nvar, Aineq, bineq, A, b, lb, ub, optimoptions);
end
