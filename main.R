### Alan Zegers & Stijn Wijdeven
### Teamname*
### January 2016

### Exercise 7 Greenest city of the Netherlands

library(sp)
library(rgdal)
library(rgeos)
library(raster)

### Download and unzip files
download.file(url = 'https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip', destfile = 'data/modis.zip', method = 'wget')
unzip('data/modis.zip', overwrite = TRUE, exdir = 'data/')


NDVI <- list.files(path='data/', pattern = glob2rx('*.grd'), full.names=TRUE)

NDVIstack <- stack(NDVI)

nlCity <- raster::getData('GADM',country='NLD', level=2)
nlCity@data <- nlCity@data[!is.na(nlCity$NAME_2),] 
Lvl2Contour <- spTransform(nlCity, CRS(proj4string(NDVIstack)))

NDVIJan <- NDVIstack[[1]]
NDVIAug <- NDVIstack[[8]]
plot(NDVIAug)
plot(Lvl2Contour, add=T)


##
NDVICrop <- crop(NDVIbrick, Level2Contour)
plot(NDVICrop)
NDVISub <- mask(NDVIbrick, Level2Contour)

class(Level2Contour)
plot(Level2Contour, add=T)
