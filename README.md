# The City of Lights

This is the code and data to make a figure inspired by reading The Outlaw Ocean by Ian Urbina. In this book he mentions “the city of lights”, a (squid) fishing ground to the north of the Falklands. Illegal fishing vessels in this area light up the ocean to attract / catch squid. Being stuck inside I made a first pass of a map of this.

As you can see below, the statement in the book is certainly not figurative. One can indeed see these flood lights from space. They trace nicely along the shelfbreak and dominant currents in the area, which provide ample food for the squid. For the mini story I refer to the annotations on the figure below!

The data was sourced from the Suomi NPP satellite VIIRS nigthttime sensors. I took a cummulative sum of all values across 6 years of data. So, the intensity of the light across all years is roughly indicative of fishing vessel presence.

The whole map was made in R using ggplot2 and was in part an exercise in making a glossy magazine style figure. I still need to add some labels and clean up the text. But, I think this came out nicely, while at the same time brushing up my (ggplot2) mapping skills.

![](https://raw.githubusercontent.com/khufkens/city_of_lights/master/city_of_lights.png)