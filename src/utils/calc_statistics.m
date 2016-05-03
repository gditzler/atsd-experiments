function [sensitivity, specificity, error] = calc_statistics(y_true, y_hat)
% [sensitivity, specificity, error] = calc_statistics(y_true, y_hat)
%
%  Calculate some basic statistics about the classification of a binary
%  classification problem. 
%
%  INPUT 
%      y_true - true class labels (2 class)
%      y_hat  - multi-class labels
%  OUTPUT 
%      sensitivity 
%      specificity 
%      error      
%
%  Written by Gregory Ditzler
% 
c_mat = confusionmat(y_true, y_hat);
error = 1 - sum(diag(c_mat))/sum(sum(c_mat));
sensitivity = c_mat(1,1)/(c_mat(1,1)+c_mat(2,1));
specificity = c_mat(2,2)/(c_mat(2,2)+c_mat(1,2));
if c_mat(1,1)+c_mat(2,1) == 0
  sensitivity = 0;
end
if c_mat(2,2)+c_mat(1,2) == 0
  specificity = 0;
end
