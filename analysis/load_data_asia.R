library(rnaturalearth)
library(tidyverse)
library(raster)
library(sf)

# read in raster data
# set 0 values to NA (transparent)
r <- raster("data/city_of_lights_asia.tif")
r[r==0] <- NA
r <- aggregate(r, fact = 3, fun = max)

# download all layers
land <- ne_download(
  scale = "large",
  type = "land",
  category = "physical",
  returnclass = "sf"
)

# land_mask <- ne_download(
#   scale = "large",
#   type = "land",
#   category = "physical",
#   returnclass = "sp"
# )
# 
# r <- mask(r, land_mask, inverse = TRUE)
# gc()

# convert gridded raster data dataframe
r_df <- r %>%
  rasterToPoints %>%
  as.data.frame() %>%
  na.omit() %>%
  `colnames<-`(c("x", "y", "val"))

minor_islands <- ne_download(
  scale = "large",
  type = "minor_islands",
  category = "physical",
  returnclass = "sf"
)

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
