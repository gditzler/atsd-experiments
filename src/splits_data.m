% clc
clear
close all


% PartData( randseed, percent_train, filenames, optional_postfix )

addpath('utils/');
data_pth = '~/Git/ClassificationDatasets/csv/';

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

nd = length(all_datas);
filenames = cell(1, nd);
percent_train = .8;
randseed = 0;

for n = 1:nd
  filenames{n} = [data_pth, all_datas{n}, '.csv'];
end
PartData(randseed, percent_train, filenames);
