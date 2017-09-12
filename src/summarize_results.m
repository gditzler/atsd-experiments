clc
clear
close all;

addpath utils/

load outputs/moo_optimizer_alldatasets_3.mat
%load outputs/moo_optimizer_alldatasets.mat
all_datas_moo = all_datas;
clearvars -except all_errors_moo all_errors_mat counts_errors_moo counts_errors_mat all_datas_moo all_fms_moo
load outputs/matlab_optimizer_alldatasets.mat 
all_fms_mat = all_fms_moo;
load outputs/moo_optimizer_alldatasets_3.mat
% load outputs/moo_optimizer_alldatasets.mat
clearvars -except all_errors_moo3 all_errors_mat counts_errors_moo counts_errors_mat all_datas all_fms_moo all_fms_mat
% delete the spambase entry from MOO
% all_errors_moo(26, :) = [];
% counts_errors_moo(26, :) = [];

df = importdata('tpot-results.csv');


algs = {'None', '$\Fcal_1$', '$\Fcal_2$', '$\Fcal_3$', '$MAT$'};
tail = 'left';
alpha = 0.1;

clrs = {'\cellcolor{red!50}', '\cellcolor{red!40}', '\cellcolor{red!30}', '\cellcolor{red!20}', '\cellcolor{red!10}'};
% clrs = {' ', ' ', ' ', ' ', ' '};

errors = [all_fms_moo(:, 1:end-1) all_fms_mat];
counts = [counts_errors_moo(:, 1:end-1) counts_errors_mat];
errors = 1-errors./counts;
tpots = df.data(:,3);

% errors = [all_errors_moo(:, 1:end-1) all_errors_mat];
% counts = [counts_errors_moo(:, 1:end-1) counts_errors_mat];
% errors = errors./counts;
% tpots = df.data(:,2);

[hZtest, pZtest, pFtest, ranks] = friedman_demsar(errors, tail, alpha);
mean_ranks = mean(ranks);

errors = 1 - errors;

disp('\bf Data Set & \bf Samples & \bf Features & \bf None & $\Fcal_1$ & \bf $\Fcal_2$ & $\Fcal_3$ & MAT & TPOT \\')
for i = 1:length(all_datas)
  st = all_datas{i};
  data = load(['~/Git/ClassificationDatasets/csv/', all_datas{i}, '.csv']);
  st = [st, ' & ', num2str(size(data, 1)), ' & ', num2str(size(data, 2)-1)];
  for j = 1:size(errors, 2)
    st = [st, ' & ', clrs{floor(ranks(i,j))},' ', num2str(round(10000*errors(i, j))/100), ' (', num2str(ranks(i,j)), ')'];
  end
  disp([st,' & ', num2str(round(10000*tpots(i))/100), ' \\']);
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


% [z,p] = wilcoxon_demsar([100*errors(:, 4) 100*tpots], 'two')
% mean([100*errors(:, 2) 100*tpots])

%% with TPOT
clc
clear
close all
load outputs/moo_optimizer_alldatasets.mat
all_datas_moo = all_datas;
clearvars -except all_errors_moo all_errors_mat counts_errors_moo counts_errors_mat all_datas_moo all_fms_moo
load outputs/matlab_optimizer_alldatasets.mat 
all_fms_mat = all_fms_moo;
load outputs/moo_optimizer_alldatasets.mat
clearvars -except all_errors_moo all_errors_mat counts_errors_moo counts_errors_mat all_datas all_fms_moo all_fms_mat
% all_errors_moo(26, :) = [];
% counts_errors_moo(26, :) = [];
addpath utils/
df = importdata('tpot-results.csv');
% tpots = df.data(:,2);

errors = [all_fms_moo(:, 1:end-1) all_fms_mat];
counts = [counts_errors_moo(:, 1:end-1) counts_errors_mat];
errors = 1-errors./counts;
tpots = df.data(:,3);
% errors = [all_errors_moo(:, 1:end-1) all_errors_mat];
% counts = [counts_errors_moo(:, 1:end-1) counts_errors_mat];
% errors = errors./counts;
% tpots = df.data(:,2);


% errors = [all_errors_moo(:, 1:end-1) all_errors_mat];
% counts = [counts_errors_moo(:, 1:end-1) counts_errors_mat];
% errors = errors./counts;
% errors([1 31], :) = [];
[z,p] = wilcoxon_demsar([100*errors(:, 4) 100*tpots], 'two');
mean([100*errors(:, 2) 100*tpots])
%% times 
clc
clear
close all
load outputs/moo_optimizer_alldatasets.mat
timerz_moo = timerz;
all_datas1 = all_datas;
load outputs/matlab_optimizer_alldatasets.mat
timerz_mat = timerz2;
clearvars -except timerz_moo all_datas timerz_mat all_datas1

% tmp = zeros(32, 1);
% for i = 1:length(timerz_mat)
% %   disp(1+mod(i, 32))
%   tmp(1+mod(i, 32)) = tmp(1+mod(i, 32)) +timerz_mat(i);
% end
% timerz_mat = tmp;
% timerz_moo(26, :) = []; 
% all_datas(26) = [];
df = importdata('tpot-results.csv');
tpot = df.data(:,end);

% tpot = [194.6330724
% 152.0064351
% 87.67243428
% 261.7251741
% 234.3570615
% 161.2470259
% 492.7618651
% 266.4531227
% 394.2257247
% 172.3440971
% 236.3736534
% 71.6712728
% 105.6284629
% 458.9375704
% 64.20727148
% 325.8229757
% 454.0569175
% 462.1106052
% 498.0815334
% 213.718909
% 279.4226637
% 225.5648349
% 221.5413155
% 596.2744691
% 393.4123553
% 169.0178912
% 150.3791193
% 111.3104599
% 99.73696992
% 208.2854617];
% 
% timerz_mat([1 31], :) = [];
% all_datas([1 31]) = [];
% timerz_moo([1 31], :) = [];
algs = {'None', '$\Fcal_1$', '$\Fcal_2$', '$\Fcal_3$', 'Fmin', 'TPOT'};

disp('\bf Data Set  & \bf None & $\Fcal_1$ & \bf $\Fcal_2$ & $\Fcal_3$ & Fmin & TPOT \\');
[hZtest, pZtest, pFtest, ranks] = friedman_demsar([timerz_moo(:, 1:end-1) timerz_mat tpot], 'left', .05);
mean_ranks = mean(ranks);
clrs = {'\cellcolor{red!60}', '\cellcolor{red!50}', '\cellcolor{red!40}', '\cellcolor{red!30}', '\cellcolor{red!20}', '\cellcolor{red!10}'};
timerz = [timerz_moo(:, 1:end-1), timerz_mat,  tpot];

% for i = 1:length(all_datas)
%   disp([all_datas{i}, ' & ', num2str(round(timerz_moo(i, 1))), ' (', num2str(ranks(i, 1)), ')', ... %none
%     ' & ', num2str(round(timerz_moo(i, 2))), ' (', num2str(ranks(i, 2)), ')', ... % f1
%     ' & ', num2str(round(timerz_moo(i, 3))), ' (', num2str(ranks(i, 3)), ')', ... % f2
%     ' & ', num2str(round(timerz_moo(i, 4))), ' (', num2str(ranks(i, 4)), ')', ... % f3
%     ' & ', num2str(round(timerz_mat(i))), ' (', num2str(ranks(i, 5)), ')', ...
%     ' & ', num2str(round(tpot(i))), ' (', num2str(ranks(i, 6)), ')', '  \\'])
% end
for i = 1:length(all_datas)
  st = all_datas{i};
  for j = 1:size(timerz, 2)
    st = [st, ' & ', clrs{floor(ranks(i,j))},' ', num2str(round(timerz(i,j))), ' (', num2str(ranks(i,j)), ')'];
  end
  disp([st, ' \\']);
end
st = ' & ';
for j = 1:size(ranks, 2)
  st = [st, ' & ', num2str(mean_ranks(j))];
end
disp([st, ' \\'])


disp(' ')
disp(' ')
disp(' ')
st = [''];
for i = 1:size(ranks, 2)
  st = [st, ' & ', algs{i}];
end
disp([st, ' \\']);
for i = 1:size(ranks, 2)
  st = algs{i};
  for j = 1:size(ranks, 2)
    if i == j
      st = [st, ' & --'];
    else
      st = [st, ' & ', num2str(pZtest(i,j))];
    end
  end
  disp([st, ' \\'])
end
