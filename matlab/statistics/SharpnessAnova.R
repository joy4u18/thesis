
#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
SData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaSharpnessDiffThreshold.xlsx")

names(SData)
summary(SData)

typeof(SData$SharpnessThreshold)
SData$SharpnessThreshold = as.integer(SData$SharpnessThreshold)
typeof(SData$SharpnessThreshold)


typeof(SData$Duration)
SData$Duration = as.factor(SData$Duration)
typeof(SData$Duration)

typeof(SData$Group)
SData$Group = as.factor(SData$Group)
typeof(SData$Group)

typeof(SData$Room)
SData$Room = as.factor(SData$Room)
typeof(SData$Room)

typeof(SData$Id)
SData$Id = as.factor(SData$Id)
typeof(SData$Id)


#Result = aov(SharpnessThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),SData)
Result = aov(DiffThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),SData)

summary(Result)

print(model.tables(Result,"means"),digits=3)       #report the means and the number of subjects/cell









