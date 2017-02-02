colnames(train.bag) <- paste("classifier", 1:length(train.bag), sep = "")
colnames(test.bag) <- paste("classifier", 1:length(test.bag), sep = "")

# train.bag <- cbind(train.bag, x.train)
# test.bag <- cbind(test.bag, x.test)
#formula.bag <- as.formula(paste("y ~ (", ")^3", sep = paste(colnames(train.bag), collapse = " + ")))
#formula.bag <- as.formula(paste("y ~ ", " ", sep = paste(colnames(train.bag), collapse = " + ")))


train.bag <- cbind(y.label, train.bag)
colnames(train.bag)[1] = "y"

library(gbm)
fit.bag <- randomForest(y ~ ., train.bag)
# fit.bag <- xgboost(data = as.matrix(apply(train.bag[,-1], 2, as.factor)),
#               label = as.numeric(y.label[, 1]) - 1, 
#               nrounds = 80, 
#               objective = "binary:logistic",
#               verbose = 0)
y.test.bag <- predict(fit.bag, newdata = train.bag)
mean(y.test.bag == y.label[, 1])
y.test.bag <- predict(fit.bag, newdata = test.bag)

for (i in 1:500) {
  if (y.test.rf[i] == y.test.xgboost[i]) {
    y.test.bag[i] = y.test.rf[i]
  }
}

# fit.bag <- glm(formula = formula.bag, data = train.bag[index, ], family = binomial(link='logit'))
# 
# y.train.bag <- ifelse(predict.glm(fit.bag, newdata = train.bag[index, ], type = "response") > 0.5, 1 ,0)
# accuracy.train.bag <- mean(y.train.bag == y.label[index, 1])
# 
y.train.bag <- ifelse(apply(train.bag[index, 2:length(train.bag)], 1, function(x){return(mean(as.numeric(x)))}) > 0.5, 1 ,0)
accuracy.train.democracy <- mean(y.train.bag == y.label[index, 1])
# 
# y.train.bag <- ifelse(predict.glm(fit.bag, newdata = train.bag[-index, ], type = "response") > 0.5, 1 ,0)
# accuracy.test.bag <- mean(y.train.bag == y.label[-index, 1])
# 
# y.train.bag <- ifelse(apply(train.bag[-index, 2:length(train.bag)], 1, function(x){return(mean(as.numeric(x)))}) > 0.5, 1 ,0)
# accuracy.test.democracy <- mean(y.train.bag == y.label[-index, 1])
# y.test.bag <- ifelse(predict.glm(fit.bag, newdata = test.bag, type = "response") > 0.5, 1 ,0)
write.result(y.test.bag, "bag_result.csv")

train.bag <- train.bag[, -1]
