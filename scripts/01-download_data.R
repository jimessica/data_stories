#### Preamble ####
# Purpose: Download, Save, and Read Fire Inspection in Highrises Data and Ward Data
# Author: Jessica Im
# Email: jessica.im@mail.utoronto.ca
# Date: 22 January 2024


#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(knitr)
library(janitor)
library(lubridate)
library(readxl)


#### Acquire ####

# Download Highrise Fire Inspection Data
# Based on code from https://open.toronto.ca/dataset/highrise-residential-fire-inspection-results/
package <- show_package("f816b362-778a-4480-b9ed-9b240e0fe9c2")
package
resources <- list_package_resources("f816b362-778a-4480-b9ed-9b240e0fe9c2")
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))
highrise_fire_inspection_data <- filter(datastore_resources, row_number()==1) %>% get_resource()
highrise_fire_inspection_data

# Save Highrise Fire Inspection Data
write_csv(
  x = highrise_fire_inspection_data,
  file = "inputs/data/unedited_fire_inspection_data.csv"
)

# Read Highrise Fire Inspection Data
readr::read_csv("inputs/data/unedited_fire_inspection_data.csv")


# Download Ward Data
# Data found at: https://open.toronto.ca/dataset/ward-profiles-25-ward-model/
# Code referenced from Rohan Alexander on Piazza: https://piazza.com/class/lrja9wmteoj28u/post/10
download.file(url = "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/6678e1a6-d25f-4dff-b2b7-aa8f042bc2eb/resource/16a31e1d-b4d9-4cf0-b5b3-2e3937cb4121/download/2023-WardProfiles-2011-2021-CensusData.xlsx",
              destfile = "raw_data.xlsx")
toronto_ward_data <- 
  read_excel("raw_data.xlsx", sheet = "2021 One Variable")


# Save Ward Data
write_csv(
  x = toronto_ward_data,
  file = "inputs/data/unedited_ward_data.csv"
)

# Read Highrise Toornto Ward Data
readr::read_csv("inputs/data/unedited_ward_data.csv")
