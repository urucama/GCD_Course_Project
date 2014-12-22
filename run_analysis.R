

library(Hmisc)
library(reshape2)



setwd("D:/Cédric/Repositery/R-repo/GCD/courseProject") 


xtrain <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
ytrain <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
sbtrain <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

xtest <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
ytest <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
sbtest <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

features <- read.csv("UCI HAR Dataset/features.txt", sep="", header= FALSE)
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header= FALSE)




main_table_train <- cbind(sbtrain, ytrain, xtrain)
main_table_test <- cbind(sbtest, ytest, xtest)

main_table <- rbind(main_table_train, main_table_test)





features <- read.csv("UCI HAR Dataset/features.txt", sep="", header= FALSE)
var_names <- c("subject", "activity", as.vector(features[,2]))
colnames(main_table) <- var_names 


mean_var_name <- var_names[grep("-mean", var_names)]
std_var_name <- var_names[grep("-std", var_names)]
restricted_var_name <- c(mean_var_name, std_var_name) 

restricted_table <- main_table[,c("subject","activity", restricted_var_name)] #Finally, the mean and standard deviation are subsetted



activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header= FALSE)
restricted_table$activity <- factor(restricted_table$activity, label=activities$V2)



rt_melt <- melt(restricted_table, id=c("subject","activity"), measure.var=restricted_var_name)


raw_result <- aggregate(rt_melt$value,by=list(rt_melt$subject, rt_melt$activity, rt_melt$variable), FUN=mean)


colnames(raw_result) <- c("subject", "activity", "feature", "average value")
result <- raw_result[order(raw_result$subject,raw_result$activity),]


