# Load dplyr
library(dplyr)
library(data.table)
# First we create a directory for our dataset
if(!file.exists("./dataset")){dir.create("./dataset")}
# Now we download the file for the dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./dataset/sourcedata.zip")
# Next we unzip the downloaded dataset within the same directory of the download
unzip(zipfile = "./dataset/sourcedata.zip",exdir = "./dataset")
# Up next we assign all of the data frames we need
activity_labels <- read.table("./dataset/UCI HAR Dataset/activity_labels.txt", header = FALSE) 
feature_names <- read.table("./dataset/UCI HAR Dataset/features.txt") 
subject_test <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")
features_test <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")
activity_test <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./dataset/UCI HAR Dataset/train/subject_train.txt")
features_train <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt")
activity_train <- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")
# Then we merge the training and test datasets to create one set

features_merged <- rbind(features_test, features_train)
activity_merged <- rbind(activity_test, activity_train)
subject_merged <- rbind(subject_test, subject_train)

colnames(features_merged) <- t(feature_names[2])

colnames(activity_merged) <- "Activity"
colnames(subject_merged) <- "Subject"
merged_dataset <- cbind(features_merged,activity_merged,subject_merged)

# Here we extract only the measurements on the mean and std dev for each measurement
mean_std_dev_names <- grep(".*Mean.*|.*Std.*", names(merged_dataset), ignore.case=TRUE)
selected_feature_names <- c(mean_std_dev_names, 562, 563)
mean_std_dev <- merged_dataset[,selected_feature_names]

# Adding descriptive activity names
names(mean_std_dev)<-gsub("Acc", "Accelerometer", names(mean_std_dev))
names(mean_std_dev)<-gsub("Gyro", "Gyroscope", names(mean_std_dev))
names(mean_std_dev)<-gsub("BodyBody", "Body", names(mean_std_dev))
names(mean_std_dev)<-gsub("Mag", "Magnitude", names(mean_std_dev))
names(mean_std_dev)<-gsub("^t", "Time", names(mean_std_dev))
names(mean_std_dev)<-gsub("^f", "Frequency", names(mean_std_dev))
names(mean_std_dev)<-gsub("tBody", "TimeBody", names(mean_std_dev))
names(mean_std_dev)<-gsub("-mean()", "Mean", names(mean_std_dev), ignore.case = TRUE)
names(mean_std_dev)<-gsub("-std()", "STD", names(mean_std_dev), ignore.case = TRUE)
names(mean_std_dev)<-gsub("-freq()", "Frequency", names(mean_std_dev), ignore.case = TRUE)
names(mean_std_dev)<-gsub("angle", "Angle", names(mean_std_dev))
names(mean_std_dev)<-gsub("gravity", "Gravity", names(mean_std_dev))


# Create another dataset with the average of each variable
mean_std_dev$Subject <- as.factor(mean_std_dev$Subject)
mean_std_dev <- data.table(mean_std_dev)

tidyData <- aggregate(. ~Subject + Activity, mean_std_dev, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "TidyData.txt", row.name = FALSE)
