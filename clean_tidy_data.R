# Produces a tidy data set from the UCI HAR Dataset (Samsung Galaxy S accelerometer / gyroscope data).
#
# Output: average of each mean/std variable for each subject and activity)

zip_url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!file.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    download.file(zip_url, destfile = zip_file, mode = "wb")
  }
  unzip(zip_file)
}

features <- read.table(file.path(data_dir, "features.txt"),
                       col.names = c("index", "name"),
                       stringsAsFactors = FALSE)
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"),
                              col.names = c("id", "activity"),
                              stringsAsFactors = FALSE)

read_set <- function(set) {
  x <- read.table(file.path(data_dir, set, paste0("X_", set, ".txt")),
                  header = FALSE)
  names(x) <- features$name

  y <- read.table(file.path(data_dir, set, paste0("y_", set, ".txt")),
                  col.names = "activity_id")
  s <- read.table(file.path(data_dir, set, paste0("subject_", set, ".txt")),
                  col.names = "subject")

  cbind(s, y, x)
}

merged <- rbind(read_set("train"), read_set("test"))

keep <- grepl("-(mean|std)\\(\\)", features$name)
merged <- merged[, c(TRUE, TRUE, keep)]   

merged$activity <- factor(merged$activity_id,
                          levels = activity_labels$id,
                          labels = tolower(gsub("_", " ", activity_labels$activity)))
merged$activity_id <- NULL
merged <- merged[, c("subject", "activity",
                     setdiff(names(merged), c("subject", "activity")))]

clean_names <- function(n) {
  n <- gsub("\\(\\)", "", n)
  n <- gsub("^t", "time", n)
  n <- gsub("^f", "frequency", n)
  n <- gsub("BodyBody", "Body", n)
  n <- gsub("Acc", "Accelerometer", n)
  n <- gsub("Gyro", "Gyroscope", n)
  n <- gsub("Mag", "Magnitude", n)
  n <- gsub("-mean", "Mean", n)
  n <- gsub("-std", "StandardDeviation", n)
  n <- gsub("-", "", n)
  n
}
names(merged) <- c("subject", "activity", clean_names(names(merged)[-(1:2)]))

tidy <- aggregate(. ~ subject + activity, data = merged, FUN = mean)
tidy <- tidy[order(tidy$subject, tidy$activity), ]
rownames(tidy) <- NULL

write.table(tidy, file = "tidy_data.txt", row.names = FALSE)
