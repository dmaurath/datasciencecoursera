### *Tidy* Human Activity Recognition Using Smartphones Dataset (Version 1.0)
==================================================================
This is a script to create a tidy version (see definition in CODEBOOK.md) of data from Smartlab. The script was written by Daniel Maurath as a project for the course Getting And Cleaning Data.

Data was collected from the accelerometers in Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

You can also learn more about the original data in the Smartlabs README file, which I have included in this repo — SMARTLAB_README.txt


###CONTENTS OF THIS REPO
1. Tidy data set named *tidy_dataset.txt*
2. CODEBOOK.md lists all variables and 
3. *run_analysis.r* — a script with the exact steps I completed to go from raw to tidy data

###RAW DATA
1. Raw Data was obtained from this link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Unzip to your working directory
3. Note: *Intertial Signals* folders were ignored for this analysis
4. Original README for the raw data

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

###USAGE
1. Ensure the file "run_analysis.r" is in same directory as the 8 files above
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
