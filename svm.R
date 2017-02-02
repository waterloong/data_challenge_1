library(e1071)

fit.svm <- svm(y ~ .,   data = partition.train)
y.train.svm <- predict(fit.svm, newdata = x.train[index, ])
y.test.svm <- predict(fit.svm, newdata = x.train[-index, ], type = "class")
accuracy.svm <- mean(y.test.svm == y.label[-index, 1])

best.svm <- fit.svm
best.accuracy <- accuracy.svm
train.boost <- train
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.svm != y.label[index, 1], ])
  fit.svm <- svm(y ~ .,   train.boost)
  y.train.svm <- predict(fit.svm, newdata = x.train[index, ], type = "class")
  y.test.svm <- predict(fit.svm, newdata = x.train[-index, ], type = "class")
  accuracy.svm <- mean(y.test.svm == y.label[-index, 1])
  if (accuracy.svm > best.accuracy) {
    best.accuracy = accuracy.svm
    best.svm <- fit.svm
  } else {
    accuracy.svm <- best.accuracy
    break
  }
}
fit.svm <- best.svm
y.test.svm <- predict(fit.svm, newdata = x.test)
write.result(y.test.svm, "svm_result.csv")

y.train.svm <- predict(fit.svm, newdata = x.train)
train.bag <- cbind(train.bag, y.train.svm)
test.bag <- cbind(test.bag, y.test.svm)
