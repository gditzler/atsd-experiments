clc;
clear;
close all;

addpath('atsd/');
addpath('utils/');
data_pth = '~/Git/ClassificationDatasets/csv/';

all_datas = {'acute-inflammation';
  'acute-nephritis';
  'adult_test';
  'adult_train';
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
  'hill-valley_test';
  'hill-valley_train';
  'horse-colic_test';
  'horse-colic_train';
  'ilpd-indian-liver';
  'ionosphere';
  'magic';
  'mammographic';
  'miniboone';
  'molec-biol-promoter';
  'monks-1_test';
  'monks-1_train';
  'monks-2_test';
  'monks-2_train';
  'monks-3_test';
  'monks-3_train';
  'mushroom';
  'musk-1';
  'musk-2';
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

global DATASETZ;

DATASETZ = [data_pth, 'blood.csv'];

% [x, f, exitflag] = anti_training(params);


