## GetData_CourseProject - README.md
## =====================

Desciption of environment and required files and supplemental information for Final course projectin Getting and Cleaning Data (Coursera)

## Files List

### run_analysis.R
This is the main script to read in the UCI HAR Dataset, merge the training and test set components (subject, activities and data) and filter the data to specific mean() & std() columns required by the assignment.  After calculating the means for each column for each subject for each activity, the script writes the new tidy dataset with the column means to a separate text file in the R working directory called "tfinal.txt".

### README.md
This file, which contains information about the files created in this project and the environment requirements to utilize them.

### CodeBook.md
This file contains a description of the variable names used in the run_analysis.R file, along with a desription of the analysis steps and methods completed to merge the data and calculations needed to create the final output table required for the project.

### tfinal.txt
This is the final output file generated by the run_analysis.R script in the R working directory.  It is a text file containing a tidy dataset showing information about subject, the activities, and mean calculation results for the mean() and std() columns calculated for each subject for each activity.

### Original Dataset files used in the analysis (Instructions for adding these to the R working directory are given in the Notes section below.)
1. activity_labels.txt - Listing of the names of the activities each subject completed (e.g., "Walking", "Sitting", etc.)
2. features.txt - Listing of the 561 feature names where information was recorded from the Smartphones
3. (info only) features_info.txt - Description of what the features mean (not used in the run_analysis.R script...) 
4. subject_test.txt - Subject ID for each of the rows of data in the test set
5. /test/X_test.txt - Values recorded for each of the feature variables for each activity and subject in the test set.
6. /test/y_test.txt - Activity ID for each of the observations recorded in the test set
7. /train/subject_train.txt - Subject ID for each of the rows of data in the training set
8. /train/X_train.txt - Values recorded for each of the feature variables for each activity and subject in the test set.
9. /train/y_train.txt - Activity ID for each of the observations recorded in the test set

### Notes about the run_analysis.R script and CodeBook.md

To use the run_analysis.R script, it should be in the current R working directory.  The zip file provided for this project on Coursera (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) should be unzipped to the R working directory.  This will create a UCI HAR Dataset subfolder in the working directory which contains the required files and subfolder structure (as shown below):  

./UCI HAR Dataset/activity_labels.txt  
./UCI HAR Dataset/features.txt  
./UCI HAR Dataset/features_info.txt  
./UCI HAR Dataset/test/subject_test.txt  
./UCI HAR Dataset/test/X_test.txt  
./UCI HAR Dataset/test/y_test.txt  
./UCI HAR Dataset/train/subject_train.txt  
./UCI HAR Dataset/train/X_train.txt  
./UCI HAR Dataset/train/y_train.txt  

The run_analysis.R file can be executed by opening the file in R Studio (verified working with version 3.1.1 on Windows 8.1), and using the "Source" button to execute the script.  Alternatively, type 'source("run_analysis.R")' (without the ' ') in the R console.  The script will take a minute or two to run, after which, the file, "tfinal.txt" will appear in the R working directory.  

To open the tfinal.txt file, you can use the command below from the R console (with R working directory set to the same location as run_analysis.R):

     read.table("./tfinal.txt", header=TRUE, stringsAsFactors=FALSE, sep = " ")

**NOTE:**  The run_analysis.R script requires use of the plyr package, which it will attempt to load during execution and will report an error if it cannot find and load the package.  It can also be installed by install.packages("plyr")

Source for original data used for the analysis and additional information about it:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
