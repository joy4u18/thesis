#clear 
rm(list=ls())

# library needed


#library(devtools)
#dev_mode()
#install_github('mike-lawrence/ez')
library(ez)
library(car)
library(readxl)
library(dplyr)

# https://stats.stackexchange.com/questions/78673/how-to-deal-with-unbalanced-group-sizes-in-mixed-design-analysis/78743
#options(contrasts=c("contr.sum","contr.poly"))

#help(Anova)
#help(ezANOVA)

# load the data
LData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaLoudnessDiffThresholdWithout9Sub.xlsx")
#LData <- read_excel("E:/GitHub/thesis/matlab/statistics/rawdataAnovaLoudnessDiffThreshold.xlsx")
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


#Result = aov(DiffThreshold~(Duration*Room*Group)+Error(Id/(Duration*Room))+(Group),LData)
Result <- ezANOVA(data = LData, 
        dv = .(DiffThreshold), 
        wid = .(Id), 
        within = .(Duration, Room), 
        between = .(Group),
        type = 3, detailed = TRUE)



#Result$ANOVA
#summary(Result$ANOVA)
print(Result)











 