#### Load the required packages ####


install.packages('shiny')
library(shiny) # shiny features
install.packages('shinydashboard')
library(shinydashboard) # shinydashboard functions
install.packages('DT')
library(DT)  # for DT tables
install.packages('dplyr')
library(dplyr)  # for pipe operator & data manipulations
install.packages('plotly')
library(plotly) # for data visualization and plots using plotly 
install.packages('ggplot2')
library(ggplot2) # for data visualization & plots using ggplot2
install.packages('ggtext')
library(ggtext) # beautifying text on top of ggplot
install.packages('maps')
library(maps)   #  - boundaries used by ggplot for mapping
install.packages('ggcorrplot')
library(ggcorrplot) # for correlation plot
install.packages('shinycssloaders')
library(shinycssloaders) # to add a loader while graph is populating

#### Dataset Manipulation ####

#importing data world happiness report
library(readxl)
my_data <- read_excel("C:/Users/akank/Desktop/aggsh.xlsx")
View(my_data);#colnames(my_data)[2] ="State"


# Column names without Country. This will be used in the selectinput for choices in the shinydashboard
c1 = my_data %>% 
  select(-"State") %>% 
  names()

# Column names without Country and "Explained by: Freedom to make life choices" . This will be used in the selectinput for choices in the shinydashboard
c2 = my_data %>% 
  select(-"State", -"RANK") %>% 
  names()

####Preparing data for  Map ####
# map data for country boundaries using the maps package
# map_data from ggplot package
# map_data() converts data fom maps package into a dataframe which can be further used for mapping

state_map <- map_data("world") # world from maps package contains information required to create the  country boundaries
#View(state_map)




## Add the latitude, longitude and other info needed to draw the ploygon for the Country map
# For the country boundaries available - add the happiness data info.
# right_join from dplyr package
my_data2 <- read_excel("C:/Users/akank/Desktop/my_data2.xlsx")
merged =right_join(my_data2, state_map,  by=c("Country" = "region"))
#View(merged)

# Add State Abreviations and center locations of each country. Create a dataframe out of it
State=tolower(my_data2$Country)
st = data.frame(abb = latlong$abb,stname=latlong$State, x=latlong$x, y=latlong$y)
#View(st)

# Join the state abbreviations and center location to the dataset for each of the observations in the merged dataset
# left_join from dplyr package

new_join = left_join(merged, st , by=c("Country" = "stname"))
#View(new_join)




