#Reading labeling data
features   <- read.table('UCI HAR Dataset/features.txt', col.names=c('featureId', 'featureName'))
activities <- read.table('UCI HAR Dataset/activity_labels.txt', col.names=c('activityId', 'activityLabel'))
featureNames   <- features[,c('featureName')]
activityLabels <- activities[,c('activityLabel')]

#Reading train and test data
train <- read.table('UCI HAR Dataset/train/X_train.txt', col.names=featureNames)
test  <- read.table('UCI HAR Dataset/test/X_test.txt', col.names=featureNames)

#Reading activity data
trainActivities <- read.table('UCI HAR Dataset/train/y_train.txt', col.names=c('activityId'))
testActivities  <- read.table('UCI HAR Dataset/test/y_test.txt', col.names=c('activityId'))

#Reading subject data
testSubjects  <- read.table('UCI HAR Dataset/test/subject_test.txt', col.names=c('subjectId'))
trainSubjects <- read.table('UCI HAR Dataset/train/subject_train.txt', col.names=c('subjectId'))

#Extracting only the measurements on the mean and standard deviation for each measurement
train <- train[, c(grep('mean', names(train)), grep('std', names(train)))]
test  <- test[, c(grep('mean', names(test)), grep('std', names(test)))]

#Using descriptive activity names to name the activities in the data set, binding to the train and test datasets
train <- merge(activities, cbind(train, trainActivities), by='activityId')
test  <- merge(activities, cbind(test, testActivities), by='activityId')

#Creating final tidy set for activity data per subject
test <- data.frame(type='test', testSubjects, test)
train <- data.frame(type='train', trainSubjects, train)

activitiesPerSubject <- rbind(train, test)
write.table(activitiesPerSubject, file='activity_data_per_subject.txt', col.names=FALSE)
