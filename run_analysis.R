pathToData <- file.path('..', 'UCI HAR Dataset')
featuresFile <- file.path(pathToData, 'features.txt')
activitiesFile <- file.path(pathToData, 'activity_labels.txt')
trainFile <- file.path(pathToData, 'train', 'X_train.txt')
trainActivitiesFile <- file.path(pathToData, 'train', 'y_train.txt')
trainSubjectsFile <- file.path(pathToData, 'train', 'subject_train.txt')
testFile <- file.path(pathToData, 'test', 'X_test.txt')
testActivitiesFile <- file.path(pathToData, 'test', 'y_test.txt')
testSubjectsFile <- file.path(pathToData, 'test', 'subject_test.txt')

#Reading labeling data
features   <- read.table(featuresFile, col.names=c('featureId', 'featureName'))
activities <- read.table(activitiesFile, col.names=c('activityId', 'activityLabel'))
featureNames   <- features[,c('featureName')]
activityLabels <- activities[,c('activityLabel')]

#Reading train and test data
train <- read.table(trainFile, col.names=featureNames)
test  <- read.table(testFile,  col.names=featureNames)

#Reading activity data
trainActivities <- read.table(trainActivitiesFile, col.names=c('activityId'))
testActivities  <- read.table(testActivitiesFile,  col.names=c('activityId'))

#Reading subject data
testSubjects  <- read.table(testSubjectsFile,  col.names=c('subjectId'))
trainSubjects <- read.table(trainSubjectsFile, col.names=c('subjectId'))

#Extracting only the measurements on the mean and standard deviation for each measurement
train <- train[, c(grep('mean', names(train)), grep('std', names(train)))]
test  <- test[, c(grep('mean',  names(test)),  grep('std', names(test)))]

#Using descriptive activity names to name the activities in the data set, binding to the train and test datasets
train <- merge(activities, cbind(train, trainActivities), by='activityId')
test  <- merge(activities, cbind(test, testActivities),   by='activityId')

#Creating final tidy set for activity data per subject
test  <- data.frame(type='test', testSubjects, test)
train <- data.frame(type='train', trainSubjects, train)
names(test)  <- gsub('\\.\\.\\.', '().', names(test))
names(train) <- gsub('\\.\\.\\.', '().', names(train))

activitiesPerSubject <- rbind(train, test)
write.table(activitiesPerSubject, file='activity_data_per_subject.txt', col.names=FALSE)
