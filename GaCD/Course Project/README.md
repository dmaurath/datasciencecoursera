###TIDY Human Activity Recognition Using Smartphones Dataset (Version 1.0)
==================================================================
A script to create a tidy version of data from Smartlab, which was written by Daniel Maurath to meet the requirements of a course Getting And Cleaning Data.

To learn more about the original data see Smartlabs README file — SMARTLAB_README.txt

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

==================================================================
###ABOUT THE SCRIPT
*run_analysis.r* contains a function to transform the following data sets into a single tidy data set:
+activity_labels.txt
+features.txt
+subject_test.txt
+subject_train.txt
+X_test.txt
+X_train.txt
+y_test.txt
+y_train.txt

###TO RETRIEVE THE DATA SETS ABOVE
+Download - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
+Unzip to directory

###USAGE
1. Save the file "run_analysis.r" into the unzipped directory you created above
2. In your R console, type: 
```
source("run_analysis.r")
```

###EXAMPLE OUTPUT
The file will output a tidy data set with 68 columns and 180 rows. Here is an example output of how the dataset should look with the columns 4 to 68 removed for easier viewing. Columns 4 to 68 contain more feature averages. 

| Subject | Activity |  "tBodyAcc-mean()-X" | Feature-Avgerages 4:68...
| ------- |:--------:| --------------------:|
| 1       | LAYING   | 0.2813734            |
| 1       | SITTING  | 0.2759908            |
| 1       | STANDING | 0.2776850            |
