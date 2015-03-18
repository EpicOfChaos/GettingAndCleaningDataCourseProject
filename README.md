# GettingAndCleaningDataCourseProject
=====================================
Pre-req
* In order to run this script you need to have the dplyr and reshape2 libraries installed.
* Copy the run_analysis.R script to your working directory.
=====================================
How to run the script
* To run the script all you need to do is source the script, place the script in your working directory and run the following command. "source("run_analysis.R")"
=====================================
The Process
1. If "getdata-projectfiles-UCI HAR Dataset.zip" is NOT in the working directory it will download the zip data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. If the zip has been extracted, it deletes the currently extracted data so that it can unzip a fresh copy of the data.
3. Next it will begin to merge the data sets together. 
	1. Merge the y_test.txt file with the subject_test.txt
	2. Calculate the mean of the x_test.txt data by row and merge the means into our combined dataset.	
	3. Calculate the standard deviation of the x_test.txt data by row and merge the sd into our combined dataset.
4. Does the same thing for the train datasets and combine the two datasets together to for a single dataset that contains Subject, Activity, Mean and SD.
5. Rename the variables to their appropriate names, Subject, Activity, MeanTriaxialVelocity and StandardDeviationTriaxialVelocity 	
5. Rename the activity values 1 - 6 to their appropriate values "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
6. Summarize the data by subject, and activity by taking the mean of MeanTriaxialVelocity and the mean of StandardDeviationTriaxialVelocity
7. Write the summarized data to SummarizedTriaxialVelocity.txt