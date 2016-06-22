clc;
clear;
close all;

addpath('atsd/');
addpath('utils/');
data_pth = '/scratch/ditzler/Git/ClassificationDatasets/csv/';

all_datas = {
  'bank';
  'blood';
  'breast-cancer-wisc-diag';
  'breast-cancer-wisc-prog';
  'breast-cancer-wisc';
  'breast-cancer';
  'congressional-voting';
  'conn-bench-sonar-mines-rocks';
  'credit-approval';
  'cylinder-bands';
  'echocardiogram';
  %'fertility';
  'haberman-survival';
  'heart-hungarian';
  'hepatitis';
  'ionosphere';
  'mammographic';
  'molec-biol-promoter';
  'musk-1';
  'oocytes_merluccius_nucleus_4d';
  'oocytes_trisopterus_nucleus_2f';
  'ozone';
  'parkinsons';
  'pima';
  %'pittsburg-bridges-T-OR-D';
  'planning';
  'ringnorm';
  'spambase';
  'spectf_train';
  'statlog-australian-credit';
  'statlog-german-credit';
  'statlog-heart';
  'titanic';
  'twonorm';
  'vertebral-column-2clases'};


delete(gcp('nocreate'));  
parpool(15, 'IdleTimeout', 180);

global DATASETZ;
global LAMBDA;

LAMBDA = .5;
timerz = [];

n_shuffles = 20;

filenames = {};
for n = 1:nd
  filenames{n} = [data_pth, all_datas{n}, '.csv'];
end
% PartData(randseed, .8, filenames);

all_errors_mat = zeros(length(all_datas), 1);
counts_errors_mat = zeros(length(all_datas), 1);


for n = 1:n_shuffles
  PartData(n, .8, filenames);
  for i = 1:length(all_datas)
    DATASETZ = [data_pth, all_datas{i}, '_train.csv'];
    disp(['Running ', DATASETZ])
    try 
      % some of the data sets throw an error with matlabs support vector
      % machine, so catch the error rather breaking the program
      tic;
      [x, f] = svm_search_matlab(DATASETZ);
      timerz(end+1) = toc;
      
      datatr = load([data_pth, all_datas{i}, '_train.csv']);
      datate = load([data_pth, all_datas{i}, '_test.csv']);
        
      err_best = 10000000000000;
      options.MaxIter = 100000;
      calc_error = @(actual, prediction)(sum(actual ~= prediction)/length(prediction));

      svm_struct = svmtrain(datatr(:, 1:end-1), datatr(:, end), ...
        'kernel_function', 'rbf', ...
        'rbf_sigma', x(2), ...
        'boxconstraint', x(1), ...
        'method', 'SMO', ...
        'tolkkt', 1e-4, ...
        'kktviolationlevel', 0.15, ...
        'options', options);
      yhat = svmclassify(svm_struct, datate(:, 1:end-1));
      err_best = calc_error(yhat, datate(:, end));
      
      all_errors_mat(i) = all_errors_mat(i) + err_best;
      counts_errors_mat(i) = counts_errors_mat(i) + 1;
      
      svstr = ['outputs/result_', all_datas{i}, '_matlab_', num2str(n),'.mat'];
      save(svstr);
    catch 
      disp(['   Error in ', all_datas{i}]);
    end
  end
end



