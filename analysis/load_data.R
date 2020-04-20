library(rnaturalearth)
library(tidyverse)
library(raster)
library(sf)

# read in raster data
# set 0 values to NA (transparent)
r <- raster("data/city_of_lights.tif")
r[r==0] <- NA

# download all layers
land <- ne_download(
  scale = "large",
  type = "land",
  category = "physical",
  returnclass = "sf"
)

land_mask <- ne_download(
  scale = "small",
  type = "land",
  category = "physical",
  returnclass = "sp"
)

r <- mask(r, land_mask, inverse = TRUE)

# convert gridded raster data dataframe
r_df <- r %>%
  rasterToPoints %>%
  as.data.frame() %>%
  `colnames<-`(c("x", "y", "val"))

minor_islands <- ne_download(
  scale = "large",
  type = "minor_islands",
  category = "physical",
  returnclass = "sf"
)

box <- st_read("data/falklands_bbox.shp")
falklands <- st_intersection(land, box)
falklands_minor_islands <- st_intersection(minor_islands, box)
falklands <- st_union(falklands, falklands_minor_islands)

# buffer by 22 km
falklands_ea <- st_transform(
  falklands,
  crs = "+proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs")
falklands_buffer_22 <- st_buffer(falklands_ea, 22200)
falklands_buffer_22 <- st_union(falklands_buffer_22)
falklands_buffer_44 <- st_buffer(falklands_buffer_22, 22200)
falklands_buffer_44 <- st_union(falklands_buffer_44)
falklands_buffer_22 <- st_transform(
  falklands_buffer_22,
  crs = "+init=epsg:4326")
falklands_buffer_44 <- st_transform(
  falklands_buffer_44,
  crs = "+init=epsg:4326")

country_boundary <- ne_download(
  scale = "large",
  type = "boundary_lines_land",
  returnclass = "sf"
)

lakes <- ne_download(
  scale = "large",
  type = "lakes",
  category = "physical",
  returnclass = "sf"
)

rivers <- ne_download(
  scale = "large",
  type = "rivers_lake_centerlines",
  category = "physical",
  returnclass = "sf"
)

ice <- ne_download(
  scale = "large",
  type = "glaciated_areas",
  category = "physical",
  returnclass = "sf"
)

roads <- ne_download(
  scale = "large",
  type = "roads",
  returnclass = "sf"
)

roads <- roads %>%
  filter(
    type != "Ferry, seasonal",
    type != "Unknown",
    type != "Track")
