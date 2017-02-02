library(e1071)

fit.nb <- naiveBayes(y ~ .,   data = partition.train)
y.train.nb <- predict(fit.nb, newdata = x.train[index, ])
y.test.nb <- predict(fit.nb, newdata = x.train[-index, ])
accuracy.nb <- mean(y.test.nb == y.label[-index, 1])

best.nb <- fit.nb
best.accuracy <- accuracy.nb
train.boost <- train
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.nb != y.label[index, 1], ])
  fit.nb <- naiveBayes(y ~ .,   train.boost)
  y.train.nb <- predict(fit.nb, newdata = x.train[index, ])
  y.test.nb <- predict(fit.nb, newdata = x.train[-index, ])
  accuracy.nb <- mean(y.test.nb == y.label[-index, 1])
  if (accuracy.nb > best.accuracy) {
    best.accuracy = accuracy.nb
    best.nb <- fit.nb
  } else {
    accuracy.nb <- best.accuracy
    break
  }
}
fit.nb <- best.nb

y.test.nb <- predict(fit.nb, newdata = x.test)
write.result(y.test.nb, "nb_result.csv")

y.train.nb <- predict(fit.nb, newdata = x.train)
train.bag <- cbind(train.bag, y.train.nb)
test.bag <- cbind(test.bag, y.test.nb)
