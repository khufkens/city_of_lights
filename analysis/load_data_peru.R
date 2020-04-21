library(rnaturalearth)
library(tidyverse)
library(raster)
library(sf)

# read in raster data
# set 0 values to NA (transparent)
r <- raster("data/city_of_lights_peru.tif")
r[r==0] <- NA
r <- aggregate(r, fact = 3, fun = max)

# convert gridded raster data dataframe
r_df <- r %>%
  rasterToPoints %>%
  as.data.frame() %>%
  na.omit() %>%
  `colnames<-`(c("x", "y", "val"))

# download all layers
land <- ne_download(
  scale = "large",
  type = "land",
  category = "physical",
  returnclass = "sf"
)

minor_islands <- ne_download(
  scale = "large",
  type = "minor_islands",
  category = "physical",
  returnclass = "sf"
)

# quick subset of the land region using the
# raster bounding box (to calculate international waters)
land_mask <- st_intersection(land, st_as_sfc(st_bbox(r)))

# buffer by 220 km
land_ea <- st_transform(
  land_mask,
  crs = "+proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs")
land_buffer <- st_buffer(land_ea, 360000)
land_buffer <- st_transform(
  land_buffer,
  crs = "+init=epsg:4326")
land_buffer <- st_union(land_buffer)

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
