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

% SVM specific
params.nvar = 2;
params.PopulationSize = 50;
moo = 1;            % multi-objecive or single objective

% open up the parallel pool for moo only. simulated annealing does not use
% parallel processing 
if moo== 1 || moo == 3
 delete(gcp('nocreate'));  
 parpool(25, 'IdleTimeout', 180);
end

global DATASETZ;
global LAMBDA;

LAMBDA = .5;
timerz =[];
n_shuffles = 20;

filenames = {};
for n = 1:length(all_datas)
  filenames{n} = [data_pth, all_datas{n}, '.csv'];
end
% PartData(randseed, .8, filenames);


for n = 1:n_shuffles
  PartData(n, percent_train, filenames);

  for i = 1:length(all_datas)
    DATASETZ = [data_pth, all_datas{i}, '_train.csv'];
    disp(['Running ', DATASETZ])
    try 
      % some of the data sets throw an error with matlabs support vector
      % machine, so catch the error rather breaking the program
      tic;
      [x, f, exitflag] = anti_training(params, moo);
      timerz(end+1) = toc;
      
      datatr = load([data_pth, all_datas{i}, '_test.csv']);
      datate = load([data_pth, all_datas{i}, '_test.csv']);
      
      err_best = 10000000000000;
      
      for j = 1:size(x, 2)
        svm_struct = svmtrain(datatr(:, 1:end-1), datatr(:, end), ...
          'kernel_function', 'rbf', ...
          'rbf_sigma', x(j, 2), ...
          'boxconstraint', x(j, 1), ...
          'method', 'SMO', ...
          'tolkkt', 1e-4, ...
          'kktviolationlevel', 0.15, ...
          'options', options);
        yhat = svmclassify(svm_struct, datate(:, 1:end-1));
        err = calc_error(yhat, datate(:, end));
        if err<err_best
          err_best = err;
          min_param = x(j, :);
        end
      end
      
      
      svstr = ['outputs/result_', all_datas{i}];
      if moo == 1
        svstr = [svstr, '_moo_exp04_', num2str(n),'.mat'];
      elseif moo == 2
        svstr = [svstr, '_soo_sa_', num2str(n),'.mat'];
      elseif moo == 3
        svstr = [svstr, '_soo_ga_', num2str(n),'.mat'];
      end
      save(svstr);
    catch 
      disp(['   Error in ', all_datas{i}]);
    end
  end
end



