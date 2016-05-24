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

for i = 1:length(all_datas)
  DATASETZ = [data_pth, all_datas{i}, '_train.csv'];
  disp(['Running ', DATASETZ])
  try 
    % some of the data sets throw an error with matlabs support vector
    % machine, so catch the error rather breaking the program
    tic;
    [x, f] = svm_search_matlab(DATASETZ);
    timerz(end+1) = toc;
    svstr = ['outputs/result_', all_datas{i}, '_matlab.mat'];
    save(svstr);
  catch 
    disp(['   Error in ', all_datas{i}]);
  end
end




