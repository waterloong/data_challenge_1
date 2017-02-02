library(randomForest)

fit.rf <- randomForest(y ~ .,   data = train)
y.test.rf <- predict(fit.rf, newdata = x.train)
accuracy.rf <- mean(y.test.rf == y.label[, 1])

# print(accuracy.rf)
# best.rf <- fit.rf
# best.accuracy <- accuracy.rf
# 
# rekishi <- matrix(0, nrow = 50, ncol = 200)
# for (stem in 6:50) {
#   for (tree in 0:30) {
#     fit.rf <- randomForest(y ~ ., train[index, ], mtry = stem, ntree = 401 + 10 * tree)
#     y.test.rf <- predict(fit.rf, newdata = x.train[-index, ])
#     accuracy.rf <- mean(y.test.rf == y.label[-index, 1])
#     print(paste(best.accuracy, stem, tree))
#     rekishi[stem, tree - 400] <- accuracy.rf
#     if (accuracy.rf > best.accuracy) {
#       best.accuracy = accuracy.rf
#       best.rf <- fit.rf
#       print(paste("best", best.accuracy, stem, tree))
#     }
#   }
# }
# fit.rf <- best.rf
# fit.rf <- randomForest(y ~ ., train, mtry = 40, ntree = 600)
# y.test.rf <- predict(fit.rf, newdata = x.train)
# accuracy.rf <- mean(y.test.rf == y.label[, 1])
y.test.rf <- predict(fit.rf, newdata = x.test, type = "response")
write.result(y.test.rf, "rf_result.csv")

# y.train.rf <- predict(fit.rf, newdata = x.train)
# train.bag <- cbind(train.bag, y.train.rf)
# test.bag <- cbind(test.bag, y.test.rf)

# fit.rf <- randomForest(y ~ .,   data = partition.train)
# y.train.rf.train <- predict(fit.rf, newdata = partition.train, type = "response")
# accuracy.rf.train <- mean(y.train.rf.train == y.label[index, 1])
# y.train.rf.test <- predict(fit.rf, newdata = partition.test, type = "response")
# accuracy.rf.test <- mean(y.train.rf.test == y.label[-index, 1])

library(rpart)
fit.rpart <- rpart(y ~ .,   data = partition.train)
y.train.rpart <- predict(fit.rpart, newdata = partition.train, type = "class")
y.test.rpart <- predict(fit.rpart, newdata = x.train[-index, ], type = "class")
accuracy.rpart <- mean(y.test.rpart == y.label[-index,1])

best.rpart <- fit.rpart
best.accuracy <- accuracy.rpart
train.boost <- train.boost
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.rpart != y.label[index, 1], ])
  fit.rpart <- rpart(y ~ .,   data = train.boost)
  y.train.rpart <- predict(fit.rpart, newdata = x.train[index, ], type = "class")
  y.test.rpart <- predict(fit.rpart, newdata = x.train[-index, ], type = "class")
  accuracy.rpart <- mean(y.test.rpart == y.label[-index, 1])
  if (accuracy.rpart > best.accuracy) {
    best.accuracy = accuracy.rpart
    best.rpart <- fit.rpart
  } else {
    accuracy.rpart <- best.accuracy
    break
  }
}
fit.rpart <- best.rpart
y.test.rpart <- predict(fit.rpart, newdata = x.test, type = "class")
write.result(y.test.rpart, "rpart_result.csv")

y.train.rpart <- predict(fit.rpart, newdata = x.train, type = "class")
train.bag <- cbind(train.bag, y.train.rpart)
test.bag <- cbind(test.bag, y.test.rpart)

library(C50)
fit.c50 <- C5.0(y ~ .,   data = partition.train[index, ])
y.train.c50 <- predict(fit.c50, newdata = x.train[index, ], type = "class")
y.test.c50 <- predict(fit.c50, newdata = x.train[-index, ], type = "class")
accuracy.c50 <- mean(y.test.c50 == y.label[-index, 1])

best.c50 <- fit.c50
best.accuracy <- accuracy.c50
train.boost <- train
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.c50 != y.label[index, 1], ])
  fit.c50 <- C5.0(y ~ .,   train.boost)
  y.train.c50 <- predict(fit.c50, newdata = x.train[index, ], type = "class")
  y.test.c50 <- predict(fit.c50, newdata = x.train[-index, ], type = "class")
  accuracy.c50 <- mean(y.test.c50 == y.label[-index,1])
  if (accuracy.c50 > best.accuracy) {
    best.accuracy <- accuracy.c50
    best.c50 <- fit.c50
  } else {
    accuracy.c50 <- best.accuracy
    break
  }
}
fit.c50 <- best.c50
y.test.c50 <- predict(fit.c50, newdata = x.test, type = "class")
write.result(y.test.c50, "c50_result.csv")

y.train.c50 <- predict(fit.c50, newdata = x.train, type = "class")
train.bag <- cbind(train.bag, y.train.c50)
test.bag <- cbind(test.bag, y.test.c50)
