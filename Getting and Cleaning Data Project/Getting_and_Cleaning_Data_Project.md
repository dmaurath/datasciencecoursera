# Cleaning Movement Tracking Data
Daniel Maurath  
June, 2014  
####About
This was a project for the **Getting and Cleaning Data** course in Coursera's Data Science specialization track. The purpose of the project was to practice cleaning and merging multiple data sets into a single tidy data set.

##Synopsis
This file will result in a tidy version of the "Human Activity Recognition Using Smartphones Dataset" supplied for the assignment. 

##R Session Info and Libraries


```r
library(plyr) ##need for join()
library(reshape2) ##need for melt() and dcast()
sessionInfo()
```

```
## R version 3.0.3 (2014-03-06)
## Platform: x86_64-apple-darwin10.8.0 (64-bit)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] reshape2_1.4 plyr_1.8.1  
## 
## loaded via a namespace (and not attached):
##  [1] digest_0.6.4     evaluate_0.5.5   formatR_0.10     htmltools_0.2.4 
##  [5] knitr_1.6        Rcpp_0.11.1      rmarkdown_0.2.54 stringr_0.6.2   
##  [9] tools_3.0.3      yaml_2.1.11
```

##Download Data

Data for this project was provided on the course website and can be downloaded from the following link:
[Data](http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

After the data has been downloaded, place following files into working directory. They will be used to build a cohesive tidy data set:
1. activity_labels.txt 
2. features.txt 
3. subject_test.txt 
4. subject_train.txt 
5. X_test.txt 
6. X_train.txt 
7. y_test.txt 
8. y_train.txt

##Construct Tidy Data Set 
This assignment required a single function, so I have commented the code of the single function instead of breaking the analyses down into a series of annotated steps. In summary, the function:
* reads in and combines `test` and `training` data for subjects
* reads in and combines `test` and `training` data for features
* subsets data for only the features that are a measurement of mean or standard deviation
* reads in activity labels resulting in a data set of combines subject,features and activity data
* melts and reshapes data
* outputs to ordered tidy data set

With all the data files in your working directory, run the `run_analysis` function to construct the tidy data set. 


```r
run_analysis<-function(){
        #Read in subject IDs for train and test set
        subject_test <- read.table("subject_test.txt", col.names=c("Subject"))
        subject_train <- read.table("subject_train.txt", col.names=c("Subject"))
        #Combine train and test sets into single data frame
        subject_all <- rbind(subject_train, subject_test)
        
        #Read in features data for train and test. Note: this is the data for each feature, not the feature labels.
        features_test <- read.table("X_test.txt")
        features_train <- read.table("X_train.txt")
        #Combine training and test data for features into single data frame
        features_data <- rbind(features_test, features_train)
        
        #Read in list of features. Note: this is a list of the features names or labels. Not the features data
        feature_list <- read.table("features.txt", col.names=c("index", "feature_labels"))
        #Create 1 dimensional character vector containing feature labels from features_list data frame
        feature_labels <- feature_list$feature_labels
        ##Create logical vector indicating columns which have mean() and std() in their name
        features_subset <- grepl('mean\\(\\)|std\\(\\)',feature_labels)
        #Create a character vector of only features with mean and standard deviation in their name
        feature_list <- as.character(feature_labels[features_subset])
        
        #Rename columns in features_data before subsetting out the mean and standard deviation columns, so that names match up still 
        colnames(features_data) <- feature_labels
        ## Extract only mean() and std() columns from features_data using the logical vector "features_subset"
        features_data <- features_data[,features_subset]
        
        #Read in activities for train and test
        activities_test <- read.table("Y_test.txt")
        activities_train <- read.table("Y_train.txt")
        #Combine training and test activities into single data frame and rename column to "activity" from "V1"
        activities_all <- rbind(activities_test, activities_train)
        colnames(activities_all) <- "activityLabel"
        ## Recode activity values as descriptive names using the activity labels file 
        activity_labels<-read.table("activity_labels.txt",sep=" ",col.names=c("activityLabel","Activity"))
        activities_all<-join(activities_all,activity_labels,by="activityLabel",type="left")
        #Drop activity numbers
        activities_all$activityLabel <- NULL
        
        #Combine Actitivies, Subjects and Features all into one data frame
        all_df <- cbind(features_data, activities_all, subject_all)
        
        #Melt data frame for reshaping
        tdf <- melt(all_df, id=c("Subject", "Activity"), measure.vars=feature_list)
        
        #Reshape into tidy data frame by mean using the reshape2 package
        tdf <- dcast(tdf, Activity + Subject ~ variable, mean)
        
        #Reorder by Subject then Activity
        tdf <- tdf[order(tdf$Subject, tdf$Activity),]
        
        #Reindex Rows and move Subject to Column 1
        rownames(tdf) <- 1:nrow(tdf)
        tdf <- tdf[,c(2,1,3:68)]
        
        #Output file
        write.table(tdf,file="tidy_dataset.txt") 
}
```
