## GetData_CourseProject - CookBook.md  
## =====================  


This file contains a list of variable names and descriptions used in the Getting and Cleaning Data Course Project and a synopsis of the methods used in the analysis.

## Data Sources  
Original Source of Data (and information about variables): http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  

Dataset on Coursera:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Features_info.txt 
### Understanding the original dataset  

(Abbreviated description from the features_info.txt included in the UCI HAR Dataset. 
**See features_info.txt for more details.**)    

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

## Structure of original data files    
### (necessary to understand how the files will be merged)

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
- tmp : temporary variable to hold column names
- tmp2 : temporary variable to hold column names
- tidy_final : a dataframe containing the final results of the analysis

## Process and Analysis performed by run_analysis.R  

### Synopsis: 
The script will merge the training and test components (data, labels, subjects, etc.) of the UCI HAR Dataset into one complete dataset.  It will then filter the data into a 2nd dataset containing only columns related to mean and std variables from the original dataset.  Finally, it will summarize the filtered set by calculating the mean values for each student for each activity and store the results in a final, tidy dataset (tidy_final), along with "friendly" names for all of the columns.  These final results (tidy_final) are then written to a text file.

### Process:
1.  load required packages, plyr
2.  use read.table to read in Data files for project, activity labels, features, subject ID's and observation data from the test and training sets.  Note: Use "stingsAsFactors=FALSE" to avoid all the variables from being stored as factors.  Also, note there are no headers in these data files (header = FALSE)
3. using the structure of the original data files (See discussion of this above, along with a link to a great diagram from David Hood showing a visual version, join them together.
   a. First, rbind.data.frame the subjID's from test and training (in that order)  
   b. Second, y values using rbind.data.frame from test and training (in that order to ensure dimensions will match from above.)
   c. Third, do the same for the X, test and training (in that order)
   d. Fourth, attach the feature names to columns for data set... (Note, this must be done here to match the dimensions of the features with the observed data...)
   e. Fifth, join the subjectID, activityID, and labeled XData together into 1 dataframe using cbind.data.frame
4. convert the actID to a factor variable and add the Activity "friendly name" labels.
5. convert subID to a factor variable for later use
6. grep the columns for ones related to mean or std...  

**Note, on this one, I explicity excluded columns for angle*Mean values, since they did not appear to be the same type of mean calculation.**  

7. extract the columns from above from the original dataset and include the subject ID's and activity ID's columns, into a new dataframe.  
8. Add friendly names
9. calculate the mean for each subject for each activity using ddply and numcolwise(mean) functions (grouping data by subjectID and activity_name) and put the results into the final dataframe, tidy_final.
10. prepend the feature columns with an "m" to indicate that they contain averaged data.
11. write-out the data to a file using write.table with row.name=FALSE.

**Note, the tfinal.txt must read in with header=TRUE, .txt and sep=" " to get correct table back with the friendly headers** 