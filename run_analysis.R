##Description of the scripts
##This scripts calculates and exports the average of various feature variables 
##collected from a wearable (mobile) device application.
##The application tracks and records fitness measurements
##Five sequential steps are required to perform the calculations, including gettign and cleaning data 
library(data.table)

##Download and unzip the source data
fileToDownload <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileToDownload, destfile = "simdata.zip")
unzip("simdata.zip")

##Load training dataset
## use a list with the datasets from /train subfolder
trainFiles <- list.files(path = "./UCI HAR Dataset/train", pattern = ".txt")
wdir <- getwd()
tempPath <- paste(c(wdir,"/UCI HAR Dataset/train"), collapse="")
setwd(tempPath)
trainSets <- lapply(trainFiles, fread)
trainData <- cbind.data.frame(trainSets)
setwd(wdir)

##Load test dataset
## use a list with the datasets from /test subfolder
testFiles <- list.files(path = "./UCI HAR Dataset/test", pattern = ".txt")
tempPath <- paste(c(wdir,"/UCI HAR Dataset/test"), collapse="")
setwd(tempPath)
testSets <- lapply(testFiles, fread)
testData <- cbind.data.frame(testSets)
setwd(wdir)

##1.Merge training and test datasets
alldata <- rbind(trainData, testData)

##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##The approach requires to extract the variables without using column names
##Get the feature variables corresponding to meand and std
featureVar <- fread("./UCI HAR Dataset/features.txt")
subsetMean <- featureVar[like(V2, "mean")]
subsetStd <- featureVar[like(V2, "std")]
## Extract the indices for the mean and std variables, 
## together with activity_ID and test objects to determine the overall subset
selMeanStdIndx <- c(subsetMean[, V1], subsetStd[, V1])
##Add 1 to extracted mean, std feature variable indices 
##to account for the order in which data was read in
selIndx <- c(1,length(alldata), selMeanStdIndx + 1)
reqSubset <- alldata[, selIndx]

##3.Uses descriptive activity names to name the activities in the data set
library(plyr)
setnames(reqSubset,2,"activity")
reqSubset$activity <- as.factor(reqSubset$activity)
reqSubset$activity <- revalue(reqSubset$activity, 
                                  c("1" = "Walking", "2" = "walking_upstairs", 
                                    "3" = "walking_downstairs", "4" = "sitting", 
                                    "5" = "standing", "6" = "laying"))

##4.Appropriately labels the data set with descriptive variable names
##Use the vector already created with names from feature_info file
selMeanStdNames <- as.character(c(subsetMean[, V2], subsetStd[, V2]))
setnames(reqSubset, c("subject_ID", "activity", selMeanStdNames))

##5.From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
reqSubset <- as.data.table(reqSubset)
finalSet <- reqSubset[, lapply(.SD, mean), by=c("subject_ID", "activity"), .SDcols=selMeanStdNames]
write.table(finalSet, file = "tidyData_CA.txt", row.names = FALSE)

