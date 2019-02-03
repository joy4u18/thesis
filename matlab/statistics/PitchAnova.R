
#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)
library(ez)
library(car)


# load the data
#PData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaPitchDiffThreshold.xlsx")
PData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawDataAnovaPitchDiffThresholdWithout9Sub.xlsx")

names(PData)
summary(PData)

typeof(PData$PitchThreshold)
PData$PitchThreshold = as.integer(PData$PitchThreshold)
typeof(PData$PitchThreshold)


typeof(PData$Duration)
PData$Duration = as.factor(PData$Duration)
typeof(PData$Duration)

typeof(PData$Group)
PData$Group = as.factor(PData$Group)
typeof(PData$Group)

typeof(PData$Room)
PData$Room = as.factor(PData$Room)
typeof(PData$Room)

typeof(PData$Id)
PData$Id = as.factor(PData$Id)
typeof(PData$Id)


#Result = aov(PitchThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),PData)
#Result = aov(DiffThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),PData)
Result <- ezANOVA(data = PData, 
                  dv = .(DiffThreshold), 
                  wid = .(Id), 
                  within = .(Duration, Room), 
                  between = .(Group),
                  type = 3, detailed = TRUE)
#
#summary(Result)
#print(model.tables(Result,"means"),digits=3)       #report the means and the number of subjects/cell
print(Result)








