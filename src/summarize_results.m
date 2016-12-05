clc
clear
close all;

addpath utils/


load outputs/moo_optimizer_alldatasets.mat
load outputs/matlab_optimizer_alldatasets.mat
clearvars -except all_errors_moo all_errors_mat counts_errors_moo counts_errors_mat all_datas
% delete the spambase entry from MOO
all_errors_moo(26, :) = [];
counts_errors_moo(26, :) = [];

algs = {'None', '$\Fcal_1$', '$\Fcal_2$', '$\Fcal_3$', '$MAT$'};
tail = 'left';
alpha = 0.1;

clrs = {'\cellcolor{red!50}', '\cellcolor{red!30}', '\cellcolor{red!10}', '\cellcolor{yellow!25}', '\cellcolor{yellow!10}'};
% clrs = {' ', ' ', ' ', ' ', ' '};

errors = [all_errors_moo(:, 1:end-1) all_errors_mat];
counts = [counts_errors_moo(:, 1:end-1) counts_errors_mat];
errors = errors./counts;

[hZtest, pZtest, pFtest, ranks] = friedman_demsar(errors, tail, alpha);
mean_ranks = mean(ranks);


disp('\bf Data Set & \bf Samples & \bf Features & \bf None & $\Fcal_1$ & \bf $\Fcal_2$ & $\Fcal_3$ & MAT\\')
for i = 1:length(all_datas)
  st = all_datas{i};
  data = load(['~/Git/ClassificationDatasets/csv/', all_datas{i}, '.csv']);
  st = [st, ' & ', num2str(size(data, 1)), ' & ', num2str(size(data, 2)-1)];
  for j = 1:size(errors, 2)
    st = [st, ' & ', clrs{floor(ranks(i,j))},' ', num2str(round(10000*errors(i, j))/100), ' (', num2str(ranks(i,j)), ')'];
  end
  disp([st, ' \\']);
end
st = ' & &';
for j = 1:size(errors, 2)
  st = [st, ' & ', num2str(mean_ranks(j))];
end
disp([st, ' \\'])

disp(' ')
disp(' ')
disp(' ')

st = [''];
for i = 1:size(errors, 2)
  st = [st, ' & ', algs{i}];
end
disp([st, ' \\']);
for i = 1:size(errors, 2)
  st = algs{i};
  for j = 1:size(errors, 2)
    if i == j
      st = [st, ' & --'];
    else
      st = [st, ' & ', num2str(pZtest(i,j))];
    end
  end
  disp([st, ' \\'])
end

