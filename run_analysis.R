## This script will merge the training and test components (data, labels, subjects, etc.) 
## of the UCI HAR Dataset into one complete tidy dataset, then creates a 2nd independent
## dataset containing mean and std variables with some additional summary calculations.
## For complete details, please see the CodeBook.md and ReadME.md files
## at https://github.com/Blockish/GetData_CourseProject

## Require packages that will be used to merge and transform the datasets
require("dplyr")

## Read in Data files for project
        ## Start with Activity labels and Features 
        act <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
        feat <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
        
        ## Read in the datasets (feature and subject labels and observation values)
        ## Test set
        subjID_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
        y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
        X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
        
        ## Training set
        subjID_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
        y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
        X_train <- read.table("./UCI HAR Dataset/train//X_train.txt", stringsAsFactors = FALSE)
        
## join the test and training sets together in stages so that rows x columns match up
## First, subject (test first, train below) 
subjID <- rbind.data.frame(subjID_test, subjID_train)

## Give subId column a convenient name
colnames(subjID) <- "subjID"

## Second, y (_test first, _train below to be consistent with subject above)
actID <- rbind.data.frame(y_test, y_train)

## Give actID column a convenient name for activity ID
colnames(actID) <- "actID"

## Third, X (_test first, _train below for consistency with above)
Xdata <- rbind.data.frame(X_test, X_train)

## Fourth, use the feature names from feat$V2 dataframe to name the Xdata variables (colunmns)
colnames(Xdata) <- feat$V2

## Fifth, join the subjectID, activityID, XData together into 1 dataframe. 
merged <- cbind.data.frame(subjID, actID, Xdata)

## Sixth, convert the actID to a factor variable and add the Activity names from act$V2
merged$actID <- factor(merged$actID, labels = act$V2)

## Convert subID to a factor variable for use later
merged$subjID <- factor(merged$subjID)

## find the columns containing mean() or std() type values, ignoring angle*Mean values
g_mean <- grep("mean.*\\(", colnames(merged), ignore.case=TRUE, value=TRUE)
g_std <- grep("std.*\\(", colnames(merged), ignore.case=TRUE, value=TRUE)

## Combine to get list of columns to extract for final dataset.  
## Note:  subID and actID must also be included, since they are needed in the final dataset
colToExtract <- c("subjID", "actID", g_mean, g_std)

## extract the desired columns to another data.frame
filtered <- merged[,colToExtract]

## rename actID to "activity_name" to be more descriptive; also update subjID to "subjectID"
colnames(filtered)[2] <- "activity_name"
colnames(filtered)[1] <- "subjectID"

## use ddply to average each column by each subject and activity name
tidy_final <- ddply(filtered, .(subjectID, activity_name), numcolwise(mean))

## write-out the final tidy data file (NOTE: must read in with header=TRUE, .txt and sep=" " to get correct table)
write.table(tidy_final, file="tfinal.txt", row.name=FALSE)