function [z,p] = wilcoxon_demsar(scores,tail)
% WILCOXON_DEMSAR
%    [z,p,col2bet1] = WILCOXON_DEMSAR(scores)
%      :scores - Nx2 matrix of scores
%      :tail - 'one', 'two'
%      :z - z-score from Wilcoxon signed rank test
%      :p - p-value
%
%
%  Implement the Wilcoxon signed rank test described by Demsar
%  in his Journal of Machine Learning Research Paper. If column
%  two is better than column one, then we reject the null 
%  hypothesis that the classifiers are performing equally on 
%  the data sets tested. 
% 
%  The Wilcoxon signed ranks test is more sensible than the t-test. 
%  It assumes commensurability of differences, but only qualitatively: 
%  greater differences still count more, which is probably desired,
%  but the absolute magnitudes are ignored. From the statistical point 
%  of view, the test is safer since it does not assume normal 
%  distributions. Also, the outliers (exceptionally good/bad performances 
%  on a few data sets) have less effect on the Wilcoxon than on the 
%  t-test.
% 
%  Reference
%    Dem{\vs}ar, Janez, "Statistial Comparisions of Classifiers on
%       Multiple Data Sets," Journal of Machine Learning Research, 
%       vol. 7, pp. 1-30, 2006
% 
%
%  written by: gregory ditzler (april 2012)
if nargin == 1
  tail = 'two';
end
N     = size(scores,1);            % number of data sets tested
diff  = scores(:,2) - scores(:,1); % get differences in score
ranks = fracrank(abs(diff));       % ignore the sign and rank
Rp    = sum(ranks(diff>0)) + 0.5*sum(ranks(diff==0)); 
Rn    = sum(ranks(diff<0)) + 0.5*sum(ranks(diff==0)); 
T     = min([Rp,Rn]);
z     = (T - 0.25*N*(N+1)) / (sqrt( N*(N + 1)*(2*N + 1)/24 ));
% switch tail
%   case 'two'
%     p = 2*normcdf(-abs(z));
%   case 'one'
%     p = normcdf(z);
% end
switch tail%%%% this only applies to the z-test
  case 'right'     % right one-tailed test
    % "mean is greater than M" (right-tailed test)
    p = normcdf(-z);
  case 'left'      % left one-tailed test
    % "mean is less than M" (left-tailed test)
    p = normcdf(z);
  case 'two'  % two-tailed test
    % "mean is not M" (two-tailed test)
    p = 2*normcdf(-abs(z));
end