library(knncat)

fit.knn <- knncat(train = partition.train, test = partition.test, classcol = 101)
y.train.knn <- predict(fit.knn, newdata = x.train)
accuracy.knn <- mean(y.train.knn == y.label[,1])
y.test.knn <- predict(fit.knn, newdata = x.test)
write.result(y.test.knn, "knn_result.csv")

train.bag <- cbind(train.bag, y.train.knn)
test.bag <- cbind(test.bag, y.test.knn)
