

library(tidyverse)
library(magrittr)
library(janitor)
library(lubridate)

# This is data from an online retail company in the UK:
# https://archive.ics.uci.edu/ml/datasets/online+retail.
# Covers data from 2010 and 2011.

x <- read_excel("data-raw/Online Retail.xlsx") %>%
        clean_names()


# Rename and reclassify variables.

x %<>%
  rename(invoice = invoice_no) %>%
  mutate(invoice = as.integer(invoice),
         quantity = as.integer(quantity),
         customer_id = as.integer(customer_id))


# Fix product description.

x %<>%
  mutate(description = str_to_title(description),
         description = gsub('\\.$', '', description))


# Save

retail <- x

usethis::use_data(retail, overwrite = T)

