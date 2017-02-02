fit.glm <- glm(y ~ ., data = partition.train, family=binomial(link='logit')) 
y.train.glm <- ifelse(predict.glm(fit.glm, newdata = x.train[index, ], type = "response") > 0.5, 1 ,0)
y.test.glm <- ifelse(predict(fit.glm, newdata = x.train[-index, ], type = "response") > 0.5, 1, 0)
accuracy.glm <- mean(y.test.glm == y.label[-index, 1])

best.glm <- fit.glm
best.accuracy <- accuracy.glm
train.boost <- train
while (T) {
  train.boost <- rbind(train.boost, partition.train[y.train.glm != y.label[index, 1], ])
  fit.glm <- glm(y ~ .,   train.boost, family=binomial(link='logit'))
  y.train.glm <- ifelse(predict.glm(fit.glm, newdata = x.train[index, ], type = "response") > 0.5, 1 ,0)
  y.test.glm <- ifelse(predict(fit.glm, newdata = x.train[-index, ], type = "response") > 0.5, 1, 0)
  accuracy.glm <- mean(y.test.glm == y.label[-index, 1])
  if (accuracy.glm > best.accuracy) {
    best.accuracy = accuracy.glm
    best.glm <- fit.glm
  } else {
    accuracy.glm <- best.accuracy
    break
  }
}
fit.glm <- best.glm

y.test.glm <- ifelse(predict.glm(fit.glm, newdata = x.test, type = "response") > 0.5, 1 ,0)
write.result(y.test.glm, "glm_result.csv")

y.train.glm <- ifelse(predict.glm(fit.glm, newdata = x.train, type = "response") > 0.5, 1 ,0)
train.bag <- cbind(train.bag, y.train.glm)
test.bag <- cbind(test.bag, y.test.glm)
