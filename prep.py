import pandas as pd
import xgboost as xgb
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import ExtraTreesClassifier

x_train = pd.read_csv('train.csv', sep=',', header=None)
y_train = pd.read_csv('label.csv', sep=',', header=None)
x_test = pd.read_csv('test.csv', sep=',', header=None)


dmatrix_train = xgb.DMatrix(x_train, y_train)

param = {}
param['max_depth'] = 12
param['nthread'] = 4
param['num_class'] = 2
param['eta'] = 0.01

xgb_model = xgb.train(param, dmatrix_train, 500)

dmatrix_test = xgb.DMatrix(x_test)


y_test = xgb_model.predict(dmatrix_test)

v = xgb_model.predict(xgb.DMatrix(x_train)).astype(int)
print sum(v == y_train[0].values) / 4000.0

np.savetxt("results/python/xgb_result.csv", np.dstack((np.arange(1, y_test.size+1),y_test))[0],"\"%d\",\"%d\"",header="Id,SpamLabel",comments="")

rf_model = RandomForestClassifier(n_estimators=20, n_jobs=2)
rf_model.fit(x_train, y_train[0].values)

y_test = rf_model.predict(x_test)
np.savetxt('results/python/rf_result.csv', np.dstack((np.arange(1, y_test.size+1),y_test))[0],"\"%d\",\"%d\"",header="Id,SpamLabel",comments="")

xt_model = ExtraTreesClassifier(n_estimators=20, n_jobs=2)
xt_model.fit(x_train, y_train[0].values)
y_test = xt_model.predict(x_test)
np.savetxt('results/python/xt_result.csv', np.dstack((np.arange(1, y_test.size+1),y_test))[0],"\"%d\",\"%d\"",header="Id,SpamLabel",comments="")
