function f = atsd_wrapper(x)

split = .8;

[ns, nf] = size(data);
q = randsample(1:ns, ns, true);
data = data(q, :);
labels = labels(q);


param.C = x(1);
param.ker = x(2);

% train svm 
svm_struct = svmtrain(data, labels, 'kernel_function', 'rbf', 'rbf_sigma', param.ker, 'boxconstraint', param.C, 'method', 'SMO');


% f_plus
yhat = svmclassify(svm_struct, data);
[err, sen, spe] = stats(labels_val, yhat);

% f_minus

f_plus = [err; c_sen; s_spe];
f_minus = [abs(.5-r_err); abs(.5-r_c_sen); abs(.5-r_s_spe)];
f = [f_plus; f_minus];
