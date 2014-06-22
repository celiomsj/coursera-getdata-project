#
# Coursera
# Getting and Cleaning Data
#
# Course Project
#

# Download UCI HAR Dataset
if(!file.exists("getdata-projectfiles-Dataset.zip")) {
  download.file(
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    destfile = "getdata-projectfiles-Dataset.zip",
    method = "auto")
}

# Extracts downloaded dataset
if(!file.exists("UCI HAR Dataset")) {
  unzip("getdata-projectfiles-Dataset.zip")
}

# Feature labels
features <- read.table("UCI HAR Dataset/features.txt", header=F)
# Activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header=F)

# Test subjects data
sub.test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
ts.test <- read.table("UCI HAR Dataset/test/X_test.txt", header=F)
ts.act.test <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)
# Combines test subjects data in a single data.frame
df.test <- data.frame(sub.test, ts.act.test, ts.test)

# Train subjects data
sub.train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
ts.train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F)
ts.act.train <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)
# Combines train subjects data in a single data.frame
df.train <- data.frame(sub.train, ts.act.train, ts.train)

# Merges test and train subjects data
df <- rbind(df.test, df.train)
# Rename columns with corresponding feature labels
names(df) <- c("subject", "activity", make.names(features[,2]))
# Extracts only mean and std measurements
df <- subset(df, select=c(1,2, (grep("mean\\(\\)|std\\(\\)", features[,2])+2)))
# Labels activities acordingly
df$activity <- factor(df$activity, labels=activities[,2])

# Outputs the data to a file
write.table(df, file="tidy-data.txt", sep=",", row.names=F)

# Calculates the average of each measurement by subject and activity
tidy.df <- aggregate(. ~ subject + activity, data=df, FUN=mean)
