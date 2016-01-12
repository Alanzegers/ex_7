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
########################################
### Alan Zegers & Stijn Wijdeven
### Teamname*
### January 2016

### Exercise 7 Greenest city of the Netherlands

library(sp)
library(rgdal)
library(rgeos)
library(raster)
if(!require(leaflet)) {
	install.packages("leaflet")
}
library(leaflet)
### Download and unzip files
download.file(url = 'https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip', destfile = 'data/modis.zip', method = 'wget')
unzip('data/modis.zip', overwrite = TRUE, exdir = 'data/')


NDVI <- list.files(path='data/', pattern = glob2rx('*.grd'), full.names=TRUE)

NDVIstack <- stack(NDVI)

nlCity <- raster::getData('GADM',country='NLD', level=2, path= 'data/') 
nlCity@data <- nlCity@data[!is.na(nlCity$NAME_2),] 
Lvl2Contour <- spTransform(nlCity, CRS(proj4string(NDVIstack)))

NDVIMask <-mask(NDVIstack, Lvl2Contour)
plot(NDVIMask)

NDVIJan <- NDVIMask[[1]]
NDVIAug <- NDVIMask[[8]]

January <- NDVIMask$January
August <- NDVIMask$August


plot(NDVIAug)
plot(Lvl2Contour, add=T)

#Calculate average
NDVIavg <- calc(NDVIMask, fun=mean)


#Extract
ExtractJan <- extract(NDVIJan, Lvl2Contour, df=TRUE, fun=mean)
ExtractAug <- extract(NDVIAug, Lvl2Contour, df=TRUE, fun=mean)
Extractavg <- extract(NDVIavg, Lvl2Contour, df=TRUE, fun=mean)

##Find cities
#january
MaxJan <- subset(ExtractJan, ExtractJan$January == max(ExtractJan$January, na.rm = TRUE))
IDfind <- subset(Lvl2Contour, Lvl2Contour$ID_2 == MaxJan[,1])
city_january <- IDfind$NAME_2
#augustus
MaxAug <- subset(ExtractAug, ExtractAug$August == max(ExtractAug$August, na.rm = TRUE))
IDfind2 <- subset(Lvl2Contour, Lvl2Contour$ID_2 == MaxAug[,1])
city_august <- IDfind2$NAME_2
#average
Maxavg <- subset(Extractavg, Extractavg$layer == max(Extractavg$layer, na.rm = TRUE))
IDfind3 <- subset(Lvl2Contour, Lvl2Contour$ID_2 == Maxavg[,1])
city_average <- IDfind3$NAME_2

### print city name 
paste("The greenest city in January is", city_january, 
			", The greenest city in August is", city_august,  
			", The greenest city overall is", city_average)
### Plot
#test
plot(Maxavg)
leaflet()

plotmap <- leaflet()
plotmap <- addTiles(plotmap)
plotmap <- addPolygons(plotmap,data = nlCity, opacity = 2, color = "Green", weight = 1, fillColor = "white") # To view the specified region  
spplot(Lvl2Contour, zcol= Extractavg)
plotmap
spplot(NDVIJan, zcol = 'January', main = 'January NDVI')
spplot(NDVIAug, zcol = 'August', main = 'August NDVI', add=T)
spplot(Lvl2Contour, add=TRUE)
