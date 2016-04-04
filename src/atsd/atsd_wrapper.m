% function f = atsd_wrapper(x)
x = [10, 2];

split = .8;

X = load('~/Git/ClassificationDatasets/csv/mushroom.csv');
data = X(:, 1:end-1);
labels  = X(:, end);

if length(unique(labels)) ~= 2
  error('Must be a two class problem.');
end

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

% train svm 
svm_struct = svmtrain(data_train, labels_train, ...
  'kernel_function', 'rbf', ...
  'rbf_sigma', param.ker, ...
  'boxconstraint', param.C, ...
  'method', 'SMO');

% f_plus
yhat = svmclassify(svm_struct, data_test);
[sen, spe, err] = calc_statistics(labels_test, yhat);

% f_minus
svm_struct = svmtrain(data_train, sign(randn(m, 1)), ...
  'kernel_function', 'rbf', ...
  'rbf_sigma', param.ker, ...
  'boxconstraint', param.C, ...
  'method', 'SMO');
yhat = svmclassify(svm_struct, data_test);
[sen, spe, err] = calc_statistics(labels_test, yhat);


f_plus = [err; c_sen; s_spe];
f_minus = [abs(.5-r_err); abs(.5-r_c_sen); abs(.5-r_s_spe)];
f = [f_plus; f_minus];
