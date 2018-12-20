#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
SThdData <- read_excel("E:/GitHub/thesis/matlab/statistics/SthdRanalysis.xlsx")


#debug
#View(SThdData)

# pre processdata


# plot
#ggplot(data=LdData,aes( y=SPL,x=Object_Distance, col= Ear, shape=Room)) +geom_point() 
#ggplot(data=LdData,aes( y=SPL,x=factor(Object_Distance), col= Room)) +geom_boxplot() 
(obj1 <- ggplot(data=SThdData,
                aes( y=DiffThreshold,x=Id, color=Group,
                     shape=Group, group=Group)) +geom_point(size=3, position=position_dodge(0.3)) + geom_line(size=0.5, position=position_dodge(0.3)))
#geom_errorbar(aes(ymin = Sharpness - SEM, 
#ymax = Sharpness + SEM),
#width = 0.5, size = 0.5, position=position_dodge(0.3))) 
obj1 <- obj1 + geom_point (aes(y=SharpnessThreshold), size=3, position=position_dodge(0.3)) + geom_line(aes(y=SharpnessThreshold), size=0.5, position=position_dodge(0.3))

obj2 <- obj1 + facet_grid(vars(Room), vars(Duration))
obj3 <- obj2 +labs(x="Participant", y="Sharpness Threshold (accum)")
obj3
obj4 <- obj3 + theme(panel.background = element_rect(fill = "white"))
obj5 <- obj4 + theme(plot.title = element_text(hjust = 0.5, face= "bold") )
obj6 <- obj5
obj7 <- obj6 + scale_color_discrete(name="", labels = c("Blind", "Sighted")) + scale_shape_discrete(name ="", labels = c("Blind", "Sighted"))
obj8 <- (obj7 + 
           theme( panel.grid.major = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 <- (obj8 + 
           theme( panel.grid.minor  = element_line(size = 0.5, linetype = 'dotted', colour = "black")))

obj10 <- obj9  + scale_y_continuous(breaks = seq(0,2,0.5)) +scale_x_continuous(breaks = seq(1,20,2))
obj10






