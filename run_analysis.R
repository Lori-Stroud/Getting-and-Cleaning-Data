dirPath <- getwd()

cat("\n\n\t\t=========================== Running Script Please Wait ===========================\n\n")

# Reading the feature data from necessary files
cat("\t\t\t\t\t> Reading Feature Data from files...\n")
xTrain <- read.table(paste(dirPath, "/train/X_train.txt", sep=""))
xTest <- read.table(paste(dirPath, "/test/X_test.txt", sep=""))
featureData <- rbind(xTrain, xTest)     # combining train and test data into one data frame

# Reading the activity identifiers from necessary files
cat("\t\t\t\t\t> Reading Activity Label Data from files...\n")
yTrain <- read.table(paste(dirPath, "/train/y_train.txt", sep=""))
yTest <- read.table(paste(dirPath, "/test/y_test.txt", sep=""))
activityLabels <- rbind(yTrain, yTest)  # combining train and test data into one data frame
names(activityLabels) <- "activityid"   # giving a proper name to the variable

# Reading the subject identifiers from necessary files
cat("\t\t\t\t\t> Reading Subject Id Data from files...\n")
sTrain <- read.table(paste(dirPath, "/train/subject_train.txt", sep=""))
sTest <- read.table(paste(dirPath, "/test/subject_test.txt", sep=""))
subjectLabels <- rbind(sTrain, sTest)   # combining train and test data into one data frame
names(subjectLabels) <- "subjectid"     # giving a proper name to the variable

# Reading the feature names from necessary files
cat("\t\t\t\t\t> Reading Feature Names from file...\n")
featureNames <- read.table(paste(dirPath, "/features.txt", sep=""));
featureNames <- featureNames[,2]   # getting only the names

# Getting required feature subset from original feature set
cat("\t\t\t\t\t> Getting required feature subset...\n")
reqdfeatureIndices <- grep("-mean\\(\\)|-std\\(\\)", featureNames)  # getting only variables with mean() and std() in them
featureData <- featureData[,reqdfeatureIndices]
names(featureData) <- featureNames[reqdfeatureIndices]
# Transforming variable names to follow conventions
names(featureData) <- gsub("\\(|\\)", "", names(featureData)) 
names(featureData) <- tolower(names(featureData))

# Getting the activity names 
cat("\t\t\t\t\t> Reading Activity Names from file...\n")
activityNames <- read.table(paste(dirPath, "/activity_labels.txt", sep="")); 
activityNames[, 2] <- gsub("_", "", tolower(as.character(activityNames[, 2])))

# Transforming activity identifiers into names
cat("\t\t\t\t\t> Transforming Activity IDs to  Activity Names...\n")
activityData <- data.frame(activityname=activityNames[activityLabels[,],2])

# Combining all the data frames into one single data frame
cat("\t\t\t\t\t> Combining all data frames...\n")
cleanData <- cbind(subjectLabels,activityData,featureData)

# Writing our first tidy dataset into files
cat("\t\t\t\t\t> Writing 1st clean dataset to file...\n")
write.csv(cleanData,"clean_data.csv",row.names=FALSE)
write.table(cleanData,"clean_data.txt",sep="\t",row.names=FALSE)
cat("\t\t\t\t\t> Write complete...\n")

# loading the reshape2 package
cat("\t\t\t\t\t> Loading required packages...\n")
library(reshape2)


# Setting the required identifier and measure variables
cat("\t\t\t\t\t> Setting up ID and Measure variables...\n")
idVars <- c("subjectid","activityname")
measureVars <- setdiff(colnames(cleanData), idVars)

# Melting the data frame now
cat("\t\t\t\t\t> Melting the data frame...\n")
meltedData <- melt(cleanData, id=idVars, measure.vars=measureVars)

# Decasting the molten data frame based on required criteria
cat("\t\t\t\t\t> Decasting molten data into aggregated data frame...\n")
tidyData <- dcast(meltedData,subjectid+activityname ~ variable,mean)

# Writing our final tidy dataset into files
cat("\t\t\t\t\t> Writing 2nd tidy dataset to file...\n\n")
write.csv(tidyData,"tidy_data.csv",row.names=FALSE)
write.table(tidyData,"tidy_data.txt",sep="\t",row.names=FALSE)

cat("\t\t==================================== All Done ====================================\n")
