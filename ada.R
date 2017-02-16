library(fastAdaboost)

# fit.ada <- adaboost(y ~ .,   data = partition.train, nIter = 100)
# y.train.ada <- predict(fit.ada, newdata = x.train[index, ])$class
# y.test.ada <- predict(fit.ada, newdata = x.train[-index, ])$class
# accuracy.ada <- mean(y.test.ada == y.label[-index, 1])
fit.ada <- adaboost(y ~ .,   data = train, nIter = 100)
y.train.ada <- predict(fit.ada, newdata = train)$class
accuracy.ada <- mean(y.train.ada == y.label[, 1])

y.test.ada <- predict(fit.ada, newdata = x.test)$class
write.result(y.test.ada, "ada_result.csv")

y.train.ada <- predict(fit.ada, newdata = x.train)$class
train.bag <- cbind(train.bag, y.train.ada)
test.bag <- cbind(test.bag, y.test.ada)
