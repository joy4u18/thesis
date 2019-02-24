
#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)
library(ez)
library(car)


# load the data
#DData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawDataAnovaDistThreshold.xlsx")
DData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaDistThresholdWithout9Sub.xlsx")

names(DData)
summary(DData)

typeof(DData$DistanceThreshold)
DData$DistanceThreshold = as.integer(DData$DistanceThreshold)
typeof(DData$DistanceThreshold)


typeof(DData$Duration)
DData$Duration = as.factor(DData$Duration)
typeof(DData$Duration)

typeof(DData$Group)
DData$Group = as.factor(DData$Group)
typeof(DData$Group)

typeof(DData$Room)
DData$Room = as.factor(DData$Room)
typeof(DData$Room)

typeof(DData$Id)
DData$Id = as.factor(DData$Id)
typeof(DData$Id)


#Result = aov(PitchThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),DData)
#Result = aov(DiffThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),DData)
Result <- ezANOVA(data = DData, 
                  dv = .(DistanceThreshold), 
                  wid = .(Id), 
                  within = .(Duration, Room), 
                  between = .(Group),
                  type = 3, detailed = TRUE)
#
#summary(Result)
#print(model.tables(Result,"means"),digits=3)       #report the means and the number of subjects/cell
print(Result)








