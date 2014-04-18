Getting and Cleaning Data Project
===========
The script already contains comments explaining each steps. Here lists some main steps:
1. Load data sets into R.
2. Find feature names with mean() and std(), and extract columns from both train and test dataset.
3. Add subject id and activity id to both train and test datasets.
4. Combine train and test datasets.
5. Merge combined dataset with activity labels. 
6. Create data table from dataset.
7. Group the table by subject and activity, and apply ave() to the rest columns.
8. Remove duplicate rows.
9. Write result to csv file.