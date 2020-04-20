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
  source("analysis/load_data.R")
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

# labels
df <- data.frame(
  label = "Cummulative night light intensity (2013 - 2019) 
  as measured by the VIIRS sensors on the Suomi satellite to 
  the north of the Falklands / Malvinas, showing nighttime squid
  fishing with flood lights. High values indicate high vessel density
  and activity.
  
  Flood lights on fishing vessels attract plankton and other fish
  on which the squid feed. Currents and upwelling along the shelfbreak
  to the north and east of the islands make this a fertile ground with
  abundant nutrients for squid and other species. The fishing patterns
  therefore track the location of these currents, and the location of
  the shelfbreak.
  
  Sadly, a lot of these fishing vessels are operated by
  East Asian companies, which take large liberties with respect to labour laws.
  To operate with inpunity toward both labour and fishery laws vessels consistently
  avoid both territorial and continuous waters
  (dotted line) around the Falklands / Malvinas. The disputed state
  of these islands, and their surrounding waters, further foster lawlessness.
  ",
  x = -49.5,
  y = -50,
  hjust = 1,
  vjust = 0,
  orientation = "upright",
  color = "#C3C3C3",
  fill = col_water
)

p <- ggplot() +
  geom_sf(data = land, fill = col_land, color = NA) +
  xlim(c(-75, -45)) +
  ylim(c(-56,-44)) +
  geom_tile(data = r_df, aes(x=x,y=y,fill= val)) +
  scale_fill_viridis_c(
    option = "B",
    name = "light intensity",
    labels = c("low","high"),
    breaks = c(4, 7)) +
  guides(fill = guide_colourbar(title.position="top", title.hjust = 0.5)) +
  geom_sf(data = minor_islands, fill = col_land, color = NA) +
  geom_sf(data = ice, fill = col_ice, color = NA) +
  geom_sf(data = rivers, fill = NA, color = col_water) +
  geom_sf(data = lakes, fill = col_water, color = NA) +
  geom_sf(data = roads, fill = NA, color = col_road) +
  geom_sf(data = falklands_buffer_44, fill = NA, color = col_road, lty = 3) +
  geom_sf(data = country_boundary, fill = NA, color = col_road, lwd = 1.2) +
  geom_sf(data = country_boundary, fill = NA, color = col_boundary) +
  labs(
    title = "The City of Lights",
    subtitle = "Fishing for squid at the edge of the world",
    caption = "graphics & analysis by @koen_hufkens") +
  theme_map()

p2 <- p + geom_textbox(
  data = df,
  aes(x, y, label = label),
  color = "#C3C3C3",
  fill = "#222222",
  width = unit(0.25, "npc"))

ggsave(filename = "city_of_lights.png", width = 13)
#knitr::plot_crop("test.pdf")
