clc;
clear;
close all;

addpath('atsd/');
addpath('utils/');
% data_pth = '/scratch/ditzler/Git/ClassificationDatasets/csv/';
data_pth = '~/Git/ClassificationDatasets/csv/';

all_datas = {
  %'bank';
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
  %'spambase';
  'spectf_train';
  'statlog-australian-credit';
  'statlog-german-credit';
  'statlog-heart';
  'titanic';
  %'twonorm';
  'vertebral-column-2clases'};


% SVM specific
params.nvar = 2;
params.PopulationSize = 25;
moo = 1;            % multi-objecive or single objective

% open up the parallel pool for moo only. simulated annealing does not use
% parallel processing 
if moo== 1 || moo == 3
 delete(gcp('nocreate'));  
 parpool(4, 'IdleTimeout', 180);
end

global DATASETZ;
global LAMBDA;

LAMBDA = .5;
timerz =[];
n_shuffles = 10;
ftypes = 5;

filenames = {};
for n = 1:length(all_datas)
  filenames{n} = [data_pth, all_datas{n}, '.csv'];
end
% PartData(randseed, .8, filenames);

timerz = zeros(length(all_datas), ftypes);

all_errors_moo = zeros(length(all_datas), ftypes);
counts_errors_moo = zeros(length(all_datas), ftypes);
all_fms_moo = zeros(length(all_datas), ftypes);
all_errors_avg_moo = zeros(length(all_datas), ftypes);
all_3errors_avg_moo = zeros(length(all_datas), ftypes);

for n = 1:n_shuffles
  disp(['Average ', num2str(n), ' of ', num2str(n_shuffles)]);
  PartData(n, .8, filenames);

  for i = 1:length(all_datas)
    DATASETZ = [data_pth, all_datas{i}, '_train.csv'];
    disp(['  -> Running ', DATASETZ])
    
    for a = 1:ftypes
      %try 
        % some of the data sets throw an error with matlabs support vector
        % machine, so catch the error rather breaking the program
        tic;
        [x, f, exitflag] = anti_training(params, moo, a);
        timerz(i, a) = timerz(i, a) + toc;

        datatr = load([data_pth, all_datas{i}, '_train.csv']);
        datate = load([data_pth, all_datas{i}, '_test.csv']);
                
        err_best = 10000000000000;
        options.MaxIter = 100000;
        calc_error = @(actual, prediction)(sum(actual ~= prediction)/length(prediction));
        err_avg = 0;
        err_3best = zeros(1, size(x, 1));
        
        for j = 1:size(x, 1)
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
            stats = confusionmatStats(datate(:, end), yhat);
            fms_best = mean(stats.Fscore);
            min_param = x(j, :);
          end
          err_avg = err_avg+err;
          err_3best(j) = err;
        end

        all_fms_moo(i, a) = all_fms_moo(i, a) + fms_best;
        all_errors_moo(i, a) = all_errors_moo(i, a) + err_best;
        all_errors_avg_moo(i, a) = all_errors_avg_moo(i, a) + err_avg/size(x, 1);
        
        %err_3best = sort(err_3best);
        %if size(x, 1) < 3
        %  merr = mean(err_3best);
        %else
        %  merr = mean(err_3best(1:3));
        %end
        all_3errors_avg_moo(i, a) = all_3errors_avg_moo(i, a) + mean(err_3best);
        
        counts_errors_moo(i, a) = counts_errors_moo(i, a) + 1;
        save('outputs/moo_optimizer_alldatasets_3.mat');
      %catch 
      %  disp(['   Error in ', all_datas{i}]);
      %end
    end
  end
end

save('outputs/moo_optimizer_alldatasets_3.mat');


