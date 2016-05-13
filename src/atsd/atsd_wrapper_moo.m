function f = atsd_wrapper_moo(x, dataset)


split = .8;
X = load(dataset);   % DATASET is a global var in the main experimenter

% load the data and split
data = X(:, 1:end-1); 
labels  = X(:, end);  % labels are in the last dimension 
if length(unique(labels)) ~= 2
  error('Must be a two class problem.');
end
data = zscore(data);

[ns, nf] = size(data);
q = randperm(ns);
m = floor(split*ns);

data = data(q, :);
labels = labels(q);
labels(labels == 0) = -1;

data_train = data(1:m, :);
labels_train = labels(1:m);
data_test = data(m+1:end, :);
labels_test = labels(m+1:end);


param.C = x(1);
param.ker = x(2);

options.MaxIter = 100000;

% f_plus
svm_struct = svmtrain(data_train, labels_train, ...
  'kernel_function', 'rbf', ...
  'rbf_sigma', param.ker, ...
  'boxconstraint', param.C, ...
  'method', 'SMO', ...
  'tolkkt', 1e-4, ...
  'kktviolationlevel', 0.15, ...
  'options', options);
yhat = svmclassify(svm_struct, data_test);
[fp_sen, fp_spe, fp_err] = calc_statistics(labels_test, yhat);

% f_minus
yhat_bad = sign(randn(m, 1));
svm_struct = svmtrain(data_train, yhat_bad, ...
  'kernel_function', 'rbf', ...
  'rbf_sigma', param.ker, ...
  'boxconstraint', param.C, ...
  'method', 'SMO', ...
  'tolkkt', 1e-5, ...
  'kktviolationlevel', 0.15,...
  'options', options);
yhat = svmclassify(svm_struct, data_train);
[fm_sen, fm_spe, fm_err] = calc_statistics(yhat_bad, yhat);


%%%
% EXP 1 
f_plus = fp_err;
f_minus = [];

%%%
% EXP 2 
%f_plus = fp_err;
%f_minus = abs(.5-fm_err);

%%%
% EXP 3 
%f_plus = [1-fp_sen; 1-fp_spe; fp_err];
%f_minus = [abs(.5-fm_err)];

%%%
% EXP 4 
%f_plus = [1-fp_sen; 1-fp_spe; fp_err];
%f_minus = [abs(.5-fm_err); abs(.5-fm_sen); abs(.5-fm_spe)];

%%%
% EXP 5 
%f_plus = [1-fp_sen; 1-fp_spe; fp_err];
%f_minus = [abs(.5-fm_err); abs(.5-fm_sen); abs(.5-fm_spe)];


f = [f_plus; f_minus];
