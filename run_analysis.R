library(dplyr)
library(reshape2)

#Main method for executing the analysis process.
run <- function(){
    downloadDataIfNeeded()
    message("Merging and Summarizing data, please wait a moment.")
    data <- mergeTrainingAndTestData()
    data <- renameAndLabel(data)
    data <- summarizeData(data)
    writeTidyData(data)
}

#Downloads the file if the zip is not provided. Will unzip fresh data everytime.
downloadDataIfNeeded <- function(){
    if(!file.exists("./getdata-projectfiles-UCI HAR Dataset.zip")){
        message("getdata-projectfiles-UCI HAR Dataset.zip does not exist, downloading getdata-projectfiles-UCI HAR Dataset.zip")
        dataUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dataUrl, destfile="./getdata-projectfiles-UCI HAR Dataset.zip")
    }
    
    if(file.exists("./UCI HAR Dataset")){
        message("UCI HAR Dataset directory exists deleting to unzip a fresh copy.")
        unlink("./UCI HAR Dataset", recursive = TRUE, force = TRUE)
    }
    
    message("Unzipping getdata-projectfiles-UCI HAR Dataset.zip")
    unzip("./getdata-projectfiles-UCI HAR Dataset.zip")
    
}

#Merges the Test and Training data together
mergeTrainingAndTestData <- function(){
    testData <- mergeAndSummarizeData("test")
    trainData <- mergeAndSummarizeData("train")
    rbind(testData, trainData)
}

#Combines the Subject, Label and Angular Velocities together into a single dataset.
mergeAndSummarizeData <- function(identity){
    testX <- read.table(paste("./UCI HAR Dataset/",identity,"/","X_",identity,".txt", sep="")) #read.fwf("./data/UCI HAR Dataset/test/X_test.txt", widths=rep(17,528))
    testLabel <- read.csv(paste("./UCI HAR Dataset/",identity,"/","y_",identity,".txt", sep=""), header=FALSE, sep=" ")
    testSubject <- read.csv(paste("./UCI HAR Dataset/",identity,"/","subject_",identity,".txt", sep=""), header=FALSE)
    
    if(nrow(testSubject) != nrow(testLabel)
       || nrow(testSubject) != nrow(testX)){
        stop("File dimensions do not match!")
    }
    
    testMerged <- cbind(testSubject, testLabel)
    testMerged <- transform(testMerged, MeanTriaxialVelocity=apply(testX, 1, mean, na.rm=TRUE))
    testMerged <- transform(testMerged, StandardDeviationTriaxialVelocity=apply(testX, 1, sd, na.rm=TRUE))
    testMerged
}

#Renames variables and sets the Activity Labels
renameAndLabel <- function(data){
    data <- renameVariables(data)
    renameActivities(data)
}

#Renames the Variables
renameVariables <- function(data){
    data <- rename(data, Subject = V1, Activity = V1.1)
    data
}

#Renames the Activities Label
renameActivities <- function(data){
    data$Activity <-factor(data$Activity)
    levels(data$Activity) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
    data
}

#Creates the Mean of the means, and the Mean of the Standard Deviation by Subject and Activity
summarizeData <- function(data){
    data <- group_by(data, Subject, Activity)
    summarize(data, MeanTriaxialVelocity = mean(MeanTriaxialVelocity, na.rm = TRUE),
              MeanStandardDeviationTriaxialVelocity = mean(StandardDeviationTriaxialVelocity, na.rm = TRUE))
}

#Writes out the summarized data to a text file.
writeTidyData <- function(data){
    if(file.exists("SummarizedTriaxialVelocity.txt")){
        message("Summarized file already exists, deleting and recreating.")
        file.remove("SummarizedTriaxialVelocity.txt")
    }
    write.table(data, "SummarizedTriaxialVelocity.txt", row.names = FALSE)
    message("Created Summarized data: SummarizedTriaxialVelocity.txt")
}

run()