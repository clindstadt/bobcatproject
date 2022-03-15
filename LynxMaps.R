library(sf)
library(sp)
library(tmap)
library(tmaptools)
library(rgdal)
library(raster)
library(tidyverse)
library(units)
library(rgeos)
library(dplyr)
setwd("/Users/clair/OneDrive/Documents/Senior Year/RScripts/FinalProject")
LynxExcel <- read.csv("Coyote Valley Bobcat Habitat Connectivity Study.csv")
# Removing columns with no values
LynxExcel$bar.barometric.pressure <- NULL 
LynxExcel$data.decoding.software <- NULL
LynxExcel$eobs.activity <- NULL
LynxExcel$eobs.activity.samples <- NULL
LynxExcel$gps.dop <- NULL
LynxExcel$gps.satellite.count <- NULL
LynxExcel$manually.marked.outlier <- NULL
LynxExcel$eobs.acceleration.axes <- NULL
LynxExcel$eobs.acceleration.sampling.frequency.per.axis <- NULL
LynxExcel$eobs.accelerations.raw <- NULL
# Having done that, we can correct for measurements with missing gps data
LynxNeat <- na.omit(LynxExcel)
write.csv(LynxNeat, "LynxNeat.csv")
LynxNeat <- st_as_sf(LynxNeat, coords = c("location.long", "location.lat"), 
                     crs = 4326, agr = "constant")
LynxNeat
LynxNeat
#Divide LynxSF into however many separate sheets per individual
LynxBuddies <- split(LynxNeat, f = LynxNeat$tag.local.identifier)
Lynx5625df <- LynxBuddies$`5625`
Lynx5619df <- LynxBuddies$`5619`
Lynx5622df <- LynxBuddies$`5622`
Lynx5623df <- LynxBuddies$`5623`
Lynx5624df <- LynxBuddies$`5624`
Lynx5626df <- LynxBuddies$`5626`
Lynx5627df <- LynxBuddies$`5627`
Lynx5628df <- LynxBuddies$`5628`

#Maps per animal
tmap_mode("view")
Lynx5625 <- tm_shape(Lynx5625df) + tm_dots(size = 0.01, col = "individual.local.identifier", palette = "Reds")
Lynx5627 <- tm_shape(Lynx5627df) + tm_dots(size = 0.01, col = "individual.local.identifier")
Lynx5624 <- tm_shape(Lynx5624df) + tm_dots(size = 0.01, col = "individual.local.identifier", palette = "Blues")
Lynx5619 <- tm_shape(Lynx5619df) + tm_dots(size = 0.01, col = "individual.local.identifier", palette = "Purples")

#loading parks map
ParksSCC <- st_read("geo_export_5e39d201-b9b9-4055-9f8c-65184a956ac3.shp")
ParksSCC <- st_as_sf(ParksSCC, crs = 4326, agr = "constant")
ParksSCC <- st_make_valid(ParksSCC)
boundary <- st_bbox(ParksSCC %>% filter(park_name %in% c("Calero Co. Pk.", "Coyote Creek Parkway (South) Co. Pk.")))
ParksMap <-tm_shape(ParksSCC, bbox = boundary) + tm_borders(col = "Red",lwd = 3) +tm_basemap(server = "CartoDB.Positron")
ParksMap

#loading county boundary
CountyBounds <- st_read("County_Boundary__Area_.shp")
CountyBounds <- st_transform(CountyBounds, crs = 4326)
CountyBounds <- st_make_valid(CountyBounds)

#loading land use maps
LandUse <- st_read("Land_Cover.shp")
LandUse <- st_transform(LandUse, crs = 4326)
LandUse <- st_make_valid(LandUse)
LandUseMap <- tm_shape(LandUse, bbox = boundary) + tm_polygons(col = "NATURALCOV", palette = "Greens") + tm_basemap(server = "Esri.WorldImagery") +
  tm_layout(legend.outside = TRUE)
tmap_options(check.and.fix = TRUE) 
LandUseMap

#loading collective maps
EnviroMap <- LandUseMap + ParksMap 
L5624 <- EnviroMap + Lynx5624
L5625 <- EnviroMap + Lynx5625
L5627 <- EnviroMap + Lynx5627
L5619 <- EnviroMap + Lynx5619


