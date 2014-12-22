 #README.MD
 
 

This is a script design to clean and strucuture data, as required in a the "Getting and cleaning data course" on the Data science track of Coursera. 

The data have been collected the context of a study of wearable computings. 
The source of data is a data set gathered during an experiment that measured physical variation detected by the 3d sensors of a mobile phone.

This study has been performed on a group of 30 people, of whom 70% are in a train group while the 30% others are in a test group.

Each of the person taking part to the experiment have been recorded during six different activities:
WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING

The devices can measure a total of 561 different physical measures of time and frequencies over the three dimension (acceleration, rotation, etc...)  

The whole of the data have been provided over several text files:
 
X_train.txt:
This file contains all the 561 measurement for each activity of all the train group participants. Each line is a set of measurement of a person doing an activity.

Y_train.txt:
This file matches the sets of measurement of the X_train.txt.file and provide the corresponding activity code of the measurement.

subject_train.txt
This file matches the sets of measurement of the X_train.txt.file and provide the corresponding person (in the train group) of the measurement.

X_test.txt:
Same as the X_train.txt file, only for the test group

Y_test.txt:
Same as the X_train.txt file, only for the test group

subject_test.txt
Same as the subject_train.txt file, only for the test group

features.txt
This file matches the sets of measurement of both the X_train.txt and X_test.txt. It provides the relevannt type of measure made for each of the 561 measures found on each of the lines in these files

activity_labels.txt
This files describes the name of the physical activity associated with the number in the Y files

This script process these data in order to tidy them according the principles provided during the classe. Further, the data are to be downsized
in order to only show required dimension, as explained later




The script will use the Hmisc and reshape2 library

`library(Hmisc)
`library(reshape2)



5 steps are to be performed by this script:



#First activity: Merges the training and the test sets to create one data set.


setwd("D:/Cédric/Repositery/R-repo/GCD/courseProject")  Replace with relevant path to define the location of the files

Load all the text files as data frames - I respect the folder structure of the zip file

`xtrain <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
`ytrain <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
`sbtrain <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

`xtest <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
`ytest <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
`sbtest <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

`features <- read.csv("UCI HAR Dataset/features.txt", sep="", header= FALSE)
`activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header= FALSE)


To merge the data, it is necessary to first define each measurement on both xtrain and ytrain with relevant person and activity
by adding the person and activity columns

`main_table_train <- cbind(sbtrain, ytrain, xtrain)
`main_table_test <- cbind(sbtest, ytest, xtest)

Then train and test rows can be merged
`main_table <- rbind(main_table_train, main_table_test)


#Second activity: Extracts only the measurements on the mean and standard deviation for each measurement.
 Warning: The first line is actually the fourth activity, as it made more sense to me to first add the descriptive columns name


Firstly, The features names are extracted and appended with labels for the subject and activity columns, added during the first activity.
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header= FALSE)
`var_names <- c("subject", "activity", as.vector(features[,2]))
`colnames(main_table) <- var_names 

Then, I filter the mean and standard deviation features out, that are noticeable with the -mean and -stp suffixes
`mean_var_name <- var_names[grep("-mean", var_names)]
`std_var_name <- var_names[grep("-std", var_names)]
`restricted_var_name <- c(mean_var_name, std_var_name) 

`restricted_table <- main_table[,c("subject","activity", restricted_var_name)] Finally, the mean and standard deviation are subsetted



#Third activity: Uses descriptive activity names to name the activities in the data set



First, the activity labels are loaded in a data frame, then used as factor in the subsetted data
`activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header= FALSE)
`restricted_table$activity <- factor(restricted_table$activity, label=activities$V2)



#Fourth activity: Appropriately labels the data set with descriptive variable names. 
 Done in Second activity



#Fifth activity: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



First the variables used in the subsetted data are to be melted in order to highlight the features as the variable to measure
In that way, features are not several variables any more, but a unique, factor-like one with one value associated.
Consequently, each measure is on one row.

`rt_melt <- melt(restricted_table, id=c("subject","activity"), measure.var=restricted_var_name)

Then, the aggregate command apply the mean function to calculate the mean value of all the row with the same feature. 
`raw_result <- aggregate(rt_melt$value,by=list(rt_melt$subject, rt_melt$activity, rt_melt$variable), FUN=mean)

Finally, relevant labels can be added for better presentation. The order of the data frame can be tweaked too.
`colnames(raw_result) <- c("subject", "activity", "feature", "average value")
`result <- raw_result[order(raw_result$subject,raw_result$activity),]


