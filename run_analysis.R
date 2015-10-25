setwd("/Users/yy/FROM_OLD_MAC/CourseraClasses/GettingAndCleaningData/CourseProject")

# Project Step 1 
# This block reads the test and training data sets and combines them

test_data_raw <- read.table("./UCI HAR DATASET/test/X_test.txt")
train_data_raw <- read.table("./UCI HAR DATASET/train/X_train.txt")

data_full <- rbind(test_data_raw, train_data_raw)

# Assignes the variable names to the columns

names <- read.table("./UCI HAR DATASET/features.txt")

v <- as.character(names$V2) #rename
names(data_full) <- v

# Reads the "Activities" data from the Test and Training datasets and combines them

activities1 <- read.table("./UCI HAR DATASET/test/y_test.txt")
activities2 <- read.table("./UCI HAR DATASET/train/y_train.txt")
activities <- rbind(activities1, activities2)

# Reads the "Subject" data from the Test and Training datasets and combines them

subjects1 <- read.table("./UCI HAR DATASET/test/subject_test.txt")
subjects2 <- read.table("./UCI HAR DATASET/train/subject_train.txt")
subjects <- rbind(subjects1, subjects2)

# Adds the "Activities" and "Subject" column to the main dataset and names the columns with descriptive names
data_full2 <- cbind(activities, data_full)
data_full3 <- cbind(subjects, data_full2)

names(data_full3)[1] <- "Subject"
names(data_full3)[2] <- "Activity"

# Project Step 2
# Extacts only the variables that contain measures of mean and standard deviation for each measurement (I included all variables that have "mean" or "standard deviation" in their name. I took this approach since I dont feel I have the necessary background in physics to decide which variables should be included based on their meaning).

new_data <- data_full3[, grep("Activity|Subject|Mean|mean|std", names(data_full3))]

# Step 3
# Uses activity labels to name the activities in the data set

activityLabels <- read.table("./UCI HAR DATASET/activity_labels.txt")

new_data$Activity <- as.factor(new_data$Activity)

levels(new_data$Activity) <- activityLabels$V2


# Step4
# Cleaned up the variables names by removing unnecessary characters, such as "-" or "()". Decided not to do any further changes as I think the variables' names are descriptive enough and I don't have necessary background in physics to make proper changes. 

names(new_data) <- gsub("-", "_", names(new_data))
names(new_data) <- gsub("\\()", "", names(new_data))

# Step 5
# From the data set in step 4, created a tidy data set with the average of each variable for each activity and each subject.

new_data2 <- group_by(new_data, Subject, Activity) %>% summarize_each(c("mean"))

# Write out file

write.table(new_data2, file = "tidy_dataset.txt", row.names = FALSE)







