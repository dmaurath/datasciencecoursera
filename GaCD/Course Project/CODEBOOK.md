###SUMMARY
- 180 rows (30 Subjects X 6 Activities)
- 68 columns 
- Each row represents one observation per activity with the average of 66 features.
- Only features with "-mean" or "-std" were used in this analysis because I was only interested in the mean and standard deviation of the feature values, and not other various means or standard deviations.
- First column is "subject", and is labelled as 1,2,3.....30
- Second column is "activity", and can take following 6 values -
	1. LAYING
	2. SITTING
	3. STANDING
	4. WALKING
	5. WALKING DOWNSTAIRS
	6. WALKING UPSTAIRS

Remaining 66 columns are means of each feature's means from the original data (i.e. the columns in original dataset containing *mean()* and *std()*). 

For example, *tBodyAcc-mean()-X* is the average of all *tBodyAcc-mean()-X* means for a given activity. 

###TIDY DATA RULES FOLLOWED IN THIS DATASET
1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.


###COLUMNS
68 Columns

1.  Subject

2.  activityLabel

3.  tBodyAcc-mean()-X

4.  tBodyAcc-mean()-Y

5.  tBodyAcc-mean()-Z

6.  tBodyAcc-std()-X

7.  tBodyAcc-std()-Y

8.  tBodyAcc-std()-Z

9.  tGravityAcc-mean()-X

10.  tGravityAcc-mean()-Y

11.  tGravityAcc-mean()-Z

12.  tGravityAcc-std()-X

13.  tGravityAcc-std()-Y

14.  tGravityAcc-std()-Z

15.  tBodyAccJerk-mean()-X

16.  tBodyAccJerk-mean()-Y

17.  tBodyAccJerk-mean()-Z

18.  tBodyAccJerk-std()-X

19.  tBodyAccJerk-std()-Y

20.  tBodyAccJerk-std()-Z

21.  tBodyGyro-mean()-X

22.  tBodyGyro-mean()-Y

23.  tBodyGyro-mean()-Z

24.  tBodyGyro-std()-X

25.  tBodyGyro-std()-Y

26.  tBodyGyro-std()-Z

27.  tBodyGyroJerk-mean()-X

28.  tBodyGyroJerk-mean()-Y

29.  tBodyGyroJerk-mean()-Z

30.  tBodyGyroJerk-std()-X

31.  tBodyGyroJerk-std()-Y

32.  tBodyGyroJerk-std()-Z

33.  tBodyAccMag-mean()

34.  tBodyAccMag-std()

35.  tGravityAccMag-mean()

36.  tGravityAccMag-std()

37.  tBodyAccJerkMag-mean()

38.  tBodyAccJerkMag-std()

39.  tBodyGyroMag-mean()

40.  tBodyGyroMag-std()

41.  tBodyGyroJerkMag-mean()

42.  tBodyGyroJerkMag-std()

43.  fBodyAcc-mean()-X

44.  fBodyAcc-mean()-Y

45.  fBodyAcc-mean()-Z

46.  fBodyAcc-std()-X

47.  fBodyAcc-std()-Y

48.  fBodyAcc-std()-Z

49.  fBodyAccJerk-mean()-X

50.  fBodyAccJerk-mean()-Y

51.  fBodyAccJerk-mean()-Z

52.  fBodyAccJerk-std()-X

53.  fBodyAccJerk-std()-Y

54.  fBodyAccJerk-std()-Z

55.  fBodyGyro-mean()-X

56.  fBodyGyro-mean()-Y

57.  fBodyGyro-mean()-Z

58.  fBodyGyro-std()-X

59.  fBodyGyro-std()-Y

60.  fBodyGyro-std()-Z

61.  fBodyAccMag-mean()

62.  fBodyAccMag-std()

63.  fBodyBodyAccJerkMag-mean()

64.  fBodyBodyAccJerkMag-std()

65.  fBodyBodyGyroMag-mean()

66.  fBodyBodyGyroMag-std()

67.  fBodyBodyGyroJerkMag-mean()

68.  fBodyBodyGyroJerkMag-std()
