function [x, f] =svm_search_matlab(dataset)

n_runs = 10;

X = load(dataset);   % DATASET is a global var in the main experimenter

% load the data and split
data = X(:, 1:end-1); 
labels  = X(:, end);  % labels are in the last dimension 
if length(unique(labels)) ~= 2
  error('Must be a two class problem.');
end
%data = zscore(data);

[ns, ~] = size(data);
q = randperm(ns);

data = data(q, :);
labels = labels(q);
labels(labels == 0) = -1;

c = cvpartition(numel(labels), 'KFold', 10);
minfn = @(z)kfoldLoss(fitcsvm(data, labels, ...
                              'CVPartition', c , ...
                              'KernelFunction', 'rbf', ...
                              'BoxConstraint', exp(z(2)), ...
                              'KernelScale',exp(z(1))));
                            
opts = optimset('TolX', 5e-4, 'TolFun', 5e-4);

fval = zeros(n_runs, 1);
z = zeros(n_runs, 2);
parfor j = 1:n_runs
    zz = 5*randn(2,1);
    [searchmin, fval(j)] = fminsearch(minfn, zz, opts);
    z(j,:) = exp(searchmin);
end
z = z(fval == min(fval),:);


% C, \sigma
x = [z(2);z(1)];
f = min(fval);

