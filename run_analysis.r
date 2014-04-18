# load activity labels and features
labels = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label_id", "label"))
features = read.table("UCI HAR Dataset/features.txt", col.names = c("feature_id", "feature_name"))

# load train data
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subject_id"))
x_train = read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature_name)
y_train = read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("label_id"))

# load test data
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subject_id"))
x_test = read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature_name)
y_test = read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("label_id"))

# find feature names with mean() or std(), extract corresponding columns from the merged dataset
with_mean_or_std_logical = grepl("mean\\(\\)|std\\(\\)", features$feature_name)
x_train_with_mean_or_std = x_train[, with_mean_or_std_logical]
x_test_with_mean_or_std = x_test[, with_mean_or_std_logical]

# combine x_train with subject_train and y_train, combine x_test with subject_test and y_test
train_combined = cbind(subject_train, y_train, x_train_with_mean_or_std)
test_combined = cbind(subject_test, y_test, x_test_with_mean_or_std)

# merge x_train and x_test into one data set
train_test_merged = rbind(train_combined, test_combined)

# merge dataset with activity labels
train_test_with_label = merge(train_test_merged, labels, by.x = 'label_id', by.y = 'label_id', sort = F)

# move label column to front and replace label_id
train_test_with_label_first = cbind(train_test_with_label[, 69], train_test_with_label[, 2:68])
names(train_test_with_label_first)[1]='label'

# create data table from dataset
dt = data.table(train_test_with_label_first)

# group by subject_id and label and apply ave() to the rest of columns, remove the duplicate rows
dt_grouped_and_averaged = dt[,lapply(.SD, ave), by = c("subject_id", "label")]
result = unique(dt_grouped_and_averaged)

# write to csv file
write.csv(result, file = "result.csv", row.names = F)