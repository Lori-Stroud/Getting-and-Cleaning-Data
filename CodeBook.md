Getting & Cleaning Data Course Project CodeBook

Dataset details:

Brief Introduction

This project is based on one of the most exciting areas in all of data science right now, which is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website and also in the link given below, represent data collected from the accelerometers from the Samsung Galaxy S smartphone and we have to use this data for our project and perform some computations and processing on it.

Main Objective

The main objective of this project is to demonstrate our ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis

Original Dataset Name: Human Activity Recognition Using Smartphones Data Set

Dataset File Name: getdata-projectfiles-UCI HAR Dataset

Dataset Download Link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Dataset description

The Human Activity Recognition database was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Data Set Characteristics	Number of Instances	Number of Attributes	Number of activities	Number of subjects
Multivariate, Time-Series	      10299	               561	                  6	                 30



The folder structure of the dataset is as follows

		UCI HAR Dataset/                                                                                  
   			|                                                                                               
   			|---------- activity_labels.txt                                                                 
   			|---------- features.txt                                                                        
   			|---------- features_info.txt                                                                  
   			|---------- README.txt                                                                  
   			|---------- run_analysis.R ( you have to paste it here )                                                                   
   			|                                                                                             
   			|---------- test                                                                                
   			|             |---------- Inertial Signals                                             
   			|             |               |---------- Other Files...                               
            |             |                                                   
   			|             |---------- X_test.txt                                                   
   			|             |---------- y_test.txt                                                  
   			|             |---------- subject_test.txt                                            
   			|                                                                                     
   			|---------- train                                                                      
   			              |---------- Inertial Signals                                            
   			              |               |---------- Other Files...                            
   			              |                                                                       
   			              |---------- X_train.txt                                                
   			              |---------- y_train.txt                                                 
   			              |---------- subject_train.txt  

A brief description of the data files are provided below.

features_info.txt: Shows information about the variables used on the feature vector.
features.txt: List of all feature names.
activity_labels.txt: Links the activity class labels with their activity name.
train/X_train.txt: Training set of all the 561 features. Features are normalized and bounded within [-1,1].
train/y_train.txt: Training labels of activities. Range is from 1 to 6.
test/X_test.txt: Test set of all the 561 features. Features are normalized and bounded within [-1,1].
test/y_test.txt: Test labels of activities. Range is from 1 to 6.
train/subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Range is from 1 to 30.
test/subject_test.txt: Each row identifies the subject who performed the activity for each window sample. Range is from 1 to 30.


Dataset processing and transformation details

We used all the data files explained above for creating the tidy dataset. The explanation of how the script works is written in detail in README.md so do refer to it as and when needed. Here, we will dive down into the data and explain in detail how we processed and transformed the data into the final tidy dataset.


First we combined the files X_train.txt and X_test.txt into the featureData data frame using the rbind command. This data frame has 10299 rows, where each row represents a case corresponding to a particular subject and 561 columns corresponding to the 561 features, where each is a particular measure.


Next, we combined the files y_train.txt and y_test.txt into the activityLabels data frame using the rbind command. This data frame has 10299 rows and 1 column, where each row represents an activity done by a particular subject.
Next, we combined the files subject_train.txt and subject_test.txt into the subjectLabels data frame using the rbind command. This data frame has 10299 rows and 1 column, where each row represents a particular person i.e., subject identifier.


Then, we read in the feature names from the files features.txt and stores it in the featureNames vector with dimensions of 561 x 2. Where each row represents a particular feature consisting of a feature identifier and its corresponding feature name. We transform this into a 561 x 1 vector containing the feature names only and store it back into the featureNames vector.


From the featureNames vector, we get the required feature indices using the grep command for features having both mean and std and store the indices in the reqdfeatureIndices vector of size 66 x 1 representing a total of 66 features. We use the gsub command to remove the () symbols from the variable names and also converted them to lower case following the conventions for variable names.


Then, we read the different activity names corresponding to the activity identifiers from the activity_labels.txt file and transform the activity ids in the activityLabels data frame to form a new data frame activityData of size 10299 x 1 containing all the activity names. We also follow necessary naming conventions by removing underscores and transforming the names to lower case.


Finally we combine the three dataframes, subjectLabels, activityData and featureData to form the data frame cleanData with dimensions 10299 x 68. This is the first required tidy data set and we write it to the files clean_data.csv and clean_data.txt both having the same content. The rows represent a particular case of a perticular subject.


Next, we load the reshape2 package which will be required for creating the next tidy data set.


Next, we set our identifier and measure variables as idVars and measureVars respectively and then we convert our cleanData data frame into a molten data frame meltedData with dimensions of 679734 x 4 using the melt function. The idVars contain subjectid and activityname because we will be using them as identifier variables while computing average of the remaining feature variables which are the measure variables here.


Now, we decast our molten data frame into the required aggregated data frame where each feature is averaged per person ( subjectid ) per activity ( activityname ) using the dcast function, and we get our second required tidy data set tidyData which is a data frame having dimensions 180 x 68


We write this tidy data set to the files tidy_data.csv and tidy_data.txt both having the same content. Here each row represents a case of a particular subject performing a particular activity and all the features corresponding to that person and activity are averaged.
