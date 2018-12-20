#clear 
rm(list=ls())

# libraries needed
library(readxl)
library(dplyr)
library(ggplot2)


# load the data
PThdData <- read_excel("E:/GitHub/thesis/matlab/statistics/MeanPDiffthdRanalysis.xlsx")


#debug
#View(DThdData)

# pre processdata



# plot
obj1 <- ggplot(PThdData, aes(y=Threshold, x=Observation,  shape = Group, color =  Group, group = Group)) +geom_point(  size = 5) + scale_color_discrete(name="", labels = c("Blind", "Sighted")) + scale_shape_discrete(name ="", labels = c("Blind", "Sighted"))


# New facet label names for dose variable
Duration.labs <- c("5 ms", "50 ms", "500 ms")
names(Duration.labs) <- c("5", "50", "500")
TT.labs <- c("Absolute", "Difference")
names(TT.labs) <- c("A", "D")
obj2 <- obj1 + facet_grid(Duration ~ Room+TT, labeller = labeller(Duration = Duration.labs, TT = TT.labs))



obj3 <- obj2 +labs(x="", y="Pitch Threshold (autocorrelation index)")
obj4 <- obj3 + theme(panel.background = element_rect(fill = "white"))
obj5 <- obj4 + theme(plot.title = element_text(hjust = 0.5, face= "bold") )
obj6 <- obj5
obj7 <- obj6 
obj8 <- (obj7 + 
           theme( panel.grid.major = element_line(size = 0.5, linetype = 'dotted', colour = "black")))
obj9 <- (obj8 + 
           theme( panel.grid.minor  = element_line(size = 0.5, linetype = 'dotted', colour = "black")))

obj10 <- obj9  + scale_y_continuous(breaks = seq(0,3,0.5)) +scale_x_discrete(breaks = seq(0,2,1))
obj11 <- obj10  + theme(panel.spacing =unit(.05, "lines"), panel.border = element_rect(color = "black", fill = NA, size = 1), strip.background = element_rect(color = "black", size = 1), strip.text.y = element_text(angle = 0)) 
obj12 <- obj11 + theme(legend.spacing.x =  unit(1,"line"), legend.title = element_blank(), legend.position = c(0.90, 0.65), legend.background = element_rect(fill="lightblue",
                                                                                                                                                             size=0.5, linetype="solid", 
                                                                                                                                                             colour ="darkblue"))






library('gtable')
library('grid')
library('magrittr') # for the %>% that I love so well
library('gridExtra')

# First get the grob
z <- ggplotGrob(obj12) 
z


z$grob[[22]]


# Find the location of the strips in the main plot
locations <- grep("strip-t", z$layout$name)

# Filter out the strips (trim = FALSE is important here for positions relative to the main plot)
strip <- gtable_filter(z, "strip-t", trim = FALSE)

# Gathering our positions for the main plot
top <- strip$layout$t[1]
l   <- strip$layout$l[c(1, 3)]
r   <- strip$layout$r[c(2, 4)]

mat   <- matrix(vector("list", length = 6), nrow = 2)
mat[] <- list(zeroGrob())

# The separator for the facets has zero width
res <- gtable_matrix("toprow", mat, unit(c(1, 0, 1), "null"), unit(c(1, 1), "null"))

# Adding the first layer
zz <- res %>%
  gtable_add_grob(z$grobs[[locations[1]]]$grobs[[1]], 1, 1, 1, 3) %>%
  gtable_add_grob(z, ., t = top,  l = l[1],  b = top,  r = r[1], name = c("add-strip"))

# Adding the second layer (note the indices)
pp <- gtable_add_grob(res, z$grobs[[locations[3]]]$grobs[[1]], 1, 1, 1, 3) %>%
  gtable_add_grob(zz, ., t = top,  l = l[2],  b = top,  r = r[2], name = c("add-strip")) 



# Plotting
grid.newpage()
grid.draw(pp)










