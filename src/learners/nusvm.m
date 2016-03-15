function [err, c_sen, s_spe] = nusvm(data, labels, param, rand_state)

[ns, nf] = size(data);

% randomly assign the class labels 
if randstate
  label_temp = [ones(floor(param.split*ns), 1);
                -ones(floor((1-param.split)*ns), 1)];
  r = randperm(ns);
  label_temp(r) = label_temp;
  labels = label_temp;
end