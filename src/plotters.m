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