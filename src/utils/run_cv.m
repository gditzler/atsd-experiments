function errs = run_cv(data, C, bandwith)

n_folds = 10;
options.MaxIter = 100000;

% split the data 
X = data(:, 1:end-1); 
y  = data(:, end);  % labels are in the last dimension 
if length(unique(y)) ~= 2
  error('Must be a two class problem.');
end
ns = size(X, 1);
q = randperm(ns);
X = X(q, :);
y = y(q);
y(y == 0) = -1;

cv = cvpartition(ns, 'k', n_folds); % initialize the CV
calc_error = @(actual, prediction)(sum(actual ~= prediction)/length(prediction));
errs = zeros(1, n_folds);

parfor i = 1:n_folds
  % get the training and testing indices from the cv object for the ith
  % iteration. 
  i_tr = cv.training(i);
  i_te = cv.test(i);
  
  % generate a classifier and get the predictions on the test data 
  svm_struct = svmtrain(X(i_tr, :), y(i_tr), ...
    'kernel_function', 'rbf', ...
    'rbf_sigma', bandwith, ...
    'boxconstraint', C, ...
    'method', 'SMO', ...
    'tolkkt', 1e-4, ...
    'kktviolationlevel', 0.15, ...
    'options', options);
  yhat = svmclassify(svm_struct, X(i_te, :));
  errs(i) = calc_error(yhat, y(i_te));
end
errs = mean(errs);

