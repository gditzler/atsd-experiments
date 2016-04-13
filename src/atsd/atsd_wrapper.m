function f = atsd_wrapper(x)


global DATASET;

split = .8;

X = load(DATASET);   % DATASET is a global var in the main experimenter

% load the data and split
data = X(:, 1:end-1); 
labels  = X(:, end);  % labels are in the last dimension 
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
disp([' ', num2str(x(1)), '  ', num2str(x(2))])


% f_plus
disp('Fplus')
svm_struct = svmtrain(data_train, labels_train, ...
  'kernel_function', 'rbf', ...
  'rbf_sigma', param.ker, ...
  'boxconstraint', param.C, ...
  'method', 'SMO', ...
  'tolkkt', 1e-4, ...
  'kktviolationlevel', 0.15);
yhat = svmclassify(svm_struct, data_test);
[fp_sen, fp_spe, fp_err] = calc_statistics(labels_test, yhat);

% f_minus
disp('Fminus')
yhat_bad = sign(randn(m, 1));
svm_struct = svmtrain(data_train, yhat_bad, ...
  'kernel_function', 'rbf', ...
  'rbf_sigma', param.ker, ...
  'boxconstraint', param.C, ...
  'method', 'SMO', ...
  'tolkkt', 1e-5, ...
  'kktviolationlevel', 0.35);
yhat = svmclassify(svm_struct, data_train);
[fm_sen, fm_spe, fm_err] = calc_statistics(yhat_bad, yhat);


f_plus = [fp_err; fp_sen; fp_spe];
f_minus = [abs(.5-fm_err); abs(.5-fm_sen); abs(.5-fm_spe)];
f = [f_plus; f_minus];
