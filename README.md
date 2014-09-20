## GetData_CourseProject
## =====================

# Desciption or required files and environment for Final course project files for Getting and Cleaning Data (Coursera)

## Files List

# run_analysis.R
main script to read in the UCI HAR Dataset, merge the various components, filter the data to specific columns required by the assignment.  After calculating the means for each column by subject and by activity, the script writes the new tidy dataset with the column means to a separate text file in the R working directory called "tfinal.txt".

# README.md
This file, which contains information about the files created in this project and the environment requirements to utilize them.

# CodeBook.md
This file contains a description of the variable names used in the run_analysis.R file, along with a desription of the analysis steps and methods completed to merge the data and create the final output required for the project.

# Notes about the run_analysis.R script and CodeBook.md

To use the run_analysis.R script, it should be in the current R working directory.  The zip file provided for this project (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) should be unzipped to the R working directory.  This will create a UCI HAR Dataset folder in the working directory which contains the required files and subfolder structure.  The run_analysis.R file can be executed by opening the file in R Studio (verified working with version 3.1.1 on Windows 8.1), and using "Source" to execute the script.  The script will take a minute or two to run, after which, the file, "tfinal.txt" will appear in the R working directory.  

To open the tfinal.txt file, you can use the command below from the R console:

     read.table("tfinal.txt", header=TRUE, stringsAsFactors=FALSE, sep = " ")

NOTE:  The run_analysis.R script requires use of the dplyr package, which it will attempt to load during execution and will report an error if it cannot find and load the package.  It can also be installed by install.packages("dplyr")

Original data provided at:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
