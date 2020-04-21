// Night time fishing activity, based upon raw night lights
// data from VIIRS
var north_falklands =
    ee.Geometry.Polygon(
        [[[-69.89166405856476, -43.85981644880141],
          [-69.89166405856476, -56.23841598639375],
          [-52.88482812106475, -56.23841598639375],
          [-52.88482812106475, -43.85981644880141]]], null, false);

var east_asia = 
    ee.Geometry.Polygon(
        [[[97.56122782155632, 22.62921049306035],
          [97.56122782155632, -1.9826494601161213],
          [125.15888407155632, -1.9826494601161213],
          [125.15888407155632, 22.62921049306035]]], null, false);

var peru = 
    ee.Geometry.Polygon(
        [[[-90.73116307204577, -2.2039423006318732],
          [-90.73116307204577, -24.533703500433436],
          [-67.61592869704577, -24.533703500433436],
          [-67.61592869704577, -2.2039423006318732]]], null, false);

// grab the VIIRS nighttime data collection for all available full years
var nighttime = ee.ImageCollection('NOAA/VIIRS/DNB/MONTHLY_V1/VCMCFG')
                  .filterDate('2013-01-01', '2019-12-31')
                  .select('avg_rad');

// sum over all years, values > 1000 (7 log scale)
// are truncated, values < 2.2 are clipped a the bottom
// (i.e. background light on land)
// values are truncated to >55 nanoWatts/cm2/sr cummulative
// and 1096 nanoWatts/cm2/sr or more
var nighttime_sum = nighttime.reduce(ee.Reducer.sum()).log();
nighttime_sum = nighttime_sum.where(nighttime_sum.gt(7), 7);
nighttime_sum = nighttime_sum.where(nighttime_sum.lt(2), 0);

// visualize everything
var nighttimeVis = {min: 0.0, max: 10.0};
Map.setCenter(110,10, 5);
Map.addLayer(nighttime_sum, nighttimeVis, 'Nighttime');

// export the image, specifying scale and region.
Export.image.toDrive({
  image: nighttime_sum,
  description: 'city_of_lights',
  scale: 300,
  maxPixels: 6e9,
  region: north_falklands
});

Export.image.toDrive({
  image: nighttime_sum,
  description: 'city_of_lights_asia',
  scale: 300,
  maxPixels: 6e9,
  region: east_asia
});

Export.image.toDrive({
  image: nighttime_sum,
  description: 'city_of_lights_peru',
  scale: 300,
  maxPixels: 6e9,
  region: peru
});