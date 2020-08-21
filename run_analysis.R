
# Downloading data

filename <- "getdata.zip"
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method = "curl")
}  

# unzipping file

if (!file.exists("UCI HAR Dataset")) { unzip(filename, overwrite = TRUE) }

# loading libraries

library(dplyr)
library(lubridate)
library(NLP)
library(tm)

# reading all the files into R

features        <- read.table("UCI HAR Dataset/features.txt", col.names = c("featuresid","featurenames"))
activitylabels  <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityid","activitynames"))
xtest           <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$featurenames)
xtrain          <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$featurenames)
ytest           <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "yid")
ytrain          <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "yid")
subjecttrain    <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjectid")
subjecttest     <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subjectid")

# 1. Merge files

x <- rbind(xtrain,xtest)
y <- rbind(ytrain,ytest)
subject <- rbind(subjecttrain,subjecttest)
merged <- cbind(subject,x,y)

#remove punctuation

names(merged) <- removePunctuation(names(merged))
names(activitylabels) <- removePunctuation(names(activitylabels))

# 2. Find mean and standard deviation columns

mean_and_standard_deviation <- merged[,grepl("mean|std",names(merged))]

# 3. Replace activity code with names

merged <- merged %>% mutate(activity = factor(activitylabels$activitynames[merged$yid])) %>%
        select(-yid)

# 4. Fix names of data set
names(merged) <- gsub("Acc", "acceleration", names(merged))
names(merged) <- gsub("gyro", "gyroscope",names(merged))
names(merged) <- gsub("arCoeff", "autoregressioncoefficient",names(merged))
names(merged) <- gsub("iqr", "interquartilerange",names(merged))
names(merged) <- gsub("Freq", "frequeny",names(merged))
names(merged) <- gsub("Mag", "magnitude",names(merged))
names(merged) <- gsub("^t", "time",names(merged))
names(merged) <- gsub("^f", "frequency",names(merged))
names(merged) <- gsub("mad", "meanaveragedeviation",names(merged))
names(merged) <- gsub("min", "minimum",names(merged))
names(merged) <- gsub("max", "maximum",names(merged))
names(merged) <- gsub("maximumInds", "indexoffrequencywithlargestmagnitude",names(merged))
names(merged) <- gsub("std", "standarddeviation",names(merged))
names(merged) <- gsub("sma", "simplemovingaverage",names(merged))
names(merged) <- gsub("iqr", "interquartilerange",names(merged))
names(merged) <- gsub("BodyBody", "body",names(merged))


# 5. Create tidy data set of mean of all values grouped by subjectid and activity

groupedmeans <- merged %>% group_by(activity,subjectid) %>% summarize_all(funs(mean))
write.table(groupedmeans, file = "groupedmeansfinaldataset.txt")  
