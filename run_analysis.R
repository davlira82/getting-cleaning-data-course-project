library(dplyr)

setwd("C:/Users/Ricardo/Desktop/Getting and Cleaning Data/Course Project/UCI HAR Dataset")

# Create one R script called run_analysis.R that does the following.

# Step 1: Merges the training and the test sets to create one data set.

Xtrain = read.table("train/X_train.txt")
Xtest = read.table("test/X_test.txt")

Ytrain = read.table("train/y_train.txt")
Ytest = read.table("test/y_test.txt")

subjectTrain = read.table("train/subject_train.txt")
subjectTest = read.table("test/subject_test.txt")

# Merge for X dataset
mergeX = rbind(Xtrain, Xtest)

# Merge for Y dataset
mergeY = rbind(Ytrain, Ytest)

# Merge for Subject dataset
mergeSubject = rbind(subjectTrain, subjectTest)


# Step 2: Extract only the measurements on the mean and standard deviation for each measurement

# Importing Activity labels
activities = read.table('./activity_labels.txt',header=FALSE)

# Importing features
features = read.table('./features.txt',header=FALSE)

features.names = grep("-(mean|std)\\(\\)", features[,2])

# Step 3: Use descriptive activity names to name the activities in the data set


avgstd.names = features[features.names,2]
avgstd.names = gsub('-mean', 'Mean', avgstd.names)
avgstd.names = gsub('-std', 'Std', avgstd.names)
avgstd.names = gsub('[-()]', '', avgstd.names)


# Columns measuring mean and standard deviation for each feature
mergeX = mergeX[, features.names]

# Changing names of columns
colnames(mergeX) = avgstd.names
  
  
# Correct activity names
mergeY[, 1] = activities[mergeY[, 1], 2]
  
  
# Step 4: Appropriately label the data set with descriptive variable names
  
# Column name of subject
names(mergeSubject) <- "Subject"

# Column name of activities 
names(mergeY) <- "Activity"
  

# Step 5
# Create a second, independent tidy data set with the average of each variable for each activity and each subject
  
# Merging all data sets
mergeAll <- cbind(mergeX, mergeY, mergeSubject)

results = mergeAll %>%
    group_by(Activity, Subject) %>%
    summarise_each(funs(mean))
  
  
#Writing final tidy data set
  
  write.table(results, "tidyData.txt", row.name=FALSE)
  