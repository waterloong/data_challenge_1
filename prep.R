setwd("~/Google Drive/UW/STAT441/data_challenge_1/")
x.train <- read.csv("train.csv", header = FALSE)
x.test <- read.csv("test.csv", header = FALSE)
y.label <- read.csv("label.csv", header = FALSE)

docf <- lapply(x.train[1:90], function(x) {return(x > 0)})
docf <- lapply(docf, mean)
for (i in 1:90) {
  x.train[i] = x.train[i] / docf[i]
  x.test[i] = x.test[i] / docf[i]
}

# x.train.pca <- prcomp(x.train, center = T, scale. = T)
# x.train <- data.frame(x.train.pca$x[, 1:99])
# x.test <- as.data.frame(predict(x.train.pca, newdata = x.test)[, 1:99])

y.label[, 1] <- as.factor(x = y.label[, 1])
train <- cbind(x.train,  y.label)
colnames(train)[length(train)]<-"y"


write.result <- function(result, file.name) {
  Id <- 1:500
  if (class(result) == "factor") {
    result = as.character(result)
  }
  result.csv <- cbind(Id, result)
  colnames(result.csv) <- c("Id", "SpamLabel")
  write.csv(result.csv, file = file.name, row.names = FALSE)
}

train.bag <- data.frame(row.names = 1:4000)
test.bag <- data.frame(row.names = 1:500)

library(caret)
index <- createDataPartition(y.label[, 1], p = 0.9, list = F)
partition.train <- train[index, ]
partition.test <- train[-index, ]

