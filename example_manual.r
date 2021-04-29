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
mapview::mapview(df)
