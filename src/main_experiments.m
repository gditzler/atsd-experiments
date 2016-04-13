clc;
clear;
close all;

addpath('atsd/');
addpath('utils/');
data_pth = '~/Git/ClassificationDatasets/csv/';

% SVM specific
params.nvar = 2;
params.PopulationSize = 20;

global DATASET;

DATASET = [data_pth, 'blood.csv'];

[x, f, exitflag] = anti_training(params);