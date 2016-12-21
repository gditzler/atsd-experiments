#!/usr/bin/env python

import time 
import numpy as np
import pandas as pd

from tpot import TPOTClassifier
from sklearn.metrics import f1_score
from sklearn.model_selection import train_test_split

def main():

  # set up the path to the data sets and the data were are going to experiment 
  # with 
  base_path = '/scratch/ditzler/Git/ClassificationDatasets/csv/'
  data_setz = [#'bank',
    'blood',
    'breast-cancer-wisc-diag',
    'breast-cancer-wisc-prog',
    'breast-cancer-wisc',
    'breast-cancer',
    'congressional-voting',
    'conn-bench-sonar-mines-rocks',
    'credit-approval',
    'cylinder-bands',
    'echocardiogram',
    #'fertility',
    'haberman-survival',
    'heart-hungarian',
    'hepatitis',
    'ionosphere',
    'mammographic',
    'molec-biol-promoter',
    'musk-1',
    'oocytes_merluccius_nucleus_4d',
    'oocytes_trisopterus_nucleus_2f',
    'ozone',
    'parkinsons',
    'pima',
    #'pittsburg-bridges-T-OR-D';
    'planning',
    'ringnorm',
    #'spambase',
    'spectf_train',
    'statlog-australian-credit',
    'statlog-german-credit',
    'statlog-heart',
    'titanic',
    #'twonorm',
    'vertebral-column-2clases']

  # nsplits is like the number of cv (its bootstraps here) then set up some variales
  # to save the results to. 
  n_splitz = 10
  errors = np.zeros((len(data_setz),))
  fms = np.zeros((len(data_setz),))
  times = np.zeros((len(data_setz),))
  m = 0

  for n in range(n_splitz):
    print 'Spilt ' + str(n) + ' of ' + str(n_splitz)
    for i in range(len(data_setz)):
      print '    ' + data_setz[i]
      df = pd.read_csv(base_path + data_setz[i] + '.csv', sep=',')
      data = df.as_matrix()
      X = data[:, :-1]
      y = data[:, -1]
      X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.75, test_size=0.25, random_state=m)
      m += 1
      
      ts = time.time()
      tpot = TPOTClassifier(generations=10, population_size=25, verbosity=1)
      tpot.fit(X_train, y_train)
      times[i] += (time.time() - ts)

      errors[i] += (1-tpot.score(X_test, y_test))
      yhat = tpot.predict(X_test)
      fms[i] += f1_score(y_test, yhat, average='macro')
  
  errors /= n_splitz
  fms /= n_splitz
  times /= n_splitz

  df = pd.DataFrame({'errors': errors, 'fms': fms, 'times': times})
  df.to_csv(path_or_buf='tpot-results2.csv', sep=',')

  return None 


if __name__ == '__main__':
  main()
