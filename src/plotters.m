%% risk plot
clc
clear
close all

x = -2:0.1:2;
%br = x.^2;
er = 7*exp(-2*(x+2))+.5;
ci = fliplr(er);
br = er+ci;
lw = 1;
ms = 10;

h = figure;
hold on;
box on;
plot(x, br, '-s', 'LineWidth', lw, 'MarkerSize', ms);
plot(x, er, '-o', 'LineWidth', lw, 'MarkerSize', ms);
plot(x, ci, '-p', 'LineWidth', lw, 'MarkerSize', ms);
plot([-1 -1], [-10 2], 'k--')
plot([0 0], [-10 min(br)], 'k')
plot([1 1], [-10 2], 'k--')
text(-.95, .19, '$$h_1$$','Interpreter','latex', 'fontsize', 30)
text(0.05, .19, '$$h^*$$','Interpreter','latex', 'fontsize', 30)
text(1.05, .19, '$$h_2$$','Interpreter','latex', 'fontsize', 30)
xlabel('$$h$$','Interpreter','latex', 'FontSize', 30)
ylim([0, 4])

legend('Bounded Risk', 'Empirical Risk', 'Confidence Interval', 'Location', 'best')
set(gca,'XTickLabel','')
set(gca,'YTickLabel','')
set(gca, 'fontsize', 20)
saveas(h, 'plots/risk-plot.fig')
saveas(h, 'plots/eps/risk-plot.eps', 'eps2c')
%% result tables 
clc
clear
close all

load outputs/cross_validation_tables.mat

min_errors = [all_errors(:, 1), min(all_errors(:,2:4), [], 2)];
[nd, na] = size(all_errors);
[hZtest, pZtest, pFtest, ranks] = friedman_demsar(all_errors, 'two', .05);
[z, p] = wilcoxon_demsar(min_ errors, 'two'); 

for j = 1:size(all_errors, 1)
  str = [all_datas_2{j}, ' & '];
  data = load(['~/Git/ClassificationDatasets/csv/', all_datas_2{j}, '.csv']);
  
  str = [str, num2str(size(data,1)), ' & ', num2str(size(data,2)-1), ' & '];
  
  for i = 1:size(all_errors, 2)
    str = [str, num2str(round(1000*all_errors(j,i))/10), ' (', num2str(ranks(j,i)), ') & '];
  end
  merr = min(all_errors(j,2:4));
  if merr < all_errors(j,1)
    str = [str, ' \bf ', num2str(round(1000*merr)/10), ' & '];
  else
    str = [str, num2str(round(1000*merr)/10), ' & '];
  end
  
  str = [str(1:end-2), ' \\'];
  disp(str)
end
rm = mean(ranks);
str = ' & ';
for i = 1:numel(rm)
  str = [str, num2str(rm(i)), ' & '];
end
str = [str(1:end-2), ' \\'];
disp(str)
%% 
clc
clear 
close all

addpath('utils/')

% all of the data sets that have been tested. all of the data sets are
% saved in a private repo. 
all_datas_2 = {
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

n_data = length(all_datas_2);

mm = {'rx', 'bo', 'ks', 'mp', 'c*'};


for nn = 1:n_data
  close all
  hh=figure;
  hold on;
  box on;
  for ee = 1:4
    load(['outputs/result_', all_datas_2{nn}, '_moo_exp0', num2str(ee), '.mat']);
    plot(log(x(:,1)), x(:,2), mm{ee}, 'MarkerSize', 15);        
  end
  load(['outputs/result_', all_datas_2{nn}, '_matlab.mat']);
  plot(log(x(1)), x(2), mm{end}, 'MarkerSize', 15);
  legend('None', 'F1', 'F2','F3', 'Fmin', 'Location', 'best')
  %title(all_datas_2{nn});
  xlabel('log(C)', 'FontSize', 20)
  ylabel('\sigma', 'FontSize', 30)
  set(gca, 'fontsize', 20)

  saveas(hh, ['fig/pareto_solultions_',all_datas_2{nn}, '.fig']);
  saveas(hh, ['eps/pareto_solultions_',all_datas_2{nn}, '.eps'], 'eps2c');
  
end
