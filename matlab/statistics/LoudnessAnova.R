
#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
LData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaLoudnessDiffThresholdWithout9Sub.xlsx")

names(LData)
summary(LData)

typeof(LData$LoudnessThreshold)
LData$LoudnessThreshold = as.integer(LData$LoudnessThreshold)
typeof(LData$LoudnessThreshold)


typeof(LData$Duration)
LData$Duration = as.factor(LData$Duration)
typeof(LData$Duration)

typeof(LData$Group)
LData$Group = as.factor(LData$Group)
typeof(LData$Group)

typeof(LData$Room)
LData$Room = as.factor(LData$Room)
typeof(LData$Room)

typeof(LData$Id)
LData$Id = as.factor(LData$Id)
typeof(LData$Id)


#Result = aov(LoudnessThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),LData)
Result = aov(DiffThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),LData)

summary(Result)

print(model.tables(Result,"means"),digits=3)       #report the means and the number of subjects/cell









