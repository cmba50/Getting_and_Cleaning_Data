# Getting and Cleaning Data Project

#Scope
#The project creats a script that collects, tranforms and exports a raw data set containing signal measurements for human movement activities recorded with a mobile device

#Usage
#The included script file should be run as is directly in the working directory using R 

#Raw Data Sets
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Data Processing
#The steps used to create the final tidy data set are presented below
#1.Downloads raw data directly from the source
#2.Merges traing and test raw data sets, which contain no descriptive column names
#3.Extracts only the measurements on the mean and standard deviation for each measurement 
#4.Uses descriptive activity names to name the activities in the data set using the information files from raw data package
#5.Appropriately labels the data set with descriptive variable names
#6.creates the final tidy data set with the average of each variable for each activity and each subject
#7.Export the data set to a txt file

#SCript Documentation
#The script file contains more detailed descriptions regarding the multiple sub-steps used to generate the final 
#txt file 