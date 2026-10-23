# Getting and Cleaning Data Project

The purpose of this project is to demonstrate how to collect, work with, and clean a data set from Samsung Galaxy S smartphone

It cleans up and restructures the UCI HAR (Human Activity Recognition Using Smartphones) data set, which was recorded by the accelerometers and gyroscopes in Samsung Galaxy S phones, so that it is ready for analysis.

### Files

File	                Purpose
clean_tidy_data.R	The only script. Downloads the data, cleans it and writes the tidy data set
Codebook.Rmd	        Describes the variables, the data and every transformation applied
Codebook.pdf            pdf version of the above codebook
tidy_data.txt	        Output of the script

### How to run and view table of the output

r
source("clean_tidy_data.R")
tidy <- read.table("tidy_data.txt", header = TRUE)
View(tidy)

Requirements: base R only, with no additional packages needed. You’ll need an internet connection the first time you run the script, so it can download and unzip the data into your working directory as UCI HAR Dataset/. If that folder already exists, the download is skipped.

### What the script does

1)  Combines the training and test sets (measurements, activity ids and subject ids) into a single data frame.
2)  Keeps only the mean and standard deviation measurements, meaning the 66 variables whose names contain -mean() or -std().
3)  Replaces the activity ids with the descriptive names in activity_labels.txt.
4)  Gives the variables descriptive names, so that, for example, tBodyAcc-mean()-X becomes timeBodyAccelerometerMeanX.
5)  Builds the tidy data set by averaging each variable for every subject and activity (180 rows x 68 columns), and saves it as tidy_data.txt.

The full list of variables and the naming scheme are in Codebook.Rmd or Codebook.pdf.