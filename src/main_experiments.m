clc;
clear;
close all;

addpath('atsd/');
addpath('utils/');
data_pth = '/scratch/ditzler/Git/ClassificationDatasets/csv/';

all_datas = {'acute-inflammation';
  'acute-nephritis';
  'balloons';
  'bank';
  'blood';
  'breast-cancer-wisc-diag';
  'breast-cancer-wisc-prog';
  'breast-cancer-wisc';
  'breast-cancer';
  'chess-krvkp';
  'congressional-voting';
  'conn-bench-sonar-mines-rocks';
  'connect-4';
  'credit-approval';
  'cylinder-bands';
  'echocardiogram';
  'fertility';
  'haberman-survival';
  'heart-hungarian';
  'hepatitis';
  'ilpd-indian-liver';
  'ionosphere';
  'magic';
  'mammographic';
  'miniboone';
  'molec-biol-promoter';
  'mushroom';
  'musk-1';
  'oocytes_merluccius_nucleus_4d';
  'oocytes_trisopterus_nucleus_2f';
  'ozone';
  'parkinsons';
  'pima';
  'pittsburg-bridges-T-OR-D';
  'planning';
  'ringnorm';
  'spambase';
  'spect_test';
  'spect_train';
  'spectf_test';
  'spectf_train';
  'statlog-australian-credit';
  'statlog-german-credit';
  'statlog-heart';
  'tic-tac-toe';
  'titanic';
  'trains';
  'twonorm';
  'vertebral-column-2clases'};

% SVM specific
params.nvar = 2;
params.PopulationSize = 20;
moo = 1;            % multi-objecive or single objective

% open up the parallel pool for moo only. simulated annealing does not use
% parallel processing 
if moo 
  delete(gcp('nocreate'));  
  parpool(50);
end

global DATASETZ;

for i = 1:length(all_datas)
  DATASETZ = [data_pth, all_datas{i}, '.csv'];
  disp(['Running ', DATASETZ])
  try 
    % some of the data sets throw an error with matlabs support vector
    % machine, so catch the error rather breaking the program
    [x, f, exitflag] = anti_training(params, moo);
    svstr = ['output/result_', all_datas{i}];
    if moo
      svstr = [svstr, '_moo.mat'];
    else
      svstr = [svstr, '_soo.mat'];
    end
    save(['output/result_', all_datas{i}, '.mat']);
  catch 
    disp(['   Error in ', all_datas{i}]);
  end
end


