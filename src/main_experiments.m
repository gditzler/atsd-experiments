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
  'fertility';
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
  'pittsburg-bridges-T-OR-D';
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
moo = 1;    % multi-objecive or single objective

% open up the parallel pool for moo only. simulated annealing does not use
% parallel processing 
if moo== 1 || moo == 3
 delete(gcp('nocreate'));  
 parpool(50, 'IdleTimeout', 180);
end

global DATASETZ;
global LAMBDA;

LAMBDA = .5;

for i = 1:length(all_datas)
  DATASETZ = [data_pth, all_datas{i}, '.csv'];
  disp(['Running ', DATASETZ])
  try 
    % some of the data sets throw an error with matlabs support vector
    % machine, so catch the error rather breaking the program
    [x, f, exitflag] = anti_training(params, moo);
    svstr = ['output/result_', all_datas{i}];
    if moo == 1
      svstr = [svstr, '_moo_exp01.mat'];
    elseif moo == 2
      svstr = [svstr, '_soo_sa.mat'];
    elseif moo == 3
      svstr = [svstr, '_soo_ga.mat'];
    end
    save(svstr);
  catch 
    disp(['   Error in ', all_datas{i}]);
  end
end




