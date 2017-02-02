library(MASS)
fit.lda <- lda(y ~ .,   data = partition.train)
y.train.lda <- predict(fit.lda, newdata = x.train[index,])$class
accuracy.lda <- mean(y.train.lda == y.label[index, 1])

best.lda <- fit.lda
best.accuracy <- accuracy.lda
train.boost <- train
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.lda != y.label[index, 1], ])
  fit.lda <- lda(y ~ .,   train.boost)
  y.train.lda <- predict(fit.lda, newdata = x.train[index, ])$class
  y.test.lda <- predict(fit.lda, newdata = x.train[-index, ])$class
  accuracy.lda <- mean(y.test.lda == y.label[-index, 1])
  if (accuracy.lda > best.accuracy) {
    best.accuracy = accuracy.lda
    best.lda <- fit.lda
  } else {
    accuracy.lda <- best.accuracy
    break
  }
}
fit.lda <- best.lda

y.test.lda <- predict(fit.lda, newdata = x.test)$class
write.result(y.test.lda, "lda_result.csv")

fit.qda <- qda(y ~ .,   data = partition.train)
y.train.qda <- predict(fit.qda, newdata = x.train[index, ])$class
y.test.qda <- predict(fit.qda, newdata = x.train[-index, ])$class
accuracy.qda <- mean(y.test.qda == y.label[-index, 1])

best.qda <- fit.qda
best.accuracy <- accuracy.qda
train.boost <- train
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.qda != y.label[index, 1], ])
  fit.qda <- qda(y ~ .,   train.boost)
  y.train.qda <- predict(fit.qda, newdata = x.train[index, ])$class
  y.test.qda <- predict(fit.qda, newdata = x.train[-index, ])$class
  accuracy.qda <- mean(y.test.qda == y.label[-index, 1])
  if (accuracy.qda > best.accuracy) {
    best.accuracy = accuracy.qda
    best.qda <- fit.qda
  } else {
    accuracy.qda <- best.accuracy
    break
  }
}
fit.qda <- best.qda

y.test.qda <- predict(fit.qda, newdata = x.test)$class
write.result(y.test.qda, "qda_result.csv")

y.train.lda <- predict(fit.lda, newdata = x.train)$class
y.train.qda <- predict(fit.qda, newdata = x.train)$class
train.bag <- cbind(train.bag, y.train.lda, y.train.qda)
test.bag <- cbind(test.bag, y.test.lda, y.test.qda)
