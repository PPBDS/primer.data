

library(tidyverse)
library(janitor)

# This data contains monthly temperature deviations in °C from the respective
# average temperature in a region during 1991-2020. The data from before 1991
# initally used another reference time period, but values were re-calculated
# later on. Note: the variable us49 excludes Hawaii, apparently since "its land
# area is less than that of a satellite grid square, so it would have virtually
# no impact on the overall national results."

# Read in data for lower troposphere (last accessed Aug-04-21). Row number 513
# is where the garbage starts, hence the limit to 512 rows.

x <- read_table(read_lines("https://www.nsstc.uah.edu/data/msu/v6.0/tmt/uahncdc_mt_6.0.txt", n_max = 512)) %>%
      clean_names() %>%
      rename(month = mo,
             "globe_land" = land,
             "globe_ocean" = ocean,
             "nh_land" = land_1,
             "nh_ocean" = ocean_1,
             "sh_land" = land_2,
             "sh_ocean" = ocean_2,
             "tropics" = trpcs,
             "tropics_land" = land_3,
             "tropics_ocean" = ocean_3,
             "north_ext" = no_ext, # ext stands for extratropics. Should we keep it that way?
             "north_ext_land" = land_4,
             "north_ext_ocean" = ocean_4,
             "south_ext" = so_ext,
             "south_ext_land" = land_5,
             "south_ext_ocean" = ocean_5,
             "north_pole" = no_pol,
             "north_pole_land" = land_6,
             "north_pole_ocean" = ocean_6,
             "south_pole" = so_pol,
             "south_pole_land" = land_7,
             "south_pole_ocean" = ocean_7,
             "australia" = aust)


# I don't think variables should be doubles if they only contain values that
# contain integers. This makes people think that something might be wrong with
# this data.

x %<>%
  mutate(year = as.integer(year),
         month = as.integer(month))

# Save.

temperature <- x
usethis::use_data(temperature, overwrite = TRUE)

