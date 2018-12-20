#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
DThdData <- read_excel("E:/GitHub/thesis/matlab/statistics/MeanDthdRanalysis.xlsx")


#debug
#View(DThdData)

# pre processdata


# plot

(obj1 <- ggplot(data=DThdData,
                aes( y=DistanceThreshold, x=Observation,  color=Group,
                     shape=Group, group=Group)) + geom_point(size=3) + geom_line(size=1))
# New facet label names for dose variable
Duration.labs <- c("5 ms", "50 ms", "500 ms")
names(Duration.labs) <- c("5", "50", "500")
obj2 <- obj1 + facet_grid(vars(Duration), vars(Room), labeller = labeller(Duration = Duration.labs))

obj3 <- obj2 +labs(y="Distance Threshold (cm)", x = "")
obj4 <- obj3 + theme(panel.background = element_rect(fill = "white"))
obj5 <- obj4 + theme(plot.title = element_text(hjust = 0.5, face= "bold") )
obj6 <- obj5
obj7 <- obj6 + scale_color_discrete(name="", labels = c("Blind", "Sighted")) + scale_shape_discrete(name ="", labels = c("Blind", "Sighted"))
obj8 <- (obj7 + 
           theme( panel.grid.major = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 <- (obj8 + 
           theme( panel.grid.minor  = element_line(size = 0.5, linetype = 'dotted', colour = "black")))

obj10 <- obj9  + scale_y_continuous(breaks = seq(100,250,25)) +scale_x_discrete(breaks = seq(0,2,1))
obj11  <- obj10 + theme(panel.margin=unit(.05, "lines"), panel.border = element_rect(color = "black", fill = NA, size = 1), strip.background = element_rect(color = "black", size = 1), strip.text.y = element_text(angle = 0)) 
obj11 + theme(legend.spacing.x =  unit(1,"line"), legend.title = element_blank(), legend.position = c(0.85, 0.85), legend.background = element_rect(fill="lightblue",
                                                                                                                                                    size=0.5, linetype="solid", 
                                                                                                                                                    colour ="darkblue"))



