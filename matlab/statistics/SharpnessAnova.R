
#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)
library(ez)
library(car)


# load the data
#SData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaSharpnessDiffThreshold.xlsx")
SData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaSharpnessDiffThresholdWithout9Sub.xlsx")

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
#Result = aov(DiffThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),SData)

Result <- ezANOVA(data = SData, 
                  dv = .(DiffThreshold), 
                  wid = .(Id), 
                  within = .(Duration, Room), 
                  between = .(Group),
                  type = 3, detailed = TRUE)

#summary(Result)
#print(model.tables(Result,"means"),digits=3)       #report the means and the number of subjects/cell
print(Result)








