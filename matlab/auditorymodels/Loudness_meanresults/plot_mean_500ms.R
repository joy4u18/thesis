#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
LdData <- read_excel("E:/GitHub/thesis/matlab/auditorymodels/Loudness_meanresults/Ldns.xls")


#debug
#View(LdData)

# pre processdata


# plot
#ggplot(data=LdData,aes( y=SPL,x=Object_Distance, col= Ear, shape=Room)) +geom_point() 
#ggplot(data=LdData,aes( y=SPL,x=factor(Object_Distance), col= Room)) +geom_boxplot() 
(obj1 <- ggplot(data=LdData,
aes( y=Loudness,x=factor(Object_Distance), color=factor(Duration),
    shape=factor(Duration), group=factor(Duration))) + geom_errorbar(aes(ymin = Loudness - SEM, 
                                                                         ymax = Loudness + SEM),
                                                                     width = 1, size = 1, position = "dodge", colour = "black") +geom_point(size=3) +  geom_path(size=1))

obj2 <- obj1 + facet_grid(cols = vars(Room)) 
obj3 <- obj2 +labs(y="Loudness (sone)", x = "Distance (m)")
obj4 <- obj3 + theme(panel.background = element_rect(fill = "white"))
obj5 <- obj4 + theme(plot.title = element_text(hjust = 0.5, face= "bold") )
obj6 <- (obj5 + scale_x_discrete(
limits = c("No Object 1","No Object 2","50","100","150","200","300","400","500"), 
labels=c("No Object 1" = "0", "No Object 2" = "0", "50" = "0.5","100" = "1",
         "150" = "1.5", "200" = "2","300" = "3","400" = "4","500" ="5") )) 
obj7 <- obj6 + scale_color_discrete(name="", labels = c("5 ms", "50 ms", "500 ms")) + scale_shape_discrete(name ="", labels = c("5 ms", "50 ms", "500 ms"))
obj8 <- (obj7 + 
theme( panel.grid.major = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 <- (obj8 + 
    theme( panel.grid.minor  = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 + scale_y_continuous(breaks = seq(10,85,5))
obj10 <- obj9  + theme(panel.spacing =unit(.05, "lines"), panel.border = element_rect(color = "black", fill = NA, size = 1), strip.background = element_rect(color = "black", size = 1)) 
obj10 + theme(legend.spacing.x =  unit(1,"line"), legend.title = element_blank(), legend.position = c(0.85, 0.85), legend.background = element_rect(fill="lightblue",
                                                                                size=0.5, linetype="solid", 
                                                                                colour ="darkblue"))


