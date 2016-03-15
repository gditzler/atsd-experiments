function f = atsd_wrapper(x)

[ns, nf] = size(data);
q = randsample(1:ns, ns, true);
data = data(q, :);
labels = labels(q);

param.nu = x(1);
param.ker = x(2);

[err, c_sen, s_spe] = nusvm(data, labels, param, rand_state);
[r_err, r_c_sen, r_s_spe] = nusvm(data, labels, param, rand_state);


f_plus = [err; c_sen; s_spe];
f_minus = [abs(.5-r_err); abs(.5-r_c_sen); abs(.5-r_s_spe)];
f = [f_plus; f_minus];
