# About 

This repository holds code for implementing different forms of anti-training as initially presented by Valenzuela and Rozenblit. 

# Notes 

Matlab's implementation of the SVM needs to be modified if you plan on using SMO. You need to comment out the line in `/usr/local/MATLAB/R2015b/toolbox/stats/stats/private/seqminopt.m` where there an error message will be sent if the SMO algorithm does not converge to the user's threshold. If the line is left in `seqminopt`, the GA will not run because of the anti-training step. 

# Contributors 



