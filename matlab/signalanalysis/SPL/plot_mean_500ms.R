#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
splData <- read_excel("E:/GitHub/thesis/matlab/signalanalysis/SPL/SPL_AC.xls")
#splData %>% select(c(-6)) -> splData

#debug
#View(splData)

# pre processdata
#splData$Object_Distance <- factor(splData$Object_Distance, levels = splData$Object_Distance[order(splData$Plot_Order)])
splData$Object_Distance  # notice the changed order of factor levels

# plot
#ggplot(data=splData,aes( y=SPL,x=Object_Distance, col= Ear, shape=Room)) +geom_point() 
#ggplot(data=splData,aes( y=SPL,x=factor(Object_Distance), col= Room)) +geom_boxplot() 
obj1 <- ggplot(data=splData,aes( y=SPL,x=factor(Object_Distance), color = factor(Ear), shape= factor(Ear), group=factor(Ear))) + geom_errorbar(aes(ymin = SPL - SEM, 
                                                                                                                                                   ymax = SPL + SEM),
                                                                                                                                               width = 1, size = 1, position = "dodge", colour = "black") +geom_point(size=3) +geom_line(size=1) 
obj2 <- obj1 + facet_grid(~Room)
obj3 <- obj2 +labs(x="Distance (m)", y="SPL (dBA)")
obj4 <- obj3 + theme(panel.background = element_rect(fill = "white"))
obj5 <- obj4 + theme(plot.title = element_text(hjust = 0.5, face= "bold") )
obj5 + scale_x_discrete(limits = c("No Object 1","No Object 2","50","100","150","200","300","400","500"), labels=c("No Object 1" = "0", "No Object 2" = "0"))
obj6 <- (obj5 + scale_x_discrete(
  limits = c("No Object 1","No Object 2","50","100","150","200","300","400","500"), 
  labels=c("No Object 1" = "0", "No Object 2" = "0", "50" = "0.5","100" = "1",
           "150" = "1.5", "200" = "2","300" = "3","400" = "4","500" ="5") ))
obj7 <- obj6 + scale_color_discrete(name="", labels = c("Left Ear", "Right Ear")) + scale_shape_discrete(name ="", labels = c("Left Ear", "Right Ear")) 
obj8 <- (obj7 + 
           theme( panel.grid.major = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 <- (obj8 + 
           theme( panel.grid.minor  = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 + scale_y_continuous(breaks = seq(10,92,2))
obj10 <- obj9  + theme(panel.spacing =unit(.05, "lines"), panel.border = element_rect(color = "black", fill = NA, size = 1), strip.background = element_rect(color = "black", size = 1)) 
obj10 + theme(legend.spacing.x =  unit(1,"line"), legend.title = element_blank(), legend.position = c(0.85, 0.85), legend.background = element_rect(fill="lightblue",
                                                                                                                                                    size=0.5, linetype="solid", 
                                                                                                                                                    colour ="darkblue"))
