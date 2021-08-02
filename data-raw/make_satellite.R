

library(tidyverse)
library(janitor)


# Read in data for lower troposphere (last accessed Aug-02-21). Row number 513
# is where the garbage starts, hence the limit to 512 rows.

x <- read_table(read_lines("https://www.nsstc.uah.edu/data/msu/v6.0/tmt/uahncdc_mt_6.0.txt", n_max = 512)) %>%
      clean_names() %>%
      rename(month = mo,
             "globe_land" = land,
             "globe_ocean" = ocean,
             "nh_land" = land_1,
             "nh_ocean" = ocean_1,
             "sh_land" = land_2,
             "sh_ocean" = sh_ocean,
             "tropics" = trpcs,
             "tropics_land" = land_3,
             "tropics_ocean" = ocean_3,
             "north_ext" = no_ext, # Any idea what "ext" could mean? I couldn't find a codebook.
             "north_ext_land" = land_4,
             "morth_ext_ocean" = ocean_4,
             "south_ext" = so_ext,
             "south_ext_land" = land_5,
             "south_ext_ocean" = ocean_5,
             "north_pole" = no_pol,
             "north_pole_land" = land_6,
             "north_pole_ocean" = ocean_6,
             "south_pole" = so_pol,
             "south_pole_land" = land_7,
             "south_pole_ocean" = ocean_7,
             "australia" = aust) # This is just a guess, but I can't think if any other option here.


# I don't think variables should be doubles if they only contain values that
# contain integers. This makes people think that something might be wrong with
# this data.

x %<>%
  mutate(year = as.integer(year),
         month = as.integer(month))

# Save.

satellite <- x
usethis::use_data(satellite, overwrite = TRUE)

