# The City of Lights
# 
# Graphing marine marauding using night lights
# at the edge of the world

# load required packages
library(tidyverse) # plotting and data wrangling
library(raster) # to load raster data exported from GEE
library(sf) # vector processing + plotting
library(rnaturalearth) # fetch geographic data
library(ggtext)

# load data (will take a while)
if(!exists("land")){
  source("analysis/load_data_peru.R")
}

# set colour theme
col_land <- "#333333"
col_water <- "#222222"
col_boundary <- "#585152"
col_ice <- "#5E625D"
col_road <- "#454545"

theme_map <- function(...) {
  theme_minimal() +
    theme(
      text = element_text(family = "Ubuntu Thin", color = "#C3C3C3"),
      axis.line = element_blank(),
      axis.text.x = element_text(color = "#333333"),
      axis.text.y = element_text(color = "#333333"),
      axis.ticks = element_line(color = "#333333"),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.major = element_line(color = "#444444", size = 0.2, linetype = 3),
      #panel.grid.minor = element_blank(),
      plot.background = element_rect(fill = "#222222", color = NA),
      panel.background = element_rect(fill = "#222222", color = "#222222"),
      #legend.position = "bottom",
      legend.direction = "horizontal",
      legend.position = c(.95, .95),
      legend.justification = c("right", "top"),
      #legend.background = element_rect(fill = "#f5f5f2", color = NA),
      #panel.border = element_rect(fill = col_water, colour = NA),
      ...
    ) 
}

p <- ggplot() +
  geom_tile(data = r_df, aes(x=x,y=y,fill= val)) +
  scale_fill_viridis_c(
    option = "B",
    name = "light intensity",
    labels = c("low","high"),
    breaks = c(2, 7)) +
  geom_sf(data = land, fill = col_land, color = NA) +
  guides(fill = guide_colourbar(title.position="top", title.hjust = 0.5)) +
  geom_sf(data = minor_islands, fill = col_land, color = NA) +
  geom_sf(data = ice, fill = col_ice, color = NA) +
  geom_sf(data = rivers, fill = NA, color = col_water) +
  geom_sf(data = lakes, fill = col_water, color = NA) +
  geom_sf(data = roads, fill = NA, color = col_road) +
  geom_sf(data = land_buffer, fill = NA, color = col_road, lty = 3) +
  geom_sf(data = country_boundary, fill = NA, color = col_road, lwd = 1.2) +
  geom_sf(data = country_boundary, fill = NA, color = col_boundary) +
  coord_sf(ylim = c(-20,-5),xlim = c(-90,-67)) +
  labs(
    title = "Vessel Lights - Peru",
    subtitle = "Illuminating fishing activity with onboard flood lights",
    caption = "graphics & analysis by @koen_hufkens") +
  theme_map()

ggsave(filename = "city_of_lights_peru.png", height = 9)
