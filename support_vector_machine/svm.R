# svm by 2blam

# set working directory
setwd("~/Documents/Git/ML/support_vector_machine")

# import dataset
dataset = read.csv("Social_Network_Ads.csv")
dataset = dataset[, 3:5]

# split into training and testing dataset
#install.packages("caTools") - first time installation
library(caTools) # for splitting dataset
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set = subset(dataset, split)
test_set = subset(dataset, !split)

# rescale feature values
training_set[, 1:2] = scale(training_set[, 1:2]) 
test_set[, 1:2] = scale(test_set[, 1:2])

# fit svm classifer
library(e1071)
classifier = svm(formula = Purchased ~ ., data = training_set, type="C-classification", kernel="linear")

# predict 
y_pred = predict(classifier, type='response', newdata=test_set[-3]) #probability

# confusion matrix
cm = table(test_set[, 3], y_pred)

# visualize training result
# install.packages("ElemStatLearn")
library(ElemStatLearn)
set = training_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = predict(classifier, type = 'response', newdata = grid_set)
plot(set[, -3],
     main = 'SVM (Training set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))

#visualize test set
set = test_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = predict(classifier, type = 'response', newdata = grid_set)
plot(set[, -3],
     main = 'SVM (Test set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))