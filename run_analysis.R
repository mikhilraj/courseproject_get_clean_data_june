# load library
library(reshape2)

## load data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
sub <- rbind(sub_train, sub_test)

# Assign descriptive names to columns
colnames(y) <- "Activity_id"
colnames(sub) <- "Subject"

#load activity names
Activity_names <- read.table("UCI HAR Dataset/activity_labels.txt")

#load feature names
features <- read.table("UCI HAR Dataset/features.txt")
labels <- features[,2]

# Assign descriptive names to columns
colnames(x) <- labels

## select features containing measurements on the mean and standard deviation
index <- grepl("mean\\(\\)|std\\(\\)", labels)
x <- x[,index]

# merge into single data frame
tidy_data <- cbind(sub,y,x)

# build independent tidy data set with the average of each variable 
# for each activity and each subject. 
tidy_data_final <- aggregate(. ~ Subject + Activity_id, data=tidy_data, FUN = mean)

tidy_data_final$Activity <- factor(tidy_data_final$Activity_id, labels=Activity_names[,2])

write.table(tidy_data_final, file="./tidy_data.txt", sep="\t", row.names=FALSE)

