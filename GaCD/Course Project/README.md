### *Tidy* Human Activity Recognition Using Smartphones Dataset (Version 1.0)
==================================================================
This is a script to create a tidy version (see definition in CODEBOOK.md) of data from Smartlab. The script was written by Daniel Maurath as a project for the course Getting And Cleaning Data.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

To learn more about the original data see Smartlabs README file — SMARTLAB_README.txt

==================================================================
###ABOUT THE SCRIPT
*run_analysis.r* contains a function to transform the following data sets into a single tidy data set:
1. activity_labels.txt
2. features.txt
3. subject_test.txt
4. subject_train.txt
5. X_test.txt
6. X_train.txt
7. y_test.txt
8. y_train.txt

###TO RETRIEVE THE DATA SETS ABOVE
1. Download from  this link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Unzip to directory

###USAGE
1. Save the file "run_analysis.r" into the unzipped directory you created above
2. In your R console, type: 
```
source("run_analysis.r")
```

###EXAMPLE OUTPUT
The file will output a tidy data set with 68 columns and 180 rows. Here is an example output of how the dataset should look with the columns 4 to 68 removed for easier viewing. Columns 4 to 68 contain more feature averages. 

| Subject | Activity |  "tBodyAcc-mean()-X" |
| :------ |:--------:| --------------------:|
| 1       | LAYING   | 0.2813734            |
| 1       | SITTING  | 0.2759908            |
| 1       | STANDING | 0.2776850            |
