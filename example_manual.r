library(httr)
library(jsonlite)
library(tidyverse)

res <- GET("https://cagisonline.hamilton-co.org/arcgis/rest/services/COUNTYWIDE/CagisCoreLayers/MapServer/3/query?where=1%3D1&outFields=SHAPE,NEWADDR&outSR=4326&f=json")
dat <- content(res, as = "text", encoding = "UTF-8")
df <- fromJSON(dat, flatten = TRUE) %>%
  data.frame()
df <- df %>%
  filter(!is.na(features.attributes.NEWADDR)) %>%
  select(address = features.attributes.NEWADDR, lon = features.geometry.x, lat = features.geometry.y)
df <- sf::st_as_sf(df, coords = c('lon', 'lat'), crs = 4326)

mapview::mapviewOptions(fgb = F)
ex_map<-mapview::mapview(df)
htmlwidgets::saveWidget(ex_map@map, file = "ex_map.html")

mapview::mapshot(ex_map, file = "ex_map.png")
options(scipen = 99)

remotes::install_github("r-spatial/mapview")

library(tmap)
tmap_mode("view")

ex_map<-tm_basemap("CartoDB.Positron") +
  tm_shape(df)+
  tm_dots(col="address", palette = "viridis", size = .08)
ex_map

tmap_save(ex_map, "ex_map.png")

ex_map %>%
  tmap_leaflet() %>%
  htmlwidgets::saveWidget(file = "ex_map.html")

#https://data-cagisportal.opendata.arcgis.com/datasets/cincinnati-police-departments/geoservice?selectedAttribute=ADDRESS


