library(nnet)


s = 12
best.accuracy <- 0
best.nn1 <- NULL
for (i in 1:30) {
  fit.nn1 <- nnet(y ~ ., data = partition.train, size = s, maxit = 1000, trace = F, MaxNWts = 65535)
  y.test.nn1 <- predict(fit.nn1, partition.test, type = "class")
  accuracy.nn1 <- mean(y.test.nn1 == y.label[-index, 1])
  if (accuracy.nn1 > best.accuracy) {
    best.accuracy = accuracy.nn1
    best.nn1 <- fit.nn1
    print(best.accuracy)
  }
  y.train.nn1 <- predict(fit.nn1, partition.train, type = "class")
  accuracy.nn1 <- mean(y.train.nn1 == y.label[index, 1])
}
fit.nn1 <- best.nn1
y.train.nn1 <- predict(fit.nn1, x.train, type = "class")
accuracy.nn1 <- mean(y.train.nn1 == y.label[, 1])
y.test.nn1 <- predict(fit.nn1, x.test, type = "class")
write.result(y.test.nn1, "nn1_result.csv")

train.bag <- cbind(train.bag, y.train.nn1)
test.bag <- cbind(test.bag, y.test.nn1)
