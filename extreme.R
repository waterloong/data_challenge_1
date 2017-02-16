library(xgboost)

x.train.m <- data.matrix(x.train)
x.test.m <- data.matrix(x.test)

fit.xgboost <- xgboost(#params = list(eta = 0.1, max_depth = 9),
                        data = x.train.m, 
                       label = as.numeric(y.label[, 1]) - 1, 
                       nrounds = 80, 
                       objective = "binary:logistic",
                       verbose = 1)
y.test.xgboost <- as.integer(predict(fit.xgboost, newdata = x.train.m) > 0.5)
accuracy.xgboost <- mean(y.test.xgboost == y.label)
# 
# best.xgboost <- fit.xgboost
# best.accuracy <- accuracy.xgboost
# 
# for (n in 5:80) {
#   train.boost <- as.matrix(train)
#   print(paste(n))
#   while (T) {
#     train.boost <- as.matrix(rbind(train.boost, train.boost[y.train.xgboost != y.label[index, 1], ]))
#     fit.xgboost <- xgboost(data = train.boost[index, -101], 
#                            label = train.boost[index, 101], 
#                            nrounds = n, 
#                            objective = "binary:logistic",
#                            verbose = 0)
#     y.train.xgboost <- as.integer(predict(fit.xgboost, newdata = train.boost[index, ]) > 0.5)
#     y.test.xgboost <- as.integer(predict(fit.xgboost, newdata = x.train[-index, ]) > 0.5)
#     accuracy.xgboost <- mean(y.test.xgboost == y.label[-index, 1])
#     
#     if (accuracy.xgboost > best.accuracy) {
#       best.accuracy = accuracy.xgboost
#       best.xgboost <- fit.xgboost
#     } else {
#       accuracy.xgboost <- best.accuracy
#       break
#     }
#     print(paste(accuracy.xgboost, best.accuracy))
#   }
# }
# fit.xgboost <- best.xgboost
y.test.xgboost <- as.factor(as.integer(predict(fit.xgboost, newdata = x.test.m) > 0.5))
write.result(y.test.xgboost, "xgboost_result.csv")

# y.train.xgboost <- as.integer(predict(fit.xgboost, newdata = x.train.m) > 0.5)
# train.bag <- cbind(train.bag, y.train.xgboost)
# test.bag <- cbind(test.bag, y.test.xgboost)
