#######################Division-wise Bangladesh Map of EBF##########################
#                            Mohammad Nayeem Hasan                                 #
####################################################################################

require(foreign)
require(MASS)
require(pROC)
require(survey)
require(ResourceSelection)
require(ROCR)
require(car)
require(ggplot2)
require(maptools)
library(nnet)
library(FSA)
library(caret)
require(mapproj)
require(rgdal)
require(car)

#graph2
q <- readShapeSpatial('bgd_admbnda_adm1_bbs_20180410.shp')
q_1 <- fortify(q)


deaths <- read.csv("E:\\ResearchProject\\Jamal Sir\\Breastfeed\\Deaths.csv")

q_1$prev <- ifelse(q_1$id==0,deaths$Deaths[1],
                   ifelse(q_1$id==1,deaths$Deaths[2],
                          ifelse(q_1$id==2,deaths$Deaths[3],
                                 ifelse(q_1$id==3,deaths$Deaths[4],
                                        ifelse(q_1$id==4,deaths$Deaths[5],
                                               ifelse(q_1$id==5,deaths$Deaths[6],
                                                      ifelse(q_1$id==6,deaths$Deaths[7],deaths$Deaths[8])))))))


centroids.df <- as.data.frame(coordinates(q))
names(centroids.df) <- c("Longitude", "Latitude")
centroids.df$name <- c('    Barisal',
                       'Chittagong\n',
                       'Dhaka','Khulna\n',
                       'Mymensingh\n',
                       'Rajshahi',
                       'Rangpur\n','Sylhet')


ggplot(q_1, aes(x=long, y=lat)) +geom_polygon(aes(group=group,fill=prev),colour= "lightgrey")+coord_map()+
  geom_text(data=centroids.df,aes(label = name, x = Longitude, y = Latitude),color='black',size=3.5)+
  scale_fill_distiller(name='CFR (%)',palette ="YlOrRd", direction=1)+
  theme(legend.text = element_text(size = 8))+
  theme_void()

