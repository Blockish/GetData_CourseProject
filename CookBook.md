# GetData_CourseProject - CookBook.md
# =====================


This file contains a list of variable names and descriptions used in the Getting and Cleaning Data Course Project and a synopsis of the methods used in the analysis.

## Sources
Original Source of Data (and information about variables): http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

Dataset on Coursera:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Features_info.txt (what are the feature variables)
(Abbreviated description from the features_info.txt included in the UCI HAR Dataset. **See features_info.txt for more details.**)  

Feature names are of the form shown below, prepended with "t" for time domain, and "f" for FFT transformed version.  (Only a small sample of the feature names are shown here as examples.)  

tBodyAcc-X  
tGravityAcc-Y  
tBodyAccJerk-Z  
...  
fBodyAcc-X  
fBodyAccJerk-Y  
fBodyGyro-Z  
...  

In addition, all features have triaxial measurements (with -X, -Y, & -Z appended to the end of the name).  Additionally, several types of descriptive statistics are included as features, with the namne of the stats function appended to the end of the name.  The two of interest here are 

-mean*(): Mean value
-std(): Standard deviation
...

The full list of feature names are included in features.txt.  There are 561 features total.



## Structure of original data files (necessary to understand how the files will be merged)

activity_labels.txt -- [6 x 2] dataframe containing the "friendly names" of the activities recorded and the ID number    
features.txt -- [561 x 2] dataframe containing the list of features and a sequential ID # for each    
features_info.txt -- information about the feature names given  (see Features.txt info below for more details.    
subject_test.txt -- [2947 x 1] subject ID's for the observations in the test subset of the data   
/test/X_test.txt -- [2947 x 561]  observed values for the test subset of the data for each feature.    
/test/y_test.txt -- [2947 x 1] activity ID for each of the observations in the test subset of the data.  
/train/subject_train.txt -- [7352 x 1] subject ID's for the observations in the training subset of the data.    
/train/X_train.txt -- [7352 x 561] observed valuesw for the training subset of the data.      
/train/y_train.txt -- [7352 x 1] activity ID for each of the observations in the subset of the training data.  

See chart provided by David Hood in thread  https://class.coursera.org/getdata-007/forum/thread?thread_id=49 for a good visual representation of how these files fit together into 1 complete set.

### Variable list (in run_analysis.R script)
- act : the activity_labels data
- feat : the features data
- subjID_test : the subject ID's for the observations in the test subset
- y_test : the activity ID's for the observations in the test subset
- X_test : the observation values for each feature in the test subset
- subjID_train : the subject ID's for the observations in the training subset
- y_train : the activity ID's for the observations in the training subset
- X_train : the observation values for each feature in the training subset
- subjID : the combined set (test + train) of subject ID's for the observations
- actID : the combined set (test + train) of the activity ID's for the observations
- Xdata : the combined set (test + train) of the observed values for each of the features
- merged : the combined data set (subject IDs, activity IDs, and Xdata)
- g_mean : results of grep'ing for "mean"- related columns
- g_std : results of grep'ing for "std" - related columns
- colToExtract : the list of columns to extract from the original dataset (containing "mean" or "std")
- filtered : a dataframe containing the columns extracted from the original dataset
- tidy_final : a dataframe containing the final results of the analysis

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